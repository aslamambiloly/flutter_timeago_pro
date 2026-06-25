import 'package:flutter/material.dart' show DateUtils;
import 'package:intl/intl.dart';
import 'timestamp_locale.dart';

/// Human-friendly timestamp formatting extension on nullable [DateTime].
///
/// The output adapts automatically based on how far in the past or future [this] is:
///
/// | Age/Time                | Example output           |
/// |-------------------------|--------------------------|
/// | < 1 minute              | `Just now`               |
/// | < 1 hour (past)         | `45m ago`                |
/// | < 1 hour (future)       | `in 45m`                 |
/// | Today                   | `02:30 PM`               |
/// | Yesterday               | `Yesterday, 02:30 PM`    |
/// | Tomorrow                | `Tomorrow, 02:30 PM`     |
/// | 2–6 days ago (same wk)  | `Friday, 02:30 PM`       |
/// | 2–6 days ahead (same wk)| `Monday, 02:30 PM`       |
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
/// post.publishedAt.toTimeagoFormat(showTimeForOveraged: false);
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
  /// - [showTimeForOveraged] — whether to append the time of day. Defaults to `true`.
  /// - [locale] — override labels (for i18n / custom wording).
  /// - [timePattern] — `intl` [DateFormat] pattern for the time portion.
  ///   Defaults to `'hh:mm a'` (12-hour with AM/PM).
  /// - [referenceTime] — the "now" used for comparison. Useful for testing
  ///   or showing relative times against a non-current anchor.
  /// - [timeagoLimit] — the maximum age for which the timeago format ("Xm ago") is used.
  ///   Defaults to 1 hour. After this limit, it falls back to 'Today', 'Yesterday', etc.
  String toTimeagoFormat({
    bool showTimeForOveraged = true,
    TimestampLocale locale = const TimestampLocale(),
    String timePattern = 'hh:mm a',
    DateTime? referenceTime,
    Duration timeagoLimit = const Duration(hours: 1),
  }) {
    if (this == null) return locale.unknownTime;

    final dateTime = this!;
    final now = referenceTime ?? DateTime.now();
    final difference = now.difference(dateTime);
    final isFuture = difference.isNegative;
    final absoluteDifference = difference.abs();
    final timeFormat = DateFormat(timePattern).format(dateTime);

    // ── < 1 minute (past or future) ─────────────────────────────────────────
    if (absoluteDifference.inMinutes < 1) {
      return locale.justNow;
    }

    // ── Less than timeagoLimit (default: 1 hour) ────────────────────────────
    if (absoluteDifference.compareTo(timeagoLimit) < 0) {
      if (absoluteDifference.inHours < 1) {
        return isFuture
            ? locale.minutesFromNow(absoluteDifference.inMinutes)
            : locale.minutesAgo(absoluteDifference.inMinutes);
      } else {
        return isFuture
            ? locale.hoursFromNow(absoluteDifference.inHours)
            : locale.hoursAgo(absoluteDifference.inHours);
      }
    }

    // ── Today ────────────────────────────────────────────────────────────────
    if (DateUtils.isSameDay(dateTime, now)) {
      return timeFormat; // e.g. "02:30 PM"
    }

    // For future dates
    if (isFuture) {
      // ── Tomorrow ───────────────────────────────────────────────────────────
      final tomorrow = now.add(const Duration(days: 1));
      if (DateUtils.isSameDay(dateTime, tomorrow)) {
        return showTimeForOveraged
            ? '${locale.tomorrow}, $timeFormat'
            : locale.tomorrow;
      }

      // ── Within the next 7 days (same week feel) ────────────────────────────
      if (absoluteDifference.inDays < 7) {
        final weekday = DateFormat('EEEE').format(dateTime); // "Monday"
        return showTimeForOveraged ? '$weekday, $timeFormat' : weekday;
      }

      // ── Same calendar year ─────────────────────────────────────────────────
      if (dateTime.year == now.year) {
        final date = DateFormat('d MMM').format(dateTime); // "15 Jan"
        return showTimeForOveraged ? '$date, $timeFormat' : date;
      }

      // ── Different year ─────────────────────────────────────────────────────
      final date = DateFormat('d MMM yyyy').format(dateTime); // "15 Jan 2024"
      return showTimeForOveraged ? '$date, $timeFormat' : date;
    }

    // For past dates
    // ── Yesterday ────────────────────────────────────────────────────────────
    final yesterday = now.subtract(const Duration(days: 1));
    if (DateUtils.isSameDay(dateTime, yesterday)) {
      return showTimeForOveraged
          ? '${locale.yesterday}, $timeFormat'
          : locale.yesterday;
    }

    // ── Within the past 7 days (same week feel) ──────────────────────────────
    if (absoluteDifference.inDays < 7) {
      final weekday = DateFormat('EEEE').format(dateTime); // "Monday"
      return showTimeForOveraged ? '$weekday, $timeFormat' : weekday;
    }

    // ── Same calendar year ───────────────────────────────────────────────────
    if (dateTime.year == now.year) {
      final date = DateFormat('d MMM').format(dateTime); // "15 Jan"
      return showTimeForOveraged ? '$date, $timeFormat' : date;
    }

    // ── Different year ───────────────────────────────────────────────────────
    final date = DateFormat('d MMM yyyy').format(dateTime); // "15 Jan 2024"
    return showTimeForOveraged ? '$date, $timeFormat' : date;
  }
}
