import 'dart:convert';
import 'dart:io';

/// A service that fetches an expiry date from a remote JSON endpoint.
///
/// This service uses `dart:io` [HttpClient] so it works on mobile and
/// desktop without adding any third-party dependencies.
///
/// ### Expected JSON format
///
/// By default the service looks for a top-level `"expiryDate"` key whose
/// value is an ISO 8601 string:
///
/// ```json
/// { "expiryDate": "2026-12-31T00:00:00" }
/// ```
///
/// You can change the key name via [jsonKey].
///
/// ### Usage
///
/// ```dart
/// final service = RemoteExpiryService(
///   url: 'https://api.example.com/app/expiry',
/// );
///
/// final expiryDate = await service.fetchExpiryDate();
/// if (expiryDate != null) {
///   print('Remote expiry: $expiryDate');
/// }
/// ```
class RemoteExpiryService {
  /// The URL of the JSON endpoint.
  final String url;

  /// The key in the JSON response that holds the expiry date string.
  ///
  /// Defaults to `'expiryDate'`.
  final String jsonKey;

  /// How long to wait for a response before giving up.
  ///
  /// Defaults to 10 seconds.
  final Duration timeout;

  /// Creates a [RemoteExpiryService].
  const RemoteExpiryService({
    required this.url,
    this.jsonKey = 'expiryDate',
    this.timeout = const Duration(seconds: 10),
  });

  /// Fetches the expiry date from the remote endpoint.
  ///
  /// Returns the parsed [DateTime] on success, or `null` if the request
  /// fails, times out, or the response cannot be parsed.
  Future<DateTime?> fetchExpiryDate() async {
    try {
      final client = HttpClient();
      client.connectionTimeout = timeout;

      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close().timeout(timeout);

      if (response.statusCode != 200) {
        client.close();
        return null;
      }

      final body = await response.transform(utf8.decoder).join();
      client.close();

      final json = jsonDecode(body) as Map<String, dynamic>;
      final dateString = json[jsonKey] as String?;

      if (dateString == null) return null;

      return DateTime.tryParse(dateString);
    } catch (_) {
      return null;
    }
  }
}
