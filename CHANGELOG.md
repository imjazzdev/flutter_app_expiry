# Changelog

## 1.2.0

* Added `WatermarkConfig` to display a customizable watermark overlay (e.g., "DEMO") over the app UI.
* Easily customizable with opacity, angle, color, and tiled repeating mode.


## 0.0.4

* Added `WatermarkConfig` to display a customizable watermark overlay (e.g., "DEMO") over the app UI.
* Easily customizable with opacity, angle, color, and tiled repeating mode.

## 0.0.3
   - Updated README with preview video

## 0.0.2

* Added `ExpiryApp.remote()` — fetch expiry date from a remote JSON endpoint
* Added `RemoteExpiryService` for standalone remote expiry checks
* Configurable JSON key, timeout, loading widget, and fallback date
* Graceful fail-open behavior when network is unavailable

## 0.0.1

* Initial release
* `ExpiryApp` widget — wraps your app and enforces an expiration date
* `ExpiryService` — utility class for expiry checks (isExpired, remainingDays, remainingDuration)
* `DefaultExpiredScreen` — polished, animated expiration screen with customizable title, message, and contact info
