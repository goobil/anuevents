# Quick PR instructions

1. From the repo root, run:

```bash
./scripts/create_pr_instructions.sh
```

2. If you don't have GitHub CLI installed, push the branch and open a PR via the GitHub web UI.

Notes:

- The script will create branch `feature/docs/implementation-phases` and push it to `origin`.
- The PR base is `main` by default; change it to `stable` or your desired base if needed.
- Ensure your git remote `origin` is set and you have permission to push.
