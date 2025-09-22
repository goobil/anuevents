const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');

// This script writes a test document to the local Firestore emulator
// Usage: 
// FIRESTORE_EMULATOR_HOST=localhost:8080 node smoke_test.js

initializeApp();
const db = getFirestore();

async function run() {
  const docRef = db.collection('events').doc('smoke-test-' + Date.now());
  await docRef.set({
    title: 'Smoke Test Event',
    description: 'Testing onCreate trigger',
  });
  console.log('Wrote test document:', docRef.path);
  // Wait a bit for functions emulator to process the trigger
  await new Promise((r) => setTimeout(r, 3000));
  const snap = await docRef.get();
  console.log('Document data after triggers:', snap.data());
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});