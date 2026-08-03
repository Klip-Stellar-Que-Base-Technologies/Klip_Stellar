# Klip — Issue Tracker

> Local dev tracker. Groups are ordered by dependency (earlier groups unblock later ones).
> Each commit entry is a discrete, shippable unit of work.

---

## Legend
- `[ ]` open
- `[x]` done
- `[~]` in progress
- `[s]` skipped / deferred

---

## Group 1 — Bug Fixes (No dependencies, safe to ship first)

These are pure correctness fixes on existing UI — no new features, no new files.

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 1.1 | `fix: invert _transactionBlock condition in HomeView` | `home_view.dart` | ✅ done |
| 1.2 | `fix: invert _transactionBlock condition in SavingsView` | `savings_view.dart` | ✅ done |
| 1.3 | `fix: correct _getIndexFromRoute path strings in NavigationMenu` | `app_navigation.dart` | ✅ done |
| 1.4 | `fix: remove unused withTransaction local var in HomeView` | `home_view.dart` | ✅ done |
| 1.5 | `fix: wire SignupView submit button to navigate to LoginView` | `signup_view.dart` | ✅ done |
| 1.6 | `fix: wire SignupView "Sign In" link to navigate back` | `signup_view.dart` | ✅ done |
| 1.7 | `fix: wire LoginView "Sign Up" link to navigate to SignupView` | `login_view.dart` | ✅ done |
| 1.8 | `fix: add onTap handlers to WalletSelectionView options` | `wallet_selection_view.dart` | ✅ done — both options navigate to success screen as placeholder |

---

## Group 2 — Wallet Core (Unblocks balance, transfers, transaction history)

Foundation: create/load keypair on launch, persist onboarding flag, display real address & balance.

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 2.1 | `feat: add StellarService Riverpod provider` | `stellar_provider.dart` (new) | ✅ done — `stellarServiceProvider`, `walletKeypairProvider` (AsyncNotifier), `xlmBalanceProvider` |
| 2.2 | `feat: create wallet keypair on first launch` | `stellar_provider.dart` | ✅ done — `WalletKeypair.build()` loads existing key or calls `createKeyPair()` on first launch |
| 2.3 | `feat: add onboarding completion flag with shared_preferences` | `onboarding_service.dart` (new), `main.dart`, `app_router.dart` | ✅ done — `OnboardingService`, `SharedPreferences` injected via `ProviderScope`, router redirects `/onboarding` → `/main/home` when flag is set |
| 2.4 | `feat: display real wallet address on HomeView` | `home_view.dart` | ✅ done — truncated `first6...last6`, tap to copy |
| 2.5 | `feat: display real wallet address on SavingsView` | `savings_view.dart` | ✅ done — same as 2.4 |
| 2.6 | `feat: live XLM balance via FutureProvider` | `home_view.dart`, `stellar_provider.dart` | ✅ done — `xlmBalanceProvider` shows `X XLM`, `Unfunded`, or loading state |
| 2.7 | `feat: wire Import Wallet button to import flow` | `import_wallet_view.dart` (new), `home_view.dart`, `app_router.dart` | ✅ done — seed input screen, validates, calls `importFromSeed()`, refreshes balance |
| 2.8 | `feat: Friendbot fund button (debug/testnet only)` | `home_view.dart` | ✅ done — `kDebugMode` guard, calls `fundTestnetAccount()`, invalidates balance on success |

---

## Group 3 — Authentication Gate (Depends on Group 2 — needs keypair existence check)

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 3.1 | `feat: add local_auth dependency and biometric helper service` | `pubspec.yaml`, new `auth_service.dart` | Wrapper around `local_auth` for PIN / biometric prompt |
| 3.2 | `feat: biometric lock screen on app resume` | new `lock_screen.dart` + `app_router.dart` | Guard `/main/*` routes; redirect to lock screen if not authenticated; re-auth on background→foreground |
| 3.3 | `feat: require auth before displaying secret seed` | settings flow | Biometric prompt before showing seed in Backup/Export option (Group 6) |

