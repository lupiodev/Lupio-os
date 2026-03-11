# Command: /generate-frontend-module

## Description
Generates a complete frontend module including page, components, state, and API integration.

## Required Context
- User provides: page/feature name, design reference or description
- Reads: `.lupio/context/api-spec.md`, existing component patterns

## Agents Involved
- `frontend-lead` — primary
- `ui-reviewer` — reviews output

## Execution Steps
1. Ask for: feature name, route, design reference, API endpoints to connect
2. Check for existing similar components to reuse
3. Generate page component
4. Generate sub-components
5. Wire up API calls
6. Add loading/error states
7. Run `ui-reviewer` on output
8. Fix issues flagged by reviewer

## Expected Output
For feature `user-profile`:
- `src/pages/UserProfile.tsx`
- `src/components/profile/ProfileCard.tsx`
- `src/components/profile/ProfileForm.tsx`
- `src/hooks/useUserProfile.ts`
- `src/api/userProfile.ts`

## File Outputs
All files in project `src/`
