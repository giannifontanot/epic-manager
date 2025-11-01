# Epic Manager – Working Guidelines

1. **Always start from the spec**
   - If a requirement is not in `requirements.md`, ask to add it before coding.
   - Code must reference a requirement ID (e.g. FR-3, FR-5).

2. **One task at a time**
   - When implementing with AI, pass only one section from `tasks.md`.
   - After code is generated, review it and mark the task done.
   - If the task reveals a missing requirement, update `requirements.md` and regenerate.

3. **Keep traceability**
   - Every endpoint or UI view must map to:
     - a functional requirement (FR-x),
     - a user story (US-x),
     - and a task ID (from `tasks.md`).

4. **Prefer vertical slices**
   - Build “Auth end-to-end” rather than “all entities backend first.”
   - That makes it easier to test and to use AI to extend features.

5. **Name things consistently**
   - epic → story → task
   - project/workspace must be present in every request to avoid cross-project leaks.

6. **Don’t let AI invent data models silently**
   - If the AI introduces a new field (e.g. `label_color`), add it to the spec or reject it.

7. **Review is mandatory**
   - After AI output, run formatter, run tests, and ensure API docs are updated.
