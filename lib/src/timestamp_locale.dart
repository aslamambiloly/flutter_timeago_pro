/// Holds all user-facing strings used by [DateTimeFormatting].
///
/// Override any field to localise or customise the output.
///
/// ```dart
/// final myLocale = TimestampLocale(
///   justNow: 'Baru saja',
///   yesterday: 'Kemarin',
///   unknownTime: 'Waktu tidak diketahui',
/// );
/// dateTime.toNotificationFormat(locale: myLocale);
/// ```
class TimestampLocale {
  /// Label returned when the difference is less than one minute.
  final String justNow;

  /// Suffix appended to minute count, e.g. "3m ago".
  final String minutesAgoSuffix;

  /// Label used for the previous calendar day.
  final String yesterday;

  /// Returned when [DateTime] is null.
  final String unknownTime;

  const TimestampLocale({
    this.justNow = 'Just now',
    this.minutesAgoSuffix = 'm ago',
    this.yesterday = 'Yesterday',
    this.unknownTime = 'Unknown time',
  });

  /// Builds the "Xm ago" string. Override by subclassing if you need
  /// different grammar (e.g. "vor 3 Min.").
  String minutesAgo(int minutes) => '$minutes$minutesAgoSuffix';
}
