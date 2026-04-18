import 'dart:convert';

import 'remote_expiry_fetcher_stub.dart'
    if (dart.library.io) 'remote_expiry_fetcher_io.dart'
    if (dart.library.html) 'remote_expiry_fetcher_web.dart';

/// A service that fetches an expiry date from a remote JSON endpoint.
///
/// Works on **Android, iOS, macOS, Windows, Linux, and Flutter Web** —
/// no third-party dependencies required.
///
/// ---
///
/// ### Quickest usage — one line
///
/// ```dart
/// final date = await RemoteExpiryService.fetch(
///   'https://example.com/expiry.json',
/// );
/// ```
///
/// ### Full configuration
///
/// ```dart
/// final service = RemoteExpiryService(
///   url: 'https://example.com/expiry.json',
///   cacheDuration: Duration(hours: 1),
///   maxRetries: 2,
///   onError: (e) => debugPrint('Expiry fetch error: $e'),
/// );
///
/// final date = await service.fetchExpiryDate();
/// ```
///
/// ### Use inside ExpiryApp
///
/// ```dart
/// ExpiryApp.remote(
///   remoteUrl: 'https://example.com/expiry.json',
///   fallbackExpiryDate: DateTime(2026, 12, 31),
///   child: const MyApp(),
/// )
/// ```
///
/// ---
///
/// ### Expected JSON format
///
/// The endpoint must return a JSON object with an ISO 8601 date string:
///
/// ```json
/// { "expiryDate": "2026-12-31T00:00:00Z" }
/// ```
///
/// The key name is configurable via [jsonKey].
///
/// > **Note:** Dates are always normalised to **UTC** to ensure consistent
/// > behaviour across all user timezones worldwide.
class RemoteExpiryService {
  // ── Static in-memory cache (shared across instances with the same URL) ──
  static final Map<String, DateTime> _cacheValues = {};
  static final Map<String, DateTime> _cacheExpiries = {};

  /// The HTTPS endpoint that returns a JSON object with the expiry date.
  ///
  /// Must begin with `https://` — plain HTTP is rejected for security.
  final String url;

  /// The JSON key whose value is the ISO 8601 expiry date string.
  ///
  /// Defaults to `'expiryDate'`.
  final String jsonKey;

  /// How long to wait for a single network response before giving up.
  ///
  /// Defaults to `Duration(seconds: 10)`.
  final Duration timeout;

  /// How long a successfully fetched date is kept in the in-memory cache
  /// before a new network request is made.
  ///
  /// Set to [Duration.zero] to disable caching entirely.
  ///
  /// Defaults to `Duration(hours: 1)`.
  final Duration cacheDuration;

  /// Number of extra attempts when the network request fails.
  ///
  /// For example, `maxRetries: 2` means up to **3 total attempts**.
  /// Defaults to `2`.
  final int maxRetries;

  /// How long to wait between retry attempts.
  ///
  /// Defaults to `Duration(seconds: 1)`.
  final Duration retryDelay;

  /// Optional HTTP headers sent with every request.
  ///
  /// Useful for APIs that require authentication:
  ///
  /// ```dart
  /// headers: {'Authorization': 'Bearer my-secret-token'}
  /// ```
  final Map<String, String>? headers;

  /// Called whenever a network or parsing error occurs (after all retries).
  ///
  /// Use this to log errors to your crash-reporting tool:
  ///
  /// ```dart
  /// onError: (e) => FirebaseCrashlytics.instance.recordError(e, null),
  /// ```
  ///
  /// When `null`, errors are silently ignored and `null` is returned.
  final void Function(Object error)? onError;

  /// Creates a [RemoteExpiryService].
  ///
  /// [url] **must** begin with `https://`.
  RemoteExpiryService({
    required this.url,
    this.jsonKey = 'expiryDate',
    this.timeout = const Duration(seconds: 10),
    this.cacheDuration = const Duration(hours: 1),
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 1),
    this.headers,
    this.onError,
  }) {
    if (!url.startsWith('https://')) {
      throw ArgumentError(
        'RemoteExpiryService requires an HTTPS url for security. Got: $url',
      );
    }
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Fetches the expiry date from [url] in a single call — no instance needed.
  ///
  /// This is the easiest way to use [RemoteExpiryService]:
  ///
  /// ```dart
  /// final date = await RemoteExpiryService.fetch('https://example.com/expiry.json');
  /// ```
  ///
  /// Optionally handle errors:
  ///
  /// ```dart
  /// final date = await RemoteExpiryService.fetch(
  ///   'https://example.com/expiry.json',
  ///   onError: (e) => debugPrint('Failed: $e'),
  /// );
  /// ```
  static Future<DateTime?> fetch(
    String url, {
    String jsonKey = 'expiryDate',
    Duration timeout = const Duration(seconds: 10),
    Map<String, String>? headers,
    void Function(Object)? onError,
  }) {
    return RemoteExpiryService(
      url: url,
      jsonKey: jsonKey,
      timeout: timeout,
      headers: headers,
      onError: onError,
      cacheDuration: Duration.zero, // one-shot call — skip cache
    ).fetchExpiryDate();
  }

  /// Fetches the expiry date from the remote endpoint.
  ///
  /// - Returns a **UTC** [DateTime] on success.
  /// - Returns `null` if all attempts fail or the date cannot be parsed.
  /// - Retries up to [maxRetries] additional times on failure.
  /// - Results are cached in-memory by URL for [cacheDuration].
  ///
  /// ```dart
  /// final service = RemoteExpiryService(url: 'https://example.com/expiry.json');
  /// final date = await service.fetchExpiryDate();
  /// if (date != null) {
  ///   print('Expires: $date');
  /// }
  /// ```
  Future<DateTime?> fetchExpiryDate() async {
    // ── 1. Return cached value if still valid ─────────────────────────────
    if (cacheDuration > Duration.zero) {
      final cached = _cacheValues[url];
      final expiry = _cacheExpiries[url];
      if (cached != null && expiry != null && DateTime.now().isBefore(expiry)) {
        return cached;
      }
    }

    // ── 2. Attempt fetch with retries ─────────────────────────────────────
    DateTime? result;
    Object? lastError;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      if (attempt > 0) {
        await Future.delayed(retryDelay);
      }

      try {
        final body = await platformFetch(url, timeout, headers);
        if (body == null) continue;

        final json = jsonDecode(body) as Map<String, dynamic>;
        final dateString = json[jsonKey] as String?;
        if (dateString == null) continue;

        final parsed = DateTime.tryParse(dateString);
        if (parsed != null) {
          // Always store/return UTC for consistent behaviour across timezones.
          result = parsed.isUtc ? parsed : parsed.toUtc();
          break;
        }
      } catch (e) {
        lastError = e;
      }
    }

    // ── 3. Report error if all attempts failed ────────────────────────────
    if (result == null && lastError != null) {
      onError?.call(lastError);
    }

    // ── 4. Store in cache ─────────────────────────────────────────────────
    if (result != null && cacheDuration > Duration.zero) {
      _cacheValues[url] = result;
      _cacheExpiries[url] = DateTime.now().add(cacheDuration);
    }

    return result;
  }

  /// Clears the cached result for this [url].
  ///
  /// The next call to [fetchExpiryDate] will make a fresh network request.
  void clearCache() {
    _cacheValues.remove(url);
    _cacheExpiries.remove(url);
  }

  /// Clears cached results for **all** URLs.
  ///
  /// Useful during logout or when resetting app state.
  static void clearAllCache() {
    _cacheValues.clear();
    _cacheExpiries.clear();
  }
}
