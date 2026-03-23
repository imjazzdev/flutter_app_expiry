/// A service class that provides expiry-related utility methods.
///
/// Use [ExpiryService] to check whether a given [DateTime] has passed,
/// calculate the remaining duration, or get the number of remaining days
/// before expiry.
///
/// ```dart
/// final service = ExpiryService();
/// final expiryDate = DateTime(2026, 12, 31);
///
/// if (service.isExpired(expiryDate)) {
///   print('App has expired!');
/// } else {
///   print('${service.remainingDays(expiryDate)} days remaining');
/// }
/// ```
class ExpiryService {
  /// Creates an [ExpiryService] instance.
  const ExpiryService();

  /// Returns `true` if [DateTime.now()] is at or past [expiryDate].
  bool isExpired(DateTime expiryDate) {
    return DateTime.now().isAfter(expiryDate) ||
        DateTime.now().isAtSameMomentAs(expiryDate);
  }

  /// Returns the [Duration] remaining until [expiryDate].
  ///
  /// If the expiry date has already passed, returns [Duration.zero].
  Duration remainingDuration(DateTime expiryDate) {
    final difference = expiryDate.difference(DateTime.now());
    return difference.isNegative ? Duration.zero : difference;
  }

  /// Returns the number of full days remaining until [expiryDate].
  ///
  /// Returns `0` if the expiry date has already passed.
  int remainingDays(DateTime expiryDate) {
    return remainingDuration(expiryDate).inDays;
  }
}
