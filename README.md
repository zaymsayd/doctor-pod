# DoctoPod — iOS Take-Home

SwiftUI app built as a practical test for Appkasa LLC. Demonstrates onboarding, a StoreKit 2 paywall, and live Firebase data — all wired together with a feature-based architecture.

---

## Features

### 1. Onboarding
Single screen introducing the app concept ("Your documents, now in audio."). Tapping **Get Started** navigates to the paywall via `NavigationStack`.

### 2. Paywall (StoreKit 2, sandbox mode)
- `StoreKitManager` fetches products by ID (`com.zaymsayd.doctorpod.premium.monthly`) using `Product.products(for:)`
- Purchase flow: `product.purchase()` → receipt verification via `VerificationResult` → `Transaction.finish()`
- Restore purchases via `AppStore.sync()`
- Premium state derived from `Transaction.currentEntitlements`
- Sandbox tested via `DoctorPod.storekit` configuration file

### 3. Firebase Read
- `PaywallConfigService` reads `app_config/paywall` from Firestore on paywall load
- Document fields: `title`, `subtitle`, `features` (array), `billingNote`
- Drives the paywall UI copy dynamically — swap copy in Firestore without an app update

---

## Architecture

```
DoctorPod/
├── App/                        # @main entry point, Firebase init
├── Core/
│   ├── Services/               # StoreKitManager, PaywallConfigService
│   └── Theme/                  # AppColors
├── Features/
│   ├── Onboarding/Views+ViewModels
│   ├── Paywall/Views+ViewModels+Services
│   └── Home/Views+ViewModels
└── Resources/                  # Assets.xcassets
```

MVVM throughout. ViewModels use `@Observable` / `ObservableObject`. No third-party dependencies beyond Firebase SDK (via SPM).

---

## Setup

1. Add your own `GoogleService-Info.plist` to `DoctorPod/` (excluded from repo via `.gitignore`)
2. Create a Firestore document at `app_config/paywall` with fields:
   ```
   title: String
   subtitle: String
   features: Array<String>
   billingNote: String
   ```
3. Run on simulator — StoreKit sandbox uses `DoctorPod.storekit` for local product testing
