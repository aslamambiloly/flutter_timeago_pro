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
/// dateTime.toTimeagoFormat(locale: myLocale);
/// ```
class TimestampLocale {
  /// Label returned when the difference is less than one minute.
  final String justNow;

  /// Suffix appended to minute count, e.g. "3m ago".
  final String minutesAgoSuffix;

  /// Suffix appended to hour count, e.g. "2h ago".
  final String hoursAgoSuffix;

  /// Label used for the previous calendar day.
  final String yesterday;

  /// Returned when [DateTime] is null.
  final String unknownTime;

  /// Prefix appended to minute count for future times, e.g. "in 3m".
  final String minutesFromNowPrefix;

  /// Prefix appended to hour count for future times, e.g. "in 2h".
  final String hoursFromNowPrefix;

  /// Label used for the next calendar day.
  final String tomorrow;

  const TimestampLocale({
    this.justNow = 'Just now',
    this.minutesAgoSuffix = 'm ago',
    this.hoursAgoSuffix = 'h ago',
    this.yesterday = 'Yesterday',
    this.unknownTime = 'Unknown time',
    this.minutesFromNowPrefix = 'in ',
    this.hoursFromNowPrefix = 'in ',
    this.tomorrow = 'Tomorrow',
  });

  /// Builds the "Xm ago" string. Override by subclassing if you need
  /// different grammar (e.g. "vor 3 Min.").
  String minutesAgo(int minutes) => '$minutes$minutesAgoSuffix';

  /// Builds the "Xh ago" string. Override by subclassing if you need
  /// different grammar (e.g. "vor 2 Std.").
  String hoursAgo(int hours) => '$hours$hoursAgoSuffix';

  /// Builds the "in Xm" string for future times. Override by subclassing if you need
  /// different grammar.
  String minutesFromNow(int minutes) => '${minutesFromNowPrefix}${minutes}m';

  /// Builds the "in Xh" string for future times. Override by subclassing if you need
  /// different grammar.
  String hoursFromNow(int hours) => '${hoursFromNowPrefix}${hours}h';
}
