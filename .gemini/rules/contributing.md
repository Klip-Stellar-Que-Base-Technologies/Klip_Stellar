# Workspace Rules: Branching & Pull Request Workflow

## Git & Development Guidelines

1. **Resolution Branches Required**:
   - Never commit directly to `main`.
   - Always create a dedicated resolution branch for each group, issue, or feature before writing code (e.g., `feat/g5-transaction-history` or `fix/issue-10-detail-screen`).

2. **Discrete Commits**:
   - Resolve sub-issues with atomic, clean commits adhering to conventional commit specs matching `ISSUES.md`.
   - Ensure all code passes static analysis (`flutter analyze`) before committing.

3. **Pull Request Submissions**:
   - Push resolution branches to `origin`.
   - Create a Pull Request into `main` using GitHub CLI (`gh pr create --fill --base main`).

4. **GitHub Issue Management**:
   - When issues are resolved and PRs created/merged, close corresponding remote GitHub issues using `gh issue close <issue-number> -c "Completed and resolved in PR/main"`.
