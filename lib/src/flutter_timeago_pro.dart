import 'package:flutter/material.dart' show DateUtils;
import 'package:intl/intl.dart';
import 'timestamp_locale.dart';

/// Human-friendly timestamp formatting extension on nullable [DateTime].
///
/// The output adapts automatically based on how far in the past [this] is:
///
/// | Age                     | Example output           |
/// |-------------------------|--------------------------|
/// | < 1 minute              | `Just now`               |
/// | < 1 hour                | `45m ago`                |
/// | Today                   | `02:30 PM`               |
/// | Yesterday               | `Yesterday, 02:30 PM`    |
/// | 2–6 days ago (same wk)  | `Friday, 02:30 PM`       |
/// | Same year, > 1 week     | `15 Jan, 02:30 PM`       |
/// | Different year          | `15 Jan 2024, 02:30 PM`  |
/// | null                    | `Unknown time`           |
///
/// ### Basic usage
/// ```dart
/// import 'package:flutter_timeago_pro/flutter_timeago_pro.dart';
///
/// Text(notification.createdAt.toTimeagoFormat());
/// ```
///
/// ### Hide the time portion
/// ```dart
/// post.publishedAt.toTimeagoFormat(isShowTime: false);
/// // → "Friday" / "15 Jan" / "15 Jan 2024"
/// ```
///
/// ### Custom locale / i18n
/// ```dart
/// const id = TimestampLocale(
///   justNow: 'Baru saja',
///   yesterday: 'Kemarin',
///   minutesAgoSuffix: 'm lalu',
///   unknownTime: 'Waktu tidak diketahui',
/// );
/// dateTime.toTimeagoFormat(locale: id);
/// ```
///
/// ### Custom time format
/// ```dart
/// dateTime.toTimeagoFormat(timePattern: 'HH:mm'); // 24-hour
/// ```
extension DateTimeFormatting on DateTime? {
  /// Returns a human-friendly notification timestamp string relative to now.
  ///
  /// Parameters:
  /// - [isShowTime] — whether to append the time of day. Defaults to `true`.
  /// - [locale] — override labels (for i18n / custom wording).
  /// - [timePattern] — `intl` [DateFormat] pattern for the time portion.
  ///   Defaults to `'hh:mm a'` (12-hour with AM/PM).
  /// - [referenceTime] — the "now" used for comparison. Useful for testing
  ///   or showing relative times against a non-current anchor.
  String toTimeagoFormat({
    bool isShowTime = true,
    TimestampLocale locale = const TimestampLocale(),
    String timePattern = 'hh:mm a',
    DateTime? referenceTime,
  }) {
    if (this == null) return locale.unknownTime;

    final dateTime = this!;
    final now = referenceTime ?? DateTime.now();
    final difference = now.difference(dateTime);
    final timeFormat = DateFormat(timePattern).format(dateTime);

    // ── < 1 minute ──────────────────────────────────────────────────────────
    if (difference.inMinutes < 1) {
      return locale.justNow;
    }

    // ── < 1 hour  ────────────────────────────────────────────────────────────
    if (difference.inHours < 1) {
      return locale.minutesAgo(difference.inMinutes);
    }

    // ── Today ────────────────────────────────────────────────────────────────
    if (DateUtils.isSameDay(dateTime, now)) {
      return timeFormat; // e.g. "02:30 PM"
    }

    // ── Yesterday ────────────────────────────────────────────────────────────
    final yesterday = now.subtract(const Duration(days: 1));
    if (DateUtils.isSameDay(dateTime, yesterday)) {
      return isShowTime ? '${locale.yesterday}, $timeFormat' : locale.yesterday;
    }

    // ── Within the past 7 days (same week feel) ──────────────────────────────
    if (difference.inDays < 7) {
      final weekday = DateFormat('EEEE').format(dateTime); // "Monday"
      return isShowTime ? '$weekday, $timeFormat' : weekday;
    }

    // ── Same calendar year ───────────────────────────────────────────────────
    if (dateTime.year == now.year) {
      final date = DateFormat('d MMM').format(dateTime); // "15 Jan"
      return isShowTime ? '$date, $timeFormat' : date;
    }

    // ── Different year ───────────────────────────────────────────────────────
    final date = DateFormat('d MMM yyyy').format(dateTime); // "15 Jan 2024"
    return isShowTime ? '$date, $timeFormat' : date;
  }
}
