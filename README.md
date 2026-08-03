# Klip — Stellar Wallet App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.35.3-blue.svg)](https://flutter.dev)
[![Blockchain](https://img.shields.io/badge/Blockchain-Stellar-purple.svg)](https://stellar.org)

**Klip** is a non-custodial, self-custody mobile wallet built on the **Stellar blockchain** using **Flutter** and **Riverpod**. It enables users to manage XLM and Stellar assets, execute fast payments, track transaction history, and automatically grow savings through smart funding rules.

---

## 🌟 Key Features

- **Keypair Management**: On-device key generation, seed phrase import, and secure storage using OS-level encrypted storage.
- **Instant Transfers**: Send and receive XLM and Stellar assets with real-time fee calculation from Horizon.
- **Savings Wallet**: Dedicated savings account separation with automated funding rules (e.g., auto-save a percentage of every outgoing payment).
- **Testnet Friendbot**: Integrated one-tap testnet wallet funding for developers and testing.
- **Transaction History**: Live transaction list with filtering, sorting, and detail views directly from the Stellar Horizon network.
- **Security First**: Local authentication (biometrics/PIN) protecting key export, seed backup, and transaction signing.
- **Modern UI/UX**: Fluid glassmorphism visual aesthetics, dark/light theme support, and seamless tab-based navigation.

---

## 🛠 Tech Stack

| Component | Library / Tool | Description |
|---|---|---|
| **Framework** | Flutter (FVM `3.35.3`) | Cross-platform UI toolkit for iOS, Android, macOS, and Web |
| **Language** | Dart `^3.0.0` | Strongly typed object-oriented language |
| **State Management** | Riverpod (`flutter_riverpod`, `riverpod_annotation`) | Reactive, compile-safe state management |
| **Routing** | `go_router` | Declarative routing solution |
| **Blockchain SDK** | `stellar_flutter_sdk` `^3.0.5` | Stellar Horizon REST client and transaction builder |
| **Secure Storage** | `flutter_secure_storage` | Hardware-backed encrypted key/seed storage |
| **Local Auth** | `local_auth` | Biometric (Face ID / Touch ID / Fingerprint) & PIN security |
| **Preferences** | `shared_preferences` | Persistent key-value storage for app settings |
| **UI & Assets** | `flutter_screenutil`, `flutter_svg`, `flutter_gen` | Responsive scaling, SVG rendering, typed asset generation |

---

## 📁 Project Structure

```text
lib/
├── core/
│   ├── navigation/         # Bottom navigation shell & tab providers
│   ├── routes/             # GoRouter configuration (AppRouter, AppRoutes)
│   └── stellar/            # StellarService — Horizon network API & key management
├── features/
│   ├── onboarding/         # Onboarding carousel, splash, and auth entry views
│   ├── home/               # Dashboard, live XLM balance card, quick actions, funding rule
│   ├── transaction/        # Transaction list, filter views, transfer flow, receipt screen
│   ├── saving/             # Savings wallet view, withdrawal flow, savings analytics
│   ├── settings/           # Security, seed export, theme toggle, notifications
│   └── profile/auth/       # Login and signup screens
├── shared/
│   ├── components/         # Reusable dialogs, loading indicators, custom buttons
│   ├── style/              # Typography styles, text themes, and color tokens
│   └── widget/             # App bars, background textures, empty state views
└── gen/                    # Auto-generated assets and colors (via flutter_gen)
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version `3.35.3` recommended)
- [FVM (Flutter Version Management)](https://fvm.app/) *(optional, but recommended)*
- [CocoaPods](https://cocoapods.org/) (for iOS/macOS builds)

### Installation & Local Setup

1. **Clone the Repository**
   ```bash
   git clone git@github.com:Klip-Stellar-Que-Base-Technologies/Klip_Stellar.git
   cd Klip_Stellar
   ```

2. **Set up Flutter Version (FVM)**
   ```bash
   # Install FVM globally if not already installed
   dart pub global activate fvm

   # Pin & install project Flutter version
   fvm use 3.35.3
   ```

3. **Install Dependencies**
   ```bash
   fvm flutter pub get
   ```

4. **Run Code Generation**
   Generate Riverpod providers, assets (`flutter_gen`), and database code:
   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Launch the Application**
   ```bash
   # Run on connected device or emulator
   fvm flutter run
   ```

---

## 🔒 Security Architecture

Klip operates on a **self-custody** model:
- **Private Key Isolation**: Private keys and secret seeds never leave the local device and are never transmitted to any central server.
- **Hardware Encryption**: Keys are encrypted using iOS Keychain and Android Keystore via `flutter_secure_storage`.
- **Biometric Protection**: Sensitive operations (exporting seed, authorizing major transfers) require local biometric authentication.

---

## ⚙️ Network Configuration

By default, the app is configured to communicate with the **Stellar Testnet** for development and testing.

- **Testnet Horizon Server**: `https://horizon-testnet.stellar.org`
- **Friendbot Endpoint**: `https://friendbot.stellar.org`

To switch to **Stellar Mainnet**, update the `StellarNetwork` configuration in `lib/core/stellar/stellar_provider.dart`.

---

## 📋 Task Tracking & Roadmap

All active features, bug fixes, and development roadmap items are organized into structured groups in [`ISSUES.md`](ISSUES.md).

For detailed progress, task status, and dependency maps, please refer to the [`ISSUES.md`](ISSUES.md) document.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.
