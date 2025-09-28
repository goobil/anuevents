# Cloud Functions for ANU Events

This folder contains a callable Cloud Function `moderateEvent` that approves or rejects events.

Install and deploy:

```bash
cd functions
npm install
# then deploy only the callable function
firebase deploy --only functions:moderateEvent
```

The callable function expects the caller to have a custom claim `role` set to `moderator` or `admin`. It performs an atomic transaction that updates the event document and appends a moderation log entry.

Running rules unit tests locally

1. Install dependencies:

```bash
cd functions
npm ci
```

2. Run the Firestore emulator and tests together:

```bash
npx firebase emulators:exec --project anuevents-testing "npm run test:rules"
```

This will start the Firestore emulator, load your `firebase/firestore.rules`, and execute the mocha test file at `functions/test/firestore.rules.test.js`.
