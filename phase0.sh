#!/usr/bin/env bash
set -e

# =========================
# CONFIG
# =========================
APP_NAME="epic-manager"
BACKEND_DIR="epic-manager-backend"
FRONTEND_DIR="epic-manager-ui"
GROUP_ID="com.machine22"
ARTIFACT_ID="epic-manager"
PACKAGE_NAME="com.machine22.epicmanager"
SPRING_BOOT_VERSION="3.4.0"

# build query as ONE string (Git Bash prefers this)
SPRING_QUERY="type=maven-project&language=java&bootVersion=${SPRING_BOOT_VERSION}&baseDir=${ARTIFACT_ID}&groupId=${GROUP_ID}&artifactId=${ARTIFACT_ID}&name=Epic%20Manager&packageName=${PACKAGE_NAME}&javaVersion=17&dependencies=web,data-mongodb,validation,lombok"
SPRING_URL="https://start.spring.io/starter.zip?${SPRING_QUERY}"

echo ">>> Creating project root: ${APP_NAME}"
mkdir -p "${APP_NAME}"
cd "${APP_NAME}"

# ============================================================
# 1) BACKEND
# ============================================================
echo ">>> Creating backend folder: ${BACKEND_DIR}"
mkdir -p "${BACKEND_DIR}"
cd "${BACKEND_DIR}"

echo ">>> Downloading Spring Boot skeleton from start.spring.io ..."
# try curl first
DOWNLOAD_OK=0
if command -v curl >/dev/null 2>&1; then
  # -f = fail on error, -S = show error, -L = follow redirects, -o = output
  if curl -fSL "${SPRING_URL}" -o starter.zip; then
    DOWNLOAD_OK=1
  fi
fi

# fallback to wget
if [ $DOWNLOAD_OK -eq 0 ]; then
  if command -v wget >/dev/null 2>&1; then
    if wget -O starter.zip "${SPRING_URL}"; then
      DOWNLOAD_OK=1
    fi
  fi
fi

if [ $DOWNLOAD_OK -eq 0 ]; then
  echo "!!! ERROR: Could not download Spring Boot project from start.spring.io"
  echo ">>> URL I tried:"
  echo "${SPRING_URL}"
  echo ">>> Try opening that URL in the browser and saving as starter.zip in $(pwd)"
  exit 1
fi

# quick sanity check: if the file starts with '<' it's HTML, not ZIP
if head -c 1 starter.zip | grep -q "<"; then
  echo "!!! ERROR: Downloaded file looks like HTML, not a ZIP."
  echo "    This usually happens on Windows Git Bash when the request is malformed."
  echo "    Open this in your browser and download manually:"
  echo "    ${SPRING_URL}"
  exit 1
fi

echo ">>> Unzipping Spring Boot project ..."
unzip -q starter.zip
rm starter.zip

echo ">>> Writing application.yml ..."
cat > src/main/resources/application.yml << 'EOF'
spring:
  application:
    name: epic-manager
  data:
    mongodb:
      host: localhost
      port: 27017
      database: epic_manager_db
server:
  port: 8080
EOF

echo ">>> Creating Epic domain ..."
EPIC_PKG_DIR=src/main/java/$(echo "${PACKAGE_NAME}" | tr '.' '/')/epic
mkdir -p "${EPIC_PKG_DIR}"

cat > "${EPIC_PKG_DIR}"/Epic.java << 'EOF'
package com.machine22.epicmanager.epic;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("epics")
public class Epic {
    @Id
    private String id;
    private String name;
    private String description;
    private String status;

    public Epic() {}

