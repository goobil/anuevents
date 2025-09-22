const functions = require('firebase-functions');
// v2-style imports for Firestore triggers
const { onDocumentCreated, onDocumentUpdated } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// On create: set server-managed fields and normalize status (v2)
exports.onEventCreate = onDocumentCreated('events/{eventId}', async (event) => {
  const snap = event.data;
  const data = (snap && snap.data()) || {};
  const updates = {};

  // Ensure createdAt is set server-side
  updates.createdAt = admin.firestore.FieldValue.serverTimestamp();

  // If status wasn't provided or not allowed, force to 'pending'
  if (!('status' in data) || (data.status !== 'pending' && data.status !== 'approved' && data.status !== 'rejected')) {
    updates.status = 'pending';
  }

  // Note: Firestore background events do not include caller auth information.
  // If you need to capture who created the document, perform the write through
  // a Callable Function or via a secure server path.

  if (Object.keys(updates).length === 0) return null;
  try {
    await db.doc(`events/${event.params.eventId}`).set(updates, { merge: true });
    functions.logger.info('onEventCreate: set server fields', { eventId: event.params.eventId });
  } catch (err) {
    functions.logger.error('onEventCreate: failed to set server fields', err);
  }
  return null;
});

// On update: detect status transitions and set approvedAt/moderatorId when status becomes 'approved' (v2)
exports.onEventUpdate = onDocumentUpdated('events/{eventId}', async (event) => {
  const beforeSnap = event.data.before;
  const afterSnap = event.data.after;
  const before = (beforeSnap && beforeSnap.data()) || {};
  const after = (afterSnap && afterSnap.data()) || {};

  if (before.status === 'approved') return null; // already approved

  if (before.status !== 'approved' && after.status === 'approved') {
    const updates = {
      approvedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    // If you need moderator identity, consider performing approval via a Callable Function
    try {
      await db.doc(`events/${event.params.eventId}`).set(updates, { merge: true });
      functions.logger.info('onEventUpdate: marked approved', { eventId: event.params.eventId });
    } catch (err) {
      functions.logger.error('onEventUpdate: failed to mark approved', err);
    }
  }
  return null;
});
