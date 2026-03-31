# Changelog

## 1.2.1

*   **✨ New Feature: Image Watermarking** — You can now use asset image paths for the watermark overlay by passing `imagePath` and `imageSize` to `WatermarkConfig`.
*   **📂 Tiled or Centered Rendering** — Automatically tiles the image watermark across the screen by default, or shows it once centered with `repeat: false`.
*   **🛠 Layout Stability Fix** — Explicitly set `alignment: Alignment.topLeft` for `Stack` widgets in `WatermarkOverlay` to prevent the "No Directionality widget found" error when the package is used at the root level.
*   **📖 Improved Documentation** — Reorganized the README with clearer examples for both text and image mode watermarks.
*   **🎨 Watermark Customization** — Easily customizable with opacity, angle, color, and tiled repeating mode.

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