    public Epic(String name, String description, String status) {
        this.name = name;
        this.description = description;
        this.status = status;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
EOF

cat > "${EPIC_PKG_DIR}"/EpicRepository.java << 'EOF'
package com.machine22.epicmanager.epic;

import org.springframework.data.mongodb.repository.MongoRepository;

public interface EpicRepository extends MongoRepository<Epic, String> {
}
EOF

cat > "${EPIC_PKG_DIR}"/EpicController.java << 'EOF'
package com.machine22.epicmanager.epic;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/epics")
@CrossOrigin(origins = "http://localhost:4200")
public class EpicController {

    private final EpicRepository epicRepository;

    public EpicController(EpicRepository epicRepository) {
        this.epicRepository = epicRepository;
    }

    @GetMapping
    public List<Epic> all() {
        return epicRepository.findAll();
    }

    @PostMapping
    public Epic create(@RequestBody Epic epic) {
        if (epic.getStatus() == null || epic.getStatus().isBlank()) {
            epic.setStatus("NEW");
        }
        return epicRepository.save(epic);
    }
}
EOF

echo ">>> Creating backend runner script ..."
cat > run-backend.sh << 'EOF'
#!/usr/bin/env bash
./mvnw spring-boot:run
EOF
chmod +x run-backend.sh

cd ..

# ============================================================
# 2) FRONTEND (Angular)
# ============================================================
echo ">>> Generating Angular app: ${FRONTEND_DIR}"
# assumes: ng is installed
ng new "${FRONTEND_DIR}" --routing --style=scss --skip-git=true

cd "${FRONTEND_DIR}"

echo ">>> Creating Epic service ..."
cat > src/app/epic.service.ts << 'EOF'
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Epic {
  id?: string;
  name: string;
  description: string;
  status?: string;
}

@Injectable({
  providedIn: 'root'
})
export class EpicService {
  private baseUrl = 'http://localhost:8080/api/epics';

  constructor(private http: HttpClient) {}

  getEpics(): Observable<Epic[]> {
    return this.http.get<Epic[]>(this.baseUrl);
  }

  createEpic(epic: Epic): Observable<Epic> {
    return this.http.post<Epic>(this.baseUrl, epic);
  }
}
EOF

echo ">>> Overwriting app.module.ts ..."
cat > src/app/app.module.ts << 'EOF'
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
EOF

echo ">>> Overwriting app.component.ts ..."
cat > src/app/app.component.ts << 'EOF'
import { Component, OnInit } from '@angular/core';
import { Epic, EpicService } from './epic.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html'
})
export class AppComponent implements OnInit {
  title = 'Epic Manager UI';
  epics: Epic[] = [];
  newEpic: Epic = { name: '', description: '' };

  constructor(private epicService: EpicService) {}

  ngOnInit(): void {
    this.loadEpics();
  }

  loadEpics(): void {
    this.epicService.getEpics().subscribe(data => this.epics = data);
  }

  addEpic(): void {
    if (!this.newEpic.name) return;
    this.epicService.createEpic(this.newEpic).subscribe(_ => {
      this.newEpic = { name: '', description: '' };
      this.loadEpics();
    });
  }
}
EOF

echo ">>> Overwriting app.component.html ..."
cat > src/app/app.component.html << 'EOF'
<div class="container" style="max-width: 720px; margin: 2rem auto;">
  <h1>{{ title }}</h1>

  <div style="margin-bottom: 1.5rem;">
    <input [(ngModel)]="newEpic.name" placeholder="Epic name" />
    <input [(ngModel)]="newEpic.description" placeholder="Description" />
    <button (click)="addEpic()">Add Epic</button>
  </div>

  <ul>
    <li *ngFor="let epic of epics">
      <strong>{{ epic.name }}</strong> – {{ epic.description }} ({{ epic.status || 'NEW' }})
    </li>
  </ul>
</div>
EOF

echo ">>> Creating frontend runner script ..."
cat > run-frontend.sh << 'EOF'
#!/usr/bin/env bash
npm install
npm run start
EOF
chmod +x run-frontend.sh

cd ../..

echo ">>> Phase 0 complete."
echo "Next:"
echo "1) Make sure MongoDB is running on localhost:27017"
echo "2) cd ${APP_NAME}/${BACKEND_DIR} && ./run-backend.sh"
echo "3) cd ${APP_NAME}/${FRONTEND_DIR} && ./run-frontend.sh"
