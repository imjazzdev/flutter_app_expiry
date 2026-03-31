import 'package:flutter/material.dart';

/// Configuration for the watermark overlay displayed over the app.
class WatermarkConfig {
  /// The text to display in the watermark (e.g., 'DEMO', 'TRIAL').
  final String? text;

  /// Custom text style for the watermark.
  /// If not provided, a default style using [color] and 24 user font is used.
  final TextStyle? textStyle;

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
  final Color color;

  /// Whether to show the watermark overlay even when the app is expired
  /// (i.e., on the expired screen).
  /// Defaults to `false`.
  final bool showOnExpiredScreen;

  /// Creates a configuration for a watermark overlay.
  const WatermarkConfig({
    this.text = 'DEMO',
    this.textStyle,
    this.opacity = 0.15,
    this.angle = -0.4,
    this.repeat = true,
    this.tileSpacing = 140.0,
    this.color = Colors.grey,
    this.showOnExpiredScreen = false,
  });
}
