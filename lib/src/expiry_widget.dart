import 'package:flutter/material.dart';
import 'expiry_screen.dart';
import 'expiry_service.dart';
import 'remote_expiry_service.dart';
import 'watermark_config.dart';
import 'watermark_overlay.dart';

/// A widget that wraps your app and enforces an expiration date.
///
/// If [DateTime.now()] is past [expiryDate], the [expiredWidget] is shown
/// (or [DefaultExpiredScreen] if none is provided). Otherwise, [child] is
/// rendered normally.
///
/// ### Usage
///
/// ```dart
/// void main() {
///   runApp(
///     ExpiryApp(
///       expiryDate: DateTime(2026, 12, 31),
///       child: const MyApp(),
///     ),
///   );
/// }
/// ```
///
/// ### Custom expired screen
///
/// ```dart
/// ExpiryApp(
///   expiryDate: DateTime(2026, 12, 31),
///   expiredWidget: const Center(child: Text('Trial Over!')),
///   child: const MyApp(),
/// )
/// ```
///
/// ### Remote expiry
///
/// ```dart
/// ExpiryApp.remote(
///   remoteUrl: 'https://api.example.com/expiry',
///   fallbackExpiryDate: DateTime(2026, 12, 31),
///   child: const MyApp(),
/// )
/// ```
class ExpiryApp extends StatelessWidget {
  /// The date after which the app is considered expired.
  final DateTime expiryDate;

  /// The main app widget rendered when the app is **not** expired.
  final Widget child;

  /// An optional widget to display when the app **is** expired.
  ///
  /// If `null`, [DefaultExpiredScreen] is used.
  final Widget? expiredWidget;

  /// Optional title for the default expired screen.
  ///
  /// Only used when [expiredWidget] is `null`.
  final String? expiredTitle;

  /// Optional message for the default expired screen.
  ///
  /// Only used when [expiredWidget] is `null`.
  final String? expiredMessage;

  /// Optional contact info displayed on the default expired screen.
  ///
  /// Only used when [expiredWidget] is `null`.
  final String? contactInfo;

  /// Optional watermark configuration.
  ///
  /// If provided, a watermark overlay will be displayed over the app.
  final WatermarkConfig? watermark;

  /// Creates an [ExpiryApp] widget with a **local** expiry date.
  const ExpiryApp({
    super.key,
    required this.expiryDate,
    required this.child,
    this.expiredWidget,
    this.expiredTitle,
    this.expiredMessage,
    this.contactInfo,
    this.watermark,
  });

  /// Creates an [ExpiryApp] that fetches its expiry date from a **remote
  /// JSON endpoint**.
  ///
  /// While the remote date is being fetched, [loadingWidget] is shown
  /// (defaults to a centered [CircularProgressIndicator]).
  ///
  /// If the fetch fails, [fallbackExpiryDate] is used. If no fallback is
  /// provided, [child] is rendered as-is (fail-open).
  ///
  /// The JSON response must contain a key (default `"expiryDate"`) whose
  /// value is an ISO 8601 date string:
  ///
  /// ```json
  /// { "expiryDate": "2026-12-31T00:00:00" }
  /// ```
  ///
  /// ```dart
  /// ExpiryApp.remote(
  ///   remoteUrl: 'https://api.example.com/expiry',
  ///   fallbackExpiryDate: DateTime(2026, 12, 31),
  ///   child: const MyApp(),
  /// )
  /// ```
  static Widget remote({
    Key? key,
    required String remoteUrl,
    required Widget child,
    DateTime? fallbackExpiryDate,
    String jsonKey = 'expiryDate',
    Duration timeout = const Duration(seconds: 10),
    Widget? loadingWidget,
    Widget? expiredWidget,
    String? expiredTitle,
    String? expiredMessage,
    String? contactInfo,
    WatermarkConfig? watermark,
  }) {
    return _RemoteExpiryApp(
      key: key,
      remoteUrl: remoteUrl,
      fallbackExpiryDate: fallbackExpiryDate,
      jsonKey: jsonKey,
      timeout: timeout,
      loadingWidget: loadingWidget,
      expiredWidget: expiredWidget,
      expiredTitle: expiredTitle,
      expiredMessage: expiredMessage,
      contactInfo: contactInfo,
      watermark: watermark,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    const service = ExpiryService();

    Widget resultWidget;
    if (service.isExpired(expiryDate)) {
      resultWidget = expiredWidget ??
          DefaultExpiredScreen(
            expiryDate: expiryDate,
            title: expiredTitle,
            message: expiredMessage,
            contactInfo: contactInfo,
          );

      if (watermark != null && !watermark!.showOnExpiredScreen) {
        return resultWidget;
      }
    } else {
      resultWidget = child;
    }

    if (watermark != null) {
      return WatermarkOverlay(
        config: watermark,
        child: resultWidget,
      );
    }

    return resultWidget;
  }
}

// ---------------------------------------------------------------------------
// Private stateful widget for remote expiry
// ---------------------------------------------------------------------------

class _RemoteExpiryApp extends StatefulWidget {
  final String remoteUrl;
  final DateTime? fallbackExpiryDate;
  final String jsonKey;
  final Duration timeout;
  final Widget? loadingWidget;
  final Widget? expiredWidget;
  final String? expiredTitle;
  final String? expiredMessage;
  final String? contactInfo;
  final WatermarkConfig? watermark;
  final Widget child;

  const _RemoteExpiryApp({
    super.key,
    required this.remoteUrl,
    required this.child,
    this.fallbackExpiryDate,
    this.jsonKey = 'expiryDate',
    this.timeout = const Duration(seconds: 10),
    this.loadingWidget,
    this.expiredWidget,
    this.expiredTitle,
    this.expiredMessage,
    this.contactInfo,
    this.watermark,
  });

  @override
  State<_RemoteExpiryApp> createState() => _RemoteExpiryAppState();
}

class _RemoteExpiryAppState extends State<_RemoteExpiryApp> {
  late final Future<DateTime?> _fetchFuture;

  @override
  void initState() {
    super.initState();
    final service = RemoteExpiryService(
      url: widget.remoteUrl,
      jsonKey: widget.jsonKey,
      timeout: widget.timeout,
    );
    _fetchFuture = service.fetchExpiryDate();
  }

  Widget _buildExpiredOrChild(DateTime? expiryDate) {
    Widget resultWidget;

    if (expiryDate == null) {
      // No remote date and no fallback → fail-open
      resultWidget = widget.child;
    } else {
      const service = ExpiryService();
      if (service.isExpired(expiryDate)) {
        resultWidget = widget.expiredWidget ??
            DefaultExpiredScreen(
              expiryDate: expiryDate,
              title: widget.expiredTitle,
              message: widget.expiredMessage,
              contactInfo: widget.contactInfo,
            );

        if (widget.watermark != null && !widget.watermark!.showOnExpiredScreen) {
          return resultWidget; // Skip watermark if app is expired and configured not to show
        }
      } else {
        resultWidget = widget.child;
      }
    }

    if (widget.watermark != null) {
      return WatermarkOverlay(
        config: widget.watermark,
        child: resultWidget,
      );
    }

    return resultWidget;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateTime?>(
      future: _fetchFuture,
      builder: (context, snapshot) {
        // Still loading
        if (snapshot.connectionState != ConnectionState.done) {
          return widget.loadingWidget ??
              const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
        }

        // Fetch completed — use remote date, or fallback
        final remoteDate = snapshot.data;
        final effectiveDate = remoteDate ?? widget.fallbackExpiryDate;

        return _buildExpiredOrChild(effectiveDate);
      },
    );
  }
}
