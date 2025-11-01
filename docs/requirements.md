# Epic Manager – Requirements

## 1. Purpose
Build a web-based project management tool to organize work in three levels:
1. Epics (big initiatives)
2. Stories (functional slices under an epic)
3. Tasks (atomic units of work, assignable, trackable)

Target: small teams / personal productivity users.

## 2. Scope
- Manage epics, stories, and tasks
- Track status and progress
- Organize projects/workspaces
- Support basic team collaboration (users + roles)

Out of scope (v1):
- Advanced analytics/burndown
- Complex workflows (Jira-style automation)
- Integrations (Slack, GitHub) – leave as extension points

## 3. Functional Requirements

### 3.1 Authentication & Authorization (FR-1)
- Users can sign up, sign in, sign out
- Password-based auth (OAuth is optional for v1)
- Roles: `owner`, `member`
- Owners can manage projects and epics
- Members can view and update tasks they’re assigned to

### 3.2 Project / Workspace Management (FR-2)
- Create a project/workspace
- List projects the user belongs to
- Switch active project
- Each project has: name, description, owner, members

### 3.3 Epic Management (FR-3)
- Create, read, update, archive epics
- Epic fields: `id`, `project_id`, `title`, `description`, `status` (proposed, in-progress, done, archived), `priority`, `created_at`, `updated_at`
- View all epics in a project
- Filter/sort by status, priority

### 3.4 Story Management (FR-4)
- Create stories **inside** an epic
- Story fields: `id`, `epic_id`, `title`, `description`, `status` (todo, in-progress, done), `assignee`, `estimate`
- List stories by epic
- Reassign/move stories between epics (optional v1.1)

### 3.5 Task Management (FR-5)
- Create tasks **inside** a story
- Task fields: `id`, `story_id`, `title`, `description`, `assignee`, `status` (todo, in-progress, blocked, done), `due_date`
- Mark task as done
- Comment / activity log (optional for v1)

### 3.6 Status & Progress Tracking (FR-6)
- Show progress per epic = % stories done OR % tasks done
- Show project dashboard with counts:
  - Epics: total / in-progress / done
  - Stories: total / in-progress / done
  - Tasks: total / in-progress / blocked / done

### 3.7 Search & Filtering (FR-7)
- Global search bar
- Filter by: type (epic/story/task), status, assignee
- Quick filters for “My tasks”

## 4. User Stories

- US-1: As a user, I want to create epics so that I can organize related work.
- US-2: As a user, I want to add stories to epics so that I can break down work.
- US-3: As a user, I want to assign tasks to team members so that responsibilities are clear.
- US-4: As a user, I want to track progress so that I can see what’s been completed.
- US-5: As a user, I want to filter items so that I can focus on what matters now.
- US-6: As a user, I want to see only my tasks so I don’t get overwhelmed.

## 5. Nonfunctional (NFR)

- NFR-1: Must be buildable as a standard web app (SPA + REST or SPA + GraphQL)
- NFR-2: Basic auth secured over HTTPS
- NFR-3: Must support at least 10 concurrent users without falling over
- NFR-4: Code should be structured for AI-assisted extensions (clear modules, documented endpoints)