---

## Group 4 — Transfer Flow (Depends on Group 2 — needs live keypair + balance)

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 4.1 | `feat: destination address input screen` | new `destination_input_view.dart` | Text field for Stellar address; basic format validation; used by "External Wallet" path |
| 4.2 | `feat: amount input screen with asset selector` | new `amount_input_view.dart` | Enter amount; asset dropdown (XLM + any trustlines); shows available balance |
| 4.3 | `feat: fee preview before confirm` | `amount_input_view.dart` | Fetch base fee from Horizon; show before user submits |
| 4.4 | `feat: wire transfer flow end-to-end to StellarService.sendPayment` | `amount_input_view.dart` | Call `sendPayment()`; pass result to success screen via route extras |
| 4.5 | `feat: pass real transaction data to SuccessTransactionView` | `success_transaction_view.dart` + `app_router.dart` | Replace hardcoded `4000 USDT` / `Recipient` / `Solana` with data from route extras |
| 4.6 | `feat: implement Share Receipt button with share_plus` | `success_transaction_view.dart` + `pubspec.yaml` | Add `share_plus`; format receipt string; call `Share.share()` |
| 4.7 | `feat: wire Transfer button on HomeView to wallet selection` | `home_view.dart` | Add `context.go(AppRoutes.transactionWalletSelection)` |

---

## Group 5 — Transaction History (Depends on Group 2)

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 5.1 | `feat: Transaction data model mapping Horizon TransactionResponse` | new `transaction_model.dart` | Fields: hash, type (debit/credit), amount, asset, counterparty, memo, timestamp, fee |
| 5.2 | `feat: transaction FutureProvider fetching from Horizon` | new `transaction_history_provider.dart` | Replaces static `TransactionFilter` notifier; fetches for loaded keypair; applies filter |
| 5.3 | `feat: replace hardcoded ListTile with real transaction list` | `transaction_list_view.dart` | Use provider from 5.2; `ListView.builder` over real data |
| 5.4 | `feat: transaction list item widget` | new `transaction_list_item.dart` | Proper widget for one transaction: icon (in/out), address/label, amount with colour (green/red), date |
| 5.5 | `feat: transaction detail screen` | new `transaction_detail_view.dart` + `app_router.dart` | Tap item → detail screen; shows hash, fee, memo, full timestamp |
| 5.6 | `feat: cursor-based pagination on transaction list` | `transaction_history_provider.dart` | Horizon cursor paging; load-more on scroll |

---

## Group 6 — Savings Wallet (Depends on Group 2)

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 6.1 | `feat: generate and persist savings keypair` | new `savings_service.dart` | Separate key under `stellar_savings_secret_key`; created on first open alongside main keypair |
| 6.2 | `feat: display savings wallet address on SavingsView` | `savings_view.dart` | Replace hardcoded address with savings keypair public key |
| 6.3 | `feat: live savings balance` | `savings_view.dart` + provider | `FutureProvider` for savings account balances |
| 6.4 | `feat: wire Withdraw to Main Wallet button` | `savings_view.dart` | Transfer from savings keypair back to main keypair via `StellarService.sendPayment` |
| 6.5 | `feat: savings chart with fl_chart` | `savings_view.dart` + `pubspec.yaml` | Add `fl_chart`; replace empty `SizedBox` placeholder with a line/area chart of savings balance over time |
| 6.6 | `feat: funding rule — auto-save X% after each outgoing payment` | new `funding_rule_service.dart` | Intercept `sendPayment` result; compute percentage; auto-transfer to savings wallet |

---

