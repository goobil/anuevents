#!/usr/bin/env python3
"""
Upload an Android App Bundle (AAB) to Google Play using a service account JSON key.

Usage example:
  python3 upload_to_play.py \
    --service-account /path/to/service-account.json \
    --aab ../build/app/outputs/bundle/release/app-release.aab \
    --package com.goobil.anuevents_mobile \
    --track internal

This script uses the Google Play Developer API (androidpublisher v3).
Install deps:
  pip install google-api-python-client google-auth google-auth-httplib2

Notes:
- The service account must be granted access in Play Console (Roles: Release Manager or higher) and be added to the app project.
- The script will create an edit, upload the bundle, assign it to the given track, and commit the edit.
"""
import argparse
import os
import sys
import json

from google.oauth2 import service_account
from googleapiclient.discovery import build
from typing import Optional


def upload_aab(service_account_file: str, aab_path: str, package_name: str, track: str, rollout: Optional[float]):
    if not os.path.isfile(service_account_file):
        raise FileNotFoundError(f"Service account file not found: {service_account_file}")
    if not os.path.isfile(aab_path):
        raise FileNotFoundError(f"AAB file not found: {aab_path}")

    scopes = ["https://www.googleapis.com/auth/androidpublisher"]
    credentials = service_account.Credentials.from_service_account_file(service_account_file, scopes=scopes)
    service = build('androidpublisher', 'v3', credentials=credentials, cache_discovery=False)

    print(f"Creating edit for package: {package_name}")
    edits = service.edits()
    edit_request = edits.insert(body={}, packageName=package_name)
    result = edit_request.execute()
    edit_id = result['id']
    print(f"Created edit: {edit_id}")

    print(f"Uploading bundle: {aab_path}")
    with open(aab_path, 'rb') as bundle_file:
        upload_response = edits.bundles().upload(packageName=package_name, editId=edit_id, media_body=aab_path).execute()
    version_code = upload_response.get('versionCode')
    print(f"Uploaded bundle. Version code: {version_code}")

    # Prepare track body
    track_body = {
        'releases': [
            {
                'name': f'Automated upload ({version_code})',
                'versionCodes': [str(version_code)],
                'status': 'completed' if rollout is None else 'inProgress',
            }
        ]
    }
    if rollout is not None:
        # rollout should be between 0.0 and 1.0
        roll_pct = float(rollout)
        if not (0.0 < roll_pct <= 1.0):
            raise ValueError("rollout must be >0.0 and <=1.0 (e.g. 0.1 for 10%)")
        track_body['releases'][0]['userFraction'] = roll_pct

    print(f"Assigning to track '{track}' (rollout={rollout})")
    edits.tracks().update(packageName=package_name, editId=edit_id, track=track, body=track_body).execute()

    print("Committing edit...")
    edits.commit(packageName=package_name, editId=edit_id).execute()
    print(f"Upload and track assignment complete for package {package_name} on track '{track}'.")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--service-account', required=True, help='Path to service account JSON key file')
    parser.add_argument('--aab', required=True, help='Path to the .aab file to upload')
    parser.add_argument('--package', required=False, default='com.goobil.anuevents_mobile', help='Package name / applicationId')
    parser.add_argument('--track', required=False, default='internal', choices=['internal', 'alpha', 'beta', 'production'], help='Release track')
    parser.add_argument('--rollout', required=False, type=float, help='Rollout fraction for staged rollouts (0.0 < x <= 1.0)')

    args = parser.parse_args()

    try:
        upload_aab(args.service_account, args.aab, args.package, args.track, args.rollout)
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
