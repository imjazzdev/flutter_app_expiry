/// A Flutter package to enforce app expiration (trial period) based on
/// a specific date.
///
/// After the expiry date, the app is blocked and shows a customizable
/// expiration screen.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_app_expiry/flutter_app_expiry.dart';
///
/// void main() {
///   runApp(
///     ExpiryApp(
///       expiryDate: DateTime(2026, 12, 31),
///       child: const MyApp(),
///     ),
///   );
/// }
/// ```
library flutter_app_expiry;

export 'src/expiry_service.dart';
export 'src/expiry_screen.dart';
export 'src/expiry_widget.dart';
export 'src/remote_expiry_service.dart';
export 'src/watermark_config.dart';
export 'src/watermark_overlay.dart';
