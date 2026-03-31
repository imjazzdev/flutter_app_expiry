import 'package:flutter/material.dart';

/// Configuration for the watermark overlay displayed over the app.
///
/// Supports two modes:
/// - **Text mode** (default): displays a repeated text label like "DEMO".
/// - **Image mode**: displays a tiled or centered image from an asset path.
///
/// When [imagePath] is provided, the image watermark is used and [text] is ignored.
class WatermarkConfig {
  /// The text to display in the watermark (e.g., 'DEMO', 'TRIAL').
  /// Ignored when [imagePath] is provided.
  final String? text;

  /// Custom text style for the watermark.
  /// If not provided, a default style using [color] and 24sp font is used.
  /// Only applies in text mode.
  final TextStyle? textStyle;

  /// Asset path to an image used as the watermark (e.g., `'assets/logo.png'`).
  ///
  /// When set, the image is rendered instead of [text].
  /// Make sure the asset is declared in your `pubspec.yaml`.
  final String? imagePath;

  /// The size of each image tile when [imagePath] is set.
  /// Defaults to `Size(80, 80)`.
  final Size imageSize;

  /// Opacity of the watermark (0.0 to 1.0).
  /// Defaults to 0.15.
  final double opacity;

  /// Rotation angle of the watermark in radians.
  /// Defaults to -0.4 (diagonal).
  final double angle;

  /// Whether to tile the watermark repeatedly across the screen.
  /// Defaults to `true`.
  final bool repeat;

  /// Spacing between instances when [repeat] is true.
  /// Defaults to 140.0.
  final double tileSpacing;

  /// Color tint for the text (if [textStyle] is null).
  /// Defaults to [Colors.grey].
  /// Only applies in text mode.
  final Color color;

  /// Whether to show the watermark overlay even when the app is expired
  /// (i.e., on the expired screen).
  /// Defaults to `false`.
  final bool showOnExpiredScreen;

  /// Creates a configuration for a watermark overlay.
  ///
  /// **Text watermark** (default):
  /// ```dart
  /// WatermarkConfig(text: 'DEMO')
  /// ```
  ///
  /// **Image watermark**:
  /// ```dart
  /// WatermarkConfig(imagePath: 'assets/logo.png')
  /// ```
  const WatermarkConfig({
    this.text = 'DEMO',
    this.textStyle,
    this.imagePath,
    this.imageSize = const Size(80, 80),
    this.opacity = 0.15,
    this.angle = -0.4,
    this.repeat = true,
    this.tileSpacing = 140.0,
    this.color = Colors.grey,
    this.showOnExpiredScreen = false,
  });
}
