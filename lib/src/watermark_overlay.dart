import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'watermark_config.dart';

/// A widget that overlays a configurable watermark on top of its [child].
///
/// It ignores pointer events so the watermark doesn't interfere with
/// user interactions.
class WatermarkOverlay extends StatelessWidget {
  /// The app content over which the watermark is displayed.
  final Widget child;

  /// Configuration for the watermark overlay.
  final WatermarkConfig? config;

  /// Creates a [WatermarkOverlay].
  const WatermarkOverlay({
    super.key,
    required this.child,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (config == null || (config!.text == null && config!.text!.isEmpty)) {
      return child;
    }

    return Stack(
      children: [
        child,
        IgnorePointer(
          child: Opacity(
            opacity: config!.opacity,
            child: SizedBox.expand(
              child: CustomPaint(
                painter: _WatermarkPainter(config: config!),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WatermarkPainter extends CustomPainter {
  final WatermarkConfig config;

  _WatermarkPainter({required this.config});

  @override
  void paint(Canvas canvas, Size size) {
    if (config.text == null || config.text!.isEmpty) return;

    final textStyle = config.textStyle ??
        TextStyle(
          color: config.color,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        );

    final textSpan = TextSpan(
      text: config.text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final double diagonal = math.sqrt(size.width * size.width + size.height * size.height);

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(config.angle);

    if (config.repeat) {
      final double spacing = config.tileSpacing;

      // Start offscreen to cover the corners correctly when rotated
      final double start = -diagonal;
      final double end = diagonal;

      for (double dx = start; dx < end; dx += spacing) {
        for (double dy = start; dy < end; dy += spacing) {
          textPainter.paint(
              canvas, Offset(dx - textPainter.width / 2, dy - textPainter.height / 2));
        }
      }
    } else {
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WatermarkPainter oldDelegate) {
    return oldDelegate.config.text != config.text ||
        oldDelegate.config.opacity != config.opacity ||
        oldDelegate.config.angle != config.angle ||
        oldDelegate.config.repeat != config.repeat ||
        oldDelegate.config.tileSpacing != config.tileSpacing ||
        oldDelegate.config.color != config.color ||
        oldDelegate.config.textStyle != config.textStyle;
  }
}
