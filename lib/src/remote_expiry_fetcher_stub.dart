/// Stub platform fetcher.
///
/// This file is used on platforms where neither [dart:io] nor [dart:html]
/// is available. It always throws [UnsupportedError].
Future<String?> platformFetch(
  String url,
  Duration timeout,
  Map<String, String>? headers,
) async {
  throw UnsupportedError(
    'RemoteExpiryService is not available on this platform.',
  );
}
