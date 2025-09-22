#!/usr/bin/env node
// Usage: node setCustomClaim.js <uid|email> <role>
// Example: node setCustomClaim.js user@example.com moderator

const admin = require('firebase-admin');
const fs = require('fs');

function usage() {
  console.error('Usage: node setCustomClaim.js <uid|email> <role>');
  process.exit(1);
}

if (process.argv.length < 4) usage();

const identifier = process.argv[2];
const role = process.argv[3];

// Initialize admin SDK. It will pick up GOOGLE_APPLICATION_CREDENTIALS or
// the default service account in Cloud Functions runtime.
if (!admin.apps.length) {
  try {
    admin.initializeApp();
  } catch (e) {
    console.error('Failed to initialize firebase-admin:', e.message);
    process.exit(1);
  }
}

async function main() {
  try {
    let uid = identifier;
    // If identifier looks like an email, look up user by email
    if (identifier.includes('@')) {
      const userRecord = await admin.auth().getUserByEmail(identifier);
      uid = userRecord.uid;
    }

    const currentClaims = (await admin.auth().getUser(uid)).customClaims || {};
    const newClaims = Object.assign({}, currentClaims, { role });

    await admin.auth().setCustomUserClaims(uid, newClaims);
    console.log(`Set role='${role}' for uid=${uid}`);
    process.exit(0);
  } catch (err) {
    console.error('Error setting custom claim:', err.message || err);
    process.exit(2);
  }
}

main();
