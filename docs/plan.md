# Epic Manager – Implementation Plan

## Phase 0 – Foundations
- Choose stack (e.g. Spring Boot + React, or Node/Nest + React)
- Set up repo structure: `/backend`, `/frontend`, `/docs`
- Add basic CI (lint + tests)
- Add `.env.example` and config

## Phase 1 – Auth & Users (FR-1)
- Implement user model
- Implement signup/login/logout endpoints
- JWT-based session handling
- Role model: owner, member
- Seed an admin/owner user

## Phase 2 – Projects (FR-2)
- Create project entity + CRUD
- Add membership table (user ↔ project)
- Enforce project scoping on all future endpoints
- UI: list/select active project

## Phase 3 – Epics (FR-3)
- Epic entity + CRUD
- Link to project
- List epics by project
- Filters: status, priority
- UI: Epics page (table or cards)

## Phase 4 – Stories (FR-4)
- Story entity + CRUD
- Link to epic
- List stories by epic
- UI: Epic detail view → stories list

## Phase 5 – Tasks (FR-5)
- Task entity + CRUD
- Link to story
- Assign to user (must belong to project)
- Task status transitions
- UI: story detail → tasks list
- Quick view: “My tasks”

## Phase 6 – Tracking & Search (FR-6, FR-7)
- Compute progress per epic
- Dashboard page
- Global search endpoint
- Filters on frontend

## Phase 7 – Polish & Docs
- Error handling, 404/401
- API docs (OpenAPI)
- “How to add a new feature” guide
