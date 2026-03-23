<div align="center">

<img src="https://raw.githubusercontent.com/flutter/website/main/src/assets/images/shared/brand/flutter/logo/flutter-lockup.png" height="40" alt="Flutter">

# flutter_app_expiry

**Enforce trial periods in Flutter apps — beautifully.**

[![pub version](https://img.shields.io/pub/v/flutter_app_expiry.svg?style=flat-square&color=0175C2&labelColor=1a1a2e&label=pub)](https://pub.dev/packages/flutter_app_expiry)
[![likes](https://img.shields.io/pub/likes/flutter_app_expiry?style=flat-square&color=0175C2&labelColor=1a1a2e)](https://pub.dev/packages/flutter_app_expiry/score)
[![license](https://img.shields.io/badge/license-MIT-02d49d.svg?style=flat-square&labelColor=1a1a2e)](LICENSE)
[![platform](https://img.shields.io/badge/platform-flutter-02aab0.svg?style=flat-square&labelColor=1a1a2e)](https://flutter.dev)

Set an expiry date. Ship your app. Everything else is handled.

[Getting Started](#-getting-started) · [API Reference](#-api-reference) · [Customization](#-customization) · [pub.dev →](https://pub.dev/packages/flutter_app_expiry)

</div>

---

## Overview

`flutter_app_expiry` lets you ship Flutter apps with a built-in expiration gate — ideal for trial builds, demos, or time-limited licenses. When the clock runs out, your app gracefully shows a polished lock screen instead of crashing or misbehaving.

```dart
ExpiryApp(
  expiryDate: DateTime(2026, 12, 31),
  child: const MyApp(),
)
```

That's it. One widget wraps everything.

---

## ✦ Features

| | |
|---|---|
| 🔒 **Hard expiry gate** | Blocks the app after a configurable date — no workarounds |
| 🎨 **Beautiful default UI** | Animated lock screen with gradient, shown out of the box |
| 🛠 **Fully replaceable** | Swap in your own expired widget with a single parameter |
| 📅 **ExpiryService utility** | Query remaining days or duration programmatically |
| 🪶 **Zero extra dependencies** | Pure Flutter — nothing added to your dependency tree |

---

## 📦 Getting Started

### 1. Install

```yaml
# pubspec.yaml
dependencies:
  flutter_app_expiry: ^0.0.1
```

```bash
flutter pub get
```

### 2. Wrap your app

```dart
import 'package:flutter/material.dart';
import 'package:flutter_app_expiry/flutter_app_expiry.dart';

void main() {
  runApp(
    ExpiryApp(
      expiryDate: DateTime(2026, 12, 31), // 🔑 set your date
      child: const MyApp(),
    ),
  );
}
```

Done. The app runs normally until `expiryDate` — then the lock screen takes over automatically.

---

## 🎨 Customization

### Option A — Use your own expired screen

```dart
ExpiryApp(
  expiryDate: DateTime(2026, 12, 31),
  expiredWidget: const MyCustomExpiredScreen(), // full control
  child: const MyApp(),
)
```

### Option B — Customize the built-in screen

```dart
ExpiryApp(
  expiryDate: DateTime(2026, 12, 31),
  expiredTitle: 'Trial Ended',
  expiredMessage: 'Please purchase a license to continue.',
  contactInfo: 'support@yourapp.com',
  child: const MyApp(),
)
```

### Option C — Embed `DefaultExpiredScreen` directly

```dart
DefaultExpiredScreen(
  expiryDate: DateTime(2026, 12, 31),
  title: 'License Expired',
  message: 'Renew to keep going.',
  contactInfo: 'hello@example.com',
)
```

---

## 🧮 ExpiryService

Need to react to expiry in your own logic? Use `ExpiryService` for programmatic checks:

```dart
final service = ExpiryService();
final expiry = DateTime(2026, 12, 31);

// Check expiry state
final expired = service.isExpired(expiry);          // bool

// How much time is left?
final days     = service.remainingDays(expiry);     // int  (e.g. 42)
final duration = service.remainingDuration(expiry); // Duration
```

Great for showing in-app banners like *"Your trial expires in 7 days"*.

---

## 📚 API Reference

### `ExpiryApp`

| Parameter | Type | Required | Description |
|-----------|------|:---:|---|
| `expiryDate` | `DateTime` | ✅ | The date the app will be blocked |
| `child` | `Widget` | ✅ | Your root app widget |
| `expiredWidget` | `Widget?` | — | Fully custom expired screen |
| `expiredTitle` | `String?` | — | Title on the default screen |
| `expiredMessage` | `String?` | — | Message on the default screen |
| `contactInfo` | `String?` | — | Contact text on the default screen |

> `expiredWidget` takes precedence — if provided, `expiredTitle`, `expiredMessage`, and `contactInfo` are ignored.

### `ExpiryService`

| Method | Returns | Description |
|--------|---------|---|
| `isExpired(DateTime)` | `bool` | `true` if the date has passed |
| `remainingDays(DateTime)` | `int` | Full calendar days remaining |
| `remainingDuration(DateTime)` | `Duration` | Precise duration until expiry |

---

## 📂 Project Structure

```
flutter_app_expiry/
├── lib/
│   ├── flutter_app_expiry.dart       # Public barrel export
│   └── src/
│       ├── expiry_service.dart       # Core expiry logic
│       ├── expiry_screen.dart        # Default animated UI
│       └── expiry_widget.dart        # ExpiryApp wrapper widget
├── example/
│   └── lib/main.dart
├── pubspec.yaml
├── CHANGELOG.md
├── README.md
└── LICENSE
```

---

## 🤝 Contributing

Issues and pull requests are welcome! If you find a bug or have a feature idea, please [open an issue](https://github.com/your-org/flutter_app_expiry/issues).

1. Fork the repo
2. Create your feature branch: `git checkout -b feat/amazing-thing`
3. Commit your changes: `git commit -m 'feat: add amazing thing'`
4. Push and open a PR

---

## 📄 License

MIT © see [LICENSE](LICENSE) for details.

---

<div align="center">

Made with ♥ for the Flutter community

</div>