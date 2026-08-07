# Contributing Guidelines — Klip Stellar

Thank you for contributing to Klip! Please adhere to the following workflow for all additions, bug fixes, and feature implementations.

---

## 🌿 Branching Strategy

* **Do NOT commit directly to `main`.**
* Always check out a **resolution branch** from `main` before starting work on an issue or group:
  ```bash
  git checkout -b feat/g5-transaction-history
  ```
  Branch naming conventions:
  * `feat/g<group-number>-<name>` for feature groups
  * `fix/<issue-number>-<name>` for bug fixes

---

## 📝 Commit Standard

* Make discrete, atomic commits for each sub-task or commit entry specified in [`ISSUES.md`](./ISSUES.md).
* Follow Conventional Commits syntax (e.g. `feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`).
* Run `flutter analyze` prior to committing to ensure zero static analysis errors.

---

## 🔀 Pull Requests & Remote Sync

1. Push your resolution branch to remote:
   ```bash
   git push -u origin feat/g5-transaction-history
   ```
2. Open a Pull Request targeting `main`:
   ```bash
   gh pr create --fill --base main
   ```
3. Close corresponding remote GitHub issues once merged:
   ```bash
   gh issue close <issue-number> --comment "Completed and merged to main"
   ```
