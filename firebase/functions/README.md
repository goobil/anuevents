# Firebase Functions - Admin helper

This folder contains Cloud Functions and small admin helper scripts used by the AnuEvents project.

Files of interest

- `scripts/setCustomClaim.js` — small Node script to set a user's custom claim `role` (e.g., `moderator` or `admin`).
- `package.json` — includes `npm run set-claim` convenience script.

Quick usage

1. Create a Google service account with the following roles:
   - Cloud Functions Deployer (roles/cloudfunctions.deployer)
   - Service Account User (roles/iam.serviceAccountUser)
   - Cloud Build Editor (roles/cloudbuild.builds.editor)
   - Artifact Registry Reader/Writer if you deploy Docker/artifacts
   - (Optional) IAM Admin if you need to manage additional service accounts

2. Download the service account JSON key.

3. For local runs, set the env var:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
```

Or for GitHub Actions, add the JSON contents as a repository secret named `FIREBASE_SERVICE_ACCOUNT`.

Run the helper locally

```bash
cd firebase/functions
npm install
# by email
node ./scripts/setCustomClaim.js user@example.com moderator
# or by uid
node ./scripts/setCustomClaim.js someUid admin
```

Notes

- After updating custom claims, the user must reauthenticate (sign out & sign back in) for the client token to pick up the new claim.
- Keep service account keys secure. Prefer CI secrets or Workload Identity where possible.
