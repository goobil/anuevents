Upload helper for Google Play (AAB)
=================================

Files:
- `upload_to_play.py` — Python script that uses the Google Play Developer API to upload an AAB and assign it to a track.
- `upload_to_play.sh` — Small shell wrapper for convenience.

Prerequisites:
- Python 3.8+ and pip. Install the client libs:
  pip install google-api-python-client google-auth google-auth-httplib2
- A Google Cloud service account JSON key with the `Android Publisher` API access. Create a service account in Google Cloud, then in Play Console add that service account to your app with the `Release Manager` role (or equivalent).
- The service account's JSON file must be present locally and the Play Console must recognize the service account.

Example usage (from `mobile/`):

```bash
# Give the script executable permissions once
chmod +x scripts/upload_to_play.sh

# Run the upload (internal track):
scripts/upload_to_play.sh ~/Downloads/play-sa.json build/app/outputs/bundle/release/app-release.aab internal

# Run with a staged rollout of 10%:
scripts/upload_to_play.sh ~/Downloads/play-sa.json build/app/outputs/bundle/release/app-release.aab internal 0.1
```

Security note:
- Do not commit your service account JSON to version control. Keep it secret.

If you want, I can run the upload for you if you provide the path to your service account JSON on this machine (or give me temporary permission). Otherwise follow the instructions above to run it locally.
