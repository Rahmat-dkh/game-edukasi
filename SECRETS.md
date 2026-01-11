# Secrets & Firebase config (remediation guide)

## What I changed
- Removed the hard-coded API key from `lib/firebase_options.dart` and now read it from a Dart compile-time env var `FIREBASE_API_KEY` using `String.fromEnvironment` (default: `REPLACE_ME`).
- Replaced the `current_key` in `android/app/google-services.json` with `REPLACE_ME` and added `android/app/google-services.json` to `.gitignore`.
- Added `android/app/google-services.json.example` so devs know the structure.

## Local setup (developers)
1. Put the real `google-services.json` into `android/app/google-services.json` (do not commit it).
2. For running locally or building, pass the Firebase API key via Dart define:

   flutter run --dart-define=FIREBASE_API_KEY="YOUR_REAL_API_KEY"

   or for release builds:

   flutter build apk --release --dart-define=FIREBASE_API_KEY="YOUR_REAL_API_KEY"

3. Alternatively, use your environment/CI to set `FIREBASE_API_KEY` (see CI section).

## CI (GitHub Actions)
- Add `FIREBASE_API_KEY` as a repository secret in GitHub (`Settings → Secrets → Actions`).
- In your workflow, pass it to flutter using `--dart-define`:

  - name: Build
    run: flutter build apk --release --dart-define=FIREBASE_API_KEY=${{ secrets.FIREBASE_API_KEY }}

## Security steps you should take now
1. Revoke the compromised API key in Google Cloud Console (APIs & Services → Credentials). Create a new key and **restrict it** to required APIs and application restrictions (Android package name + SHA-1, HTTP referrers for web, or IPs).
2. Consider setting quotas and restricting usage for the key.

## Remove the key from git history (optional, requires coordination)
- Preferred: use `git filter-repo` (fast and robust):

  # Install git-filter-repo if not present
  # For Windows: use pip install git-filter-repo

  git clone --mirror <repo-url> repo.git
  cd repo.git
  git filter-repo --replace-text ../../replace-secrets.txt

  # where replace-secrets.txt contains a line like:
  # aiAzasy...==>REDACTED

  # Then push back with --force
  git push --force --all
  git push --force --tags

- Alternatively, use BFG Repo Cleaner:

  bfg --replace-text replace-secrets.txt repo.git

Notes: This rewrites history; coordinate with team and force-push, then ask contributors to re-clone.

If you want, I can prepare the `replace-secrets.txt` and the exact commands to safely scrub the key from history.
