import 'dart:async';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

/// Fetches raw HTTP response body using [dart:html].
///
/// Works on Flutter Web. Uses [html.HttpRequest] with a [Completer] to
/// bridge the event-based XHR API into a standard [Future].
Future<String?> platformFetch(
  String url,
  Duration timeout,
  Map<String, String>? headers,
) async {
  final completer = Completer<String?>();
  final request = html.HttpRequest();
  request.open('GET', url);
  headers?.forEach((key, value) => request.setRequestHeader(key, value));

  request.onLoad.first.then((_) {
    if (!completer.isCompleted) {
      completer.complete(
        request.status == 200 ? request.responseText : null,
      );
    }
  });

  request.onError.first.then((_) {
    if (!completer.isCompleted) completer.complete(null);
  });

  request.send();

  return completer.future.timeout(timeout, onTimeout: () => null);
}
