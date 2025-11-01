# Epic Manager – Task List

## Phase 0 – Foundations
- [ ] Create monorepo or two-repo structure
- [ ] Initialize backend project
- [ ] Initialize frontend project
- [ ] Add ESLint/Prettier (or equivalent)
- [ ] Add CI pipeline (lint + unit tests)
- [ ] Add README with setup steps

## Phase 1 – Auth & Users (FR-1)
- [ ] Define `User` model/entity
- [ ] Create auth endpoints: `POST /auth/signup`, `POST /auth/login`, `POST /auth/logout`
- [ ] Implement password hashing
- [ ] Implement JWT issuing and verification middleware
- [ ] Add role field to user
- [ ] Add middleware to inject current user into request
- [ ] Frontend: login form
- [ ] Frontend: store token and attach to requests

## Phase 2 – Projects (FR-2)
- [ ] Define `Project` entity: id, name, description, owner_id
- [ ] Define `ProjectMember` entity: project_id, user_id, role
- [ ] API: `POST /projects`
- [ ] API: `GET /projects` (for current user)
- [ ] API: `POST /projects/{id}/members`
- [ ] Enforce project scoping middleware
- [ ] Frontend: project selector (top bar)
- [ ] Frontend: create project form

## Phase 3 – Epics (FR-3)
- [ ] Define `Epic` entity
- [ ] API: `POST /projects/{id}/epics`
- [ ] API: `GET /projects/{id}/epics`
- [ ] API: `GET /epics/{id}`
- [ ] API: `PATCH /epics/{id}`
- [ ] API: `PATCH /epics/{id}/archive`
- [ ] Add filters: `?status=...&priority=...`
- [ ] Frontend: Epics list view (table or Kanban)
- [ ] Frontend: Epic create/edit modal

## Phase 4 – Stories (FR-4)
- [ ] Define `Story` entity
- [ ] API: `POST /epics/{id}/stories`
- [ ] API: `GET /epics/{id}/stories`
- [ ] API: `PATCH /stories/{id}`
- [ ] Frontend: Epic detail → list stories
- [ ] Frontend: create/edit story
- [ ] (Optional) Move story to another epic

## Phase 5 – Tasks (FR-5)
- [ ] Define `Task` entity
- [ ] API: `POST /stories/{id}/tasks`
- [ ] API: `GET /stories/{id}/tasks`
- [ ] API: `PATCH /tasks/{id}` (status, assignee)
- [ ] Enforce: assignee must be project member
- [ ] Frontend: show tasks for story
- [ ] Frontend: assign user dropdown
- [ ] Frontend: “My tasks” view (GET /me/tasks)

## Phase 6 – Tracking & Search (FR-6, FR-7)
- [ ] API: `GET /projects/{id}/dashboard` (counts, progress)
- [ ] Compute epic progress = done_tasks / total_tasks (in stories)
- [ ] API: `GET /search?q=...`
- [ ] Support filter: type=epic|story|task
- [ ] Frontend: dashboard page
- [ ] Frontend: global search bar

## Phase 7 – Polish
- [ ] Add OpenAPI/Swagger
- [ ] Add error response format
- [ ] Add seed data script
- [ ] Write developer onboarding doc
