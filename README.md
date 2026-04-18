<div align="center">

<img src="https://raw.githubusercontent.com/imjazzdev/flutter_app_expiry/refs/heads/main/example/assets/welcome.png" height="200" alt="Flutter">


**Ship with confidence. Lock the app until you get paid.**

[![pub version](https://img.shields.io/pub/v/flutter_app_expiry.svg?style=flat-square&color=0175C2&labelColor=1a1a2e&label=pub)](https://pub.dev/packages/flutter_app_expiry)
[![likes](https://img.shields.io/pub/likes/flutter_app_expiry?style=flat-square&color=0175C2&labelColor=1a1a2e)](https://pub.dev/packages/flutter_app_expiry/score)
[![license](https://img.shields.io/badge/license-MIT-02d49d.svg?style=flat-square&labelColor=1a1a2e)](LICENSE)
[![platform](https://img.shields.io/badge/platform-flutter-02aab0.svg?style=flat-square&labelColor=1a1a2e)](https://flutter.dev)

Set an expiry date. Ship your app. Everything else is handled.

[Getting Started](#-getting-started) · [Remote Expiry](#-remote-expiry-date) · [API Reference](#-api-reference) · [Customization](#-customization) · [pub.dev →](https://pub.dev/packages/flutter_app_expiry)

</div>

---

## Overview
<table>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/imjazzdev/flutter_app_expiry/main/example/assets/overview-1.gif" 
           width="250" alt="App Expiry Preview">
      <br/>
      <sub><b>🔒 Expiry Deadlline App</b></sub>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/imjazzdev/flutter_app_expiry/main/example/assets/overview-2.gif" 
           width="250" alt="Watermark Overlay Preview">
      <br/>
      <sub><b>🖼 Branding Watermark</b></sub>
    </td>
  </tr>
</table>
Delivered the app. Client ghosts you. Sound familiar? `flutter_app_expiry` lets you ship a fully functional build that automatically locks itself on your terms — so you stay in control until the invoice is settled. Ideal for freelancers, agencies, and indie developers who need a reliable payment deadline gate without writing it from scratch.

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
| 🔒 **Payment deadline gate** | App locks on your terms — no payment, no access |
| 🎨 **Beautiful default UI** | Animated lock screen with gradient, shown out of the box |
| 🛠 **Fully replaceable** | Swap in your own expired widget with a single parameter |
| 📅 **ExpiryService utility** | Query remaining days or duration programmatically |
| 🌐 **Remote expiry date** | Fetch the expiry date from your server — update without republishing |
| 🖼 **Unpaid branding** | Stamp every screen with your watermark until the client pays |
| 🪶 **Zero extra dependencies** | Pure Flutter — nothing added to your dependency tree |

---

## 📦 Getting Started

### 1. Install

```yaml
# pubspec.yaml
dependencies:
  flutter_app_expiry: ^latest-version
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

## 🖼 Watermark Overlay

Need to brand a demo build or remind unpaid clients they're on a trial? The watermark overlay floats above your entire app UI — persistent, unobtrusive, and impossible to miss.

Common use cases:
- **Demo apps** — make it clear the build isn't production-ready
- **Unpaid clients** — reinforce that a license is still pending
- **Internal builds** — distinguish staging from release

### Text watermark (default)

```dart
ExpiryApp(
  expiryDate: DateTime(2026, 12, 31),
  watermark: WatermarkConfig(
    text: 'DEMO',
    color: Colors.red,
    opacity: 0.15,
    angle: -0.4,
    repeat: true,
    tileSpacing: 140.0,
  ),
  child: const MyApp(),
)
```

### Image watermark

Pass any asset image path via `imagePath`. Make sure the asset is declared in your `pubspec.yaml`.

```dart
ExpiryApp(
  expiryDate: DateTime(2026, 12, 31),
  watermark: WatermarkConfig(
    imagePath: 'assets/logo.png',  // your asset path
    imageSize: Size(80, 80),       // tile size (optional, default 80×80)
    opacity: 0.15,
    angle: -0.4,
    repeat: true,
    tileSpacing: 140.0,
  ),
  child: const MyApp(),
)
```

> **Note:** When `imagePath` is set, `text`, `textStyle`, and `color` are ignored — image mode takes priority.

Single centered image (no tiling):

```dart
WatermarkConfig(
  imagePath: 'assets/logo.png',
  repeat: false,  // renders once, centered
)
```

The watermark renders above your app's UI at all times and ignores all touch events so it never blocks user interaction.

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

## 🌐 Remote Expiry Date

Need to change the expiry date **without republishing** your app? Serve it from a JSON endpoint and `RemoteExpiryService` handles the rest — with caching, retries, and full web support built in.

### Quickest way — one line

```dart
final date = await RemoteExpiryService.fetch('https://example.com/expiry.json');
```

### Inside `ExpiryApp` (recommended)

```dart
void main() {
  runApp(
    ExpiryApp.remote(
      remoteUrl: 'https://example.com/expiry.json',
      fallbackExpiryDate: DateTime(2026, 12, 31), // used if server is unreachable
      child: const MyApp(),
    ),
  );
}
```

While the date is being fetched a loading spinner is shown. If the fetch fails, `fallbackExpiryDate` is used automatically.

### Full configuration

```dart
final service = RemoteExpiryService(
  url: 'https://example.com/expiry.json',
  jsonKey: 'expiryDate',          // JSON key to read (default: 'expiryDate')
  cacheDuration: Duration(hours: 1), // cache in memory — avoids hitting server every launch
  maxRetries: 2,                  // retry up to 2 extra times on failure
  retryDelay: Duration(seconds: 1),
  headers: {'Authorization': 'Bearer my-token'}, // optional auth headers
  onError: (e) => debugPrint('Fetch error: $e'),  // optional error callback
);

final date = await service.fetchExpiryDate();
```

### Expected JSON format

Your endpoint must return a JSON object with an ISO 8601 date string:

```json
{ "expiryDate": "2026-12-31T00:00:00Z" }
```

The key name is configurable via `jsonKey`. Dates are always normalised to **UTC** for consistency across all timezones.

### Cache management

```dart
service.clearCache();               // force refresh for this URL only
RemoteExpiryService.clearAllCache(); // wipe cache for all URLs
```

> **Tip:** You can host the JSON for free on GitHub Gist, Pastebin, or any static file host — no backend needed.

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
| `watermark` | `WatermarkConfig?` | — | Watermark overlay for demo/trial branding |

> `expiredWidget` takes precedence — if provided, `expiredTitle`, `expiredMessage`, and `contactInfo` are ignored.

### `WatermarkConfig`

| Parameter | Type | Default | Description |
|-----------|------|---------|---|
| `text` | `String?` | `'DEMO'` | Text label shown as watermark. Ignored when `imagePath` is set. |
| `textStyle` | `TextStyle?` | `null` | Custom style for text. Falls back to `color` + 24sp bold. |
| `imagePath` | `String?` | `null` | Asset path to an image watermark (e.g. `'assets/logo.png'`). Takes priority over `text`. |
| `imageSize` | `Size` | `Size(80, 80)` | Width and height of each image tile. |
| `opacity` | `double` | `0.15` | Overall opacity of the watermark (0.0–1.0). |
| `angle` | `double` | `-0.4` | Rotation in radians. Negative = diagonal tilt. |
| `repeat` | `bool` | `true` | Tile the watermark across the whole screen. |
| `tileSpacing` | `double` | `140.0` | Spacing between tiles when `repeat` is `true`. |
| `color` | `Color` | `Colors.grey` | Text color when no `textStyle` is provided. Text mode only. |
| `showOnExpiredScreen` | `bool` | `false` | Whether to show the watermark on the expired screen too. |

### `ExpiryService`

| Method | Returns | Description |
|--------|---------|---|
| `isExpired(DateTime)` | `bool` | `true` if the date has passed |
| `remainingDays(DateTime)` | `int` | Full calendar days remaining |
| `remainingDuration(DateTime)` | `Duration` | Precise duration until expiry |

### `RemoteExpiryService`

| Parameter | Type | Default | Description |
|-----------|------|---------|---|
| `url` | `String` | **required** | HTTPS endpoint returning the expiry JSON |
| `jsonKey` | `String` | `'expiryDate'` | JSON key holding the ISO 8601 date string |
| `timeout` | `Duration` | `10s` | Max wait time per request |
| `cacheDuration` | `Duration` | `1h` | How long to cache the result in memory |
| `maxRetries` | `int` | `2` | Extra retry attempts on failure |
| `retryDelay` | `Duration` | `1s` | Delay between retries |
| `headers` | `Map<String,String>?` | `null` | Optional HTTP headers (e.g. auth tokens) |
| `onError` | `Function(Object)?` | `null` | Called after all retries fail |

| Method / Static | Returns | Description |
|---------|---------|---|
| `RemoteExpiryService.fetch(url)` | `Future<DateTime?>` | One-shot fetch — no instance needed |
| `fetchExpiryDate()` | `Future<DateTime?>` | Fetch with caching and retries |
| `clearCache()` | `void` | Clear cache for this URL |
| `RemoteExpiryService.clearAllCache()` | `void` | Clear cache for all URLs |

---

## 📂 Project Structure

```
flutter_app_expiry/
├── lib/
│   ├── flutter_app_expiry.dart           # Public barrel export
│   └── src/
│       ├── expiry_service.dart           # Core expiry logic
│       ├── expiry_screen.dart            # Default animated UI
│       ├── expiry_widget.dart            # ExpiryApp wrapper widget
│       ├── remote_expiry_service.dart    # RemoteExpiryService (fetch from server)
│       ├── remote_expiry_fetcher_io.dart # HTTP impl for Android/iOS/Desktop
│       ├── remote_expiry_fetcher_web.dart# HTTP impl for Flutter Web
│       ├── remote_expiry_fetcher_stub.dart # Fallback stub
│       ├── watermark_config.dart         # WatermarkConfig model
│       └── watermark_overlay.dart        # Watermark overlay widget
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