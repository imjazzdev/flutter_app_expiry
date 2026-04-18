import 'dart:convert';
import 'dart:io';

/// Fetches raw HTTP response body using [dart:io].
///
/// Works on Android, iOS, macOS, Windows, and Linux.
/// The [HttpClient] is always closed in a `finally` block to prevent
/// socket/memory leaks even when exceptions are thrown mid-flight.
Future<String?> platformFetch(
  String url,
  Duration timeout,
  Map<String, String>? headers,
) async {
  final client = HttpClient();
  client.connectionTimeout = timeout;
  try {
    final request = await client.getUrl(Uri.parse(url)).timeout(timeout);
    headers?.forEach((key, value) => request.headers.set(key, value));

    final response = await request.close().timeout(timeout);
    if (response.statusCode != HttpStatus.ok) return null;

    return response.transform(utf8.decoder).join();
  } finally {
    // Always released — even if an exception is thrown above.
    client.close(force: false);
  }
}