## Group 7 — Settings Actions (Depends on Groups 2, 3, 6)

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 7.1 | `feat: disconnect wallet clears keypair and returns to onboarding` | `settings_view.dart` | `StellarService.deleteKeyPair()` + clear savings key + clear onboarding flag + `context.go(AppRoutes.onboardingRoot)` |
| 7.2 | `feat: backup / export secret seed (behind biometric auth)` | new `backup_seed_view.dart` | Prompt biometric (Group 3.3); display seed with copy button and redaction toggle |
| 7.3 | `feat: theme toggle persisted via Riverpod + shared_preferences` | new `theme_provider.dart` + `main.dart` | Light/dark `ThemeMode` toggled from Settings > Appearance; persisted on device |
| 7.4 | `feat: notification toggle with local_notifications` | `settings_view.dart` + new `notification_service.dart` | Persist toggle; request permissions; fire local notification on incoming transaction |

---

## Group 8 — QR Code (Depends on Group 2)

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 8.1 | `feat: receive screen with QR code of wallet address` | new `receive_view.dart` + `pubspec.yaml` | Add `qr_flutter`; display public key as QR + copyable text |
| 8.2 | `feat: QR scanner on destination input screen` | `destination_input_view.dart` + `pubspec.yaml` | Add `mobile_scanner`; scan button fills address field |

---

## Group 9 — Multi-Asset / Trustlines (Depends on Group 2)

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 9.1 | `feat: show all asset balances on HomeView` | `home_view.dart` + `wallet_provider.dart` | Iterate all `Balance` entries from `getBalances()`; render one row per asset |
| 9.2 | `feat: add trustline flow` | new `add_trustline_view.dart` | Asset code + issuer input; `ChangeTrustOperationBuilder`; confirmation step |
| 9.3 | `feat: asset selector on amount input screen` | `amount_input_view.dart` | Populate dropdown with live trustlines from Group 9.1 |

---

## Group 10 — Polish & Error Handling (Can run in parallel with Groups 4–9)

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 10.1 | `fix: global error handling wrapper for all Stellar calls` | `stellar_service.dart` + all call sites | try/catch; surface errors via existing dialog components |
| 10.2 | `fix: loading states during async Stellar operations` | all screens with async | Use existing `LoadingScreen` / `LoadingAnimationWidget` during fetches |
| 10.3 | `fix: network awareness — show offline banner` | new `connectivity_provider.dart` | `connectivity_plus`; disable Stellar actions and show banner when offline |
| 10.4 | `fix: password field obscureText in LoginView and SignupView` | `login_view.dart`, `signup_view.dart` | ✅ done |
| 10.5 | `fix: flutter_gen missing from dev_dependencies` | `pubspec.yaml` | ✅ done — added `flutter_gen_runner: ^5.10.0` |
| 10.6 | `fix: rename OnboardingRootViewPage enum values to lowerCamelCase` | `onboarding_root_view_provider.dart` | ✅ done — `OBV_1..4` → `page1..4` |

---

## Group 11 — Quality of Life & Documentation

| # | Commit | File(s) | Notes |
|---|--------|---------|-------|
| 11.1 | `chore: update project license to MIT License` | `LICENSE`, `ISSUES.md` | ✅ done — replaced Apache 2.0 with standard MIT License |
| 11.2 | `docs: restructure README.md with project details and setup guide` | `README.md`, `ISSUES.md` | ✅ done — replaced raw checklist with full documentation & setup guide |

---

## Dependency Map (quick reference)

```
Group 1 (bugs)  ──────────────────────────────────────────► ship anytime
Group 2 (wallet core)  ───────────────────────────────────► ship next
  └─► Group 3 (auth gate)
  └─► Group 4 (transfer flow)
  └─► Group 5 (tx history)
  └─► Group 6 (savings)
        └─► Group 7 (settings actions)
  └─► Group 8 (QR)
  └─► Group 9 (multi-asset)
Group 10 (polish)  ───────────────────────────────────────► parallel with 4–9
Group 11 (QoL)     ───────────────────────────────────────► documentation & quality of life
```

---

_Last updated: 2026-08-03_

