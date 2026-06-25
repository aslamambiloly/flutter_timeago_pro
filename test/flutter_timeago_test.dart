import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timeago_pro/flutter_timeago_pro.dart';

void main() {
  // Fixed reference point so tests are deterministic
  final now = DateTime(2024, 6, 15, 14, 30); // Saturday, 15 Jun 2024, 14:30

  DateTime ago(Duration d) => now.subtract(d);
  DateTime fromNow(Duration d) => now.add(d);

  group('toTimeagoFormat —', () {
    test('null returns unknownTime', () {
      expect(
        (null as DateTime?).toTimeagoFormat(referenceTime: now),
        'Unknown time',
      );
    });

    test('< 1 minute → "Just now"', () {
      expect(
        ago(const Duration(seconds: 30))
            .toTimeagoFormat(referenceTime: now),
        'Just now',
      );
    });

    test('exactly 0 seconds → "Just now"', () {
      expect(now.toTimeagoFormat(referenceTime: now), 'Just now');
    });

    test('45 minutes ago → "45m ago"', () {
      expect(
        ago(const Duration(minutes: 45))
            .toTimeagoFormat(referenceTime: now),
        '45m ago',
      );
    });

    test('59 minutes ago → "59m ago"', () {
      expect(
        ago(const Duration(minutes: 59))
            .toTimeagoFormat(referenceTime: now),
        '59m ago',
      );
    });

    test('same day, 2 hours ago → time string', () {
      final result = ago(const Duration(hours: 2))
          .toTimeagoFormat(referenceTime: now);
      expect(result, '12:30 PM');
    });

    test('yesterday → "Yesterday, HH:MM AM/PM"', () {
      final result = ago(const Duration(days: 1))
          .toTimeagoFormat(referenceTime: now);
      expect(result, 'Yesterday, 02:30 PM');
    });

    test('yesterday with showTimeForOveraged:false → "Yesterday"', () {
      final result = ago(const Duration(days: 1))
          .toTimeagoFormat(referenceTime: now, showTimeForOveraged: false);
      expect(result, 'Yesterday');
    });

    test('3 days ago → weekday + time', () {
      // 3 days before Saturday 15 Jun → Wednesday 12 Jun
      final result = ago(const Duration(days: 3))
          .toTimeagoFormat(referenceTime: now);
      expect(result, 'Wednesday, 02:30 PM');
    });

    test('6 days ago → weekday + time', () {
      // 6 days before Sat 15 Jun → Sunday 9 Jun
      final result = ago(const Duration(days: 6))
          .toTimeagoFormat(referenceTime: now);
      expect(result, 'Sunday, 02:30 PM');
    });

    test('6 days ago with showTimeForOveraged:false → weekday only', () {
      final result = ago(const Duration(days: 6))
          .toTimeagoFormat(referenceTime: now, showTimeForOveraged: false);
      expect(result, 'Sunday');
    });

    test('8 days ago (same year) → "d MMM, time"', () {
      final result = ago(const Duration(days: 8))
          .toTimeagoFormat(referenceTime: now);
      expect(result, '7 Jun, 02:30 PM');
    });

    test('same year, showTimeForOveraged:false → "d MMM"', () {
      final result = ago(const Duration(days: 8))
          .toTimeagoFormat(referenceTime: now, showTimeForOveraged: false);
      expect(result, '7 Jun');
    });

    test('different year → "d MMM yyyy, time"', () {
      final old = DateTime(2022, 3, 5, 14, 30);
      final result = old.toTimeagoFormat(referenceTime: now);
      expect(result, '5 Mar 2022, 02:30 PM');
    });

    test('different year, showTimeForOveraged:false → "d MMM yyyy"', () {
      final old = DateTime(2022, 3, 5, 14, 30);
      final result =
          old.toTimeagoFormat(referenceTime: now, showTimeForOveraged: false);
      expect(result, '5 Mar 2022');
    });
  });

  group('Custom locale —', () {
    const id = TimestampLocale(
      justNow: 'Baru saja',
      yesterday: 'Kemarin',
      minutesAgoSuffix: 'm lalu',
      unknownTime: 'Waktu tidak diketahui',
    );

    test('null with custom locale', () {
      expect(
        (null as DateTime?).toTimeagoFormat(referenceTime: now, locale: id),
        'Waktu tidak diketahui',
      );
    });

    test('just now with custom locale', () {
      expect(
        ago(const Duration(seconds: 10))
            .toTimeagoFormat(referenceTime: now, locale: id),
        'Baru saja',
      );
    });

    test('minutes ago with custom locale', () {
      expect(
        ago(const Duration(minutes: 20))
            .toTimeagoFormat(referenceTime: now, locale: id),
        '20m lalu',
      );
    });

    test('yesterday with custom locale', () {
      expect(
        ago(const Duration(days: 1))
            .toTimeagoFormat(referenceTime: now, locale: id),
        'Kemarin, 02:30 PM',
      );
    });
  });

  group('Custom timePattern —', () {
    test('24-hour format', () {
      final result = ago(const Duration(hours: 2))
          .toTimeagoFormat(referenceTime: now, timePattern: 'HH:mm');
      expect(result, '12:30');
    });
  });

  group('Hours ago (within timeagoLimit) —', () {
    test(
        '2 hours ago with default timeagoLimit → time string (falls through to Today)',
        () {
      // Default limit is 1h, so 2h ago bypasses timeago and shows time
      final result =
          ago(const Duration(hours: 2)).toTimeagoFormat(referenceTime: now);
      expect(result, '12:30 PM');
    });

    test('90 minutes ago with extended timeagoLimit → "1h ago"', () {
      // Extend limit to 3h so hoursAgo() is reached
      final result = ago(const Duration(minutes: 90)).toTimeagoFormat(
        referenceTime: now,
        timeagoLimit: const Duration(hours: 3),
      );
      expect(result, '1h ago');
    });

    test('2 hours ago with extended timeagoLimit → "2h ago"', () {
      final result = ago(const Duration(hours: 2)).toTimeagoFormat(
        referenceTime: now,
        timeagoLimit: const Duration(hours: 3),
      );
      expect(result, '2h ago');
    });
  });

  group('Custom timeagoLimit —', () {
    test(
        '45 minutes ago with 30-minute limit → falls through to Today (time string)',
        () {
      final result = ago(const Duration(minutes: 45)).toTimeagoFormat(
        referenceTime: now,
        timeagoLimit: const Duration(minutes: 30),
      );
      expect(result, '01:45 PM');
    });

    test('10 minutes ago with 30-minute limit → "10m ago"', () {
      final result = ago(const Duration(minutes: 10)).toTimeagoFormat(
        referenceTime: now,
        timeagoLimit: const Duration(minutes: 30),
      );
      expect(result, '10m ago');
    });
  });

  group('Custom locale — hours —', () {
    const de = TimestampLocale(
      justNow: 'Gerade eben',
      minutesAgoSuffix: ' Min. her',
      hoursAgoSuffix: ' Std. her',
      yesterday: 'Gestern',
      unknownTime: 'Unbekannte Zeit',
    );

    test('hoursAgo with custom hoursAgoSuffix', () {
      final result = ago(const Duration(hours: 2)).toTimeagoFormat(
        referenceTime: now,
        locale: de,
        timeagoLimit: const Duration(hours: 3),
      );
      expect(result, '2 Std. her');
    });
  });

  group('TimestampLocale defaults —', () {
    test('hoursAgo() returns correct string with default suffix', () {
      const locale = TimestampLocale();
      expect(locale.hoursAgo(3), '3h ago');
    });

    test('minutesAgo() returns correct string with default suffix', () {
      const locale = TimestampLocale();
      expect(locale.minutesAgo(15), '15m ago');
    });
  });

  group('referenceTime defaults to DateTime.now() —', () {
    test('omitting referenceTime still returns a non-empty string', () {
      final recent = DateTime.now().subtract(const Duration(minutes: 5));
      final result = recent.toTimeagoFormat(); // no referenceTime passed
      expect(result, isNotEmpty);
      expect(result, contains('m ago')); // will be "5m ago" give or take
    });

    test('null with no referenceTime returns unknownTime', () {
      expect(
        (null as DateTime?).toTimeagoFormat(),
        'Unknown time',
      );
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FUTURE DATE TESTS
  // ═════════════════════════════════════════════════════════════════════════

  group('Future dates — toTimeagoFormat —', () {
    test('30 seconds from now → "Just now"', () {
      expect(
        fromNow(const Duration(seconds: 30))
            .toTimeagoFormat(referenceTime: now),
        'Just now',
      );
    });

    test('45 minutes from now → "in 45m"', () {
      expect(
        fromNow(const Duration(minutes: 45))
            .toTimeagoFormat(referenceTime: now),
        'in 45m',
      );
    });

    test('59 minutes from now → "in 59m"', () {
      expect(
        fromNow(const Duration(minutes: 59))
            .toTimeagoFormat(referenceTime: now),
        'in 59m',
      );
    });

    test('same day, 2 hours from now → time string', () {
      final result =
          fromNow(const Duration(hours: 2)).toTimeagoFormat(referenceTime: now);
      expect(result, '04:30 PM');
    });

    test('tomorrow → "Tomorrow, HH:MM AM/PM"', () {
      final result =
          fromNow(const Duration(days: 1)).toTimeagoFormat(referenceTime: now);
      expect(result, 'Tomorrow, 02:30 PM');
    });

    test('tomorrow with showTimeForOveraged:false → "Tomorrow"', () {
      final result = fromNow(const Duration(days: 1))
          .toTimeagoFormat(referenceTime: now, showTimeForOveraged: false);
      expect(result, 'Tomorrow');
    });

    test('3 days from now → weekday + time', () {
      // 3 days after Saturday 15 Jun → Tuesday 18 Jun
      final result =
          fromNow(const Duration(days: 3)).toTimeagoFormat(referenceTime: now);
      expect(result, 'Tuesday, 02:30 PM');
    });

    test('6 days from now → weekday + time', () {
      // 6 days after Sat 15 Jun → Friday 21 Jun
      final result =
          fromNow(const Duration(days: 6)).toTimeagoFormat(referenceTime: now);
      expect(result, 'Friday, 02:30 PM');
    });

    test('6 days from now with showTimeForOveraged:false → weekday only', () {
      final result = fromNow(const Duration(days: 6))
          .toTimeagoFormat(referenceTime: now, showTimeForOveraged: false);
      expect(result, 'Friday');
    });

    test('8 days from now (same year) → "d MMM, time"', () {
      final result =
          fromNow(const Duration(days: 8)).toTimeagoFormat(referenceTime: now);
      expect(result, '23 Jun, 02:30 PM');
    });

    test('same year, 8 days from now, showTimeForOveraged:false → "d MMM"', () {
      final result = fromNow(const Duration(days: 8))
          .toTimeagoFormat(referenceTime: now, showTimeForOveraged: false);
      expect(result, '23 Jun');
    });

    test('different year → "d MMM yyyy, time"', () {
      final future = DateTime(2026, 3, 5, 14, 30);
      final result = future.toTimeagoFormat(referenceTime: now);
      expect(result, '5 Mar 2026, 02:30 PM');
    });

    test('different year, showTimeForOveraged:false → "d MMM yyyy"', () {
      final future = DateTime(2026, 3, 5, 14, 30);
      final result = future.toTimeagoFormat(
          referenceTime: now, showTimeForOveraged: false);
      expect(result, '5 Mar 2026');
    });
  });

  group('Future dates — Custom locale —', () {
    const id = TimestampLocale(
      justNow: 'Baru saja',
      tomorrow: 'Besok',
      minutesFromNowPrefix: 'dalam ',
      hoursFromNowPrefix: 'dalam ',
      unknownTime: 'Waktu tidak diketahui',
    );

    test('just now with future time and custom locale', () {
      expect(
        fromNow(const Duration(seconds: 10))
            .toTimeagoFormat(referenceTime: now, locale: id),
        'Baru saja',
      );
    });

    test('minutes from now with custom locale', () {
      expect(
        fromNow(const Duration(minutes: 20))
            .toTimeagoFormat(referenceTime: now, locale: id),
        'dalam 20m',
      );
    });

    test('tomorrow with custom locale', () {
      expect(
        fromNow(const Duration(days: 1))
            .toTimeagoFormat(referenceTime: now, locale: id),
        'Besok, 02:30 PM',
      );
    });
  });

  group('Future dates — Hours from now (within timeagoLimit) —', () {
    test('90 minutes from now with extended timeagoLimit → "in 1h"', () {
      // Extend limit to 3h so hoursFromNow() is reached
      final result = fromNow(const Duration(minutes: 90)).toTimeagoFormat(
        referenceTime: now,
        timeagoLimit: const Duration(hours: 3),
      );
      expect(result, 'in 1h');
    });

    test('2 hours from now with extended timeagoLimit → "in 2h"', () {
      final result = fromNow(const Duration(hours: 2)).toTimeagoFormat(
        referenceTime: now,
        timeagoLimit: const Duration(hours: 3),
      );
      expect(result, 'in 2h');
    });
  });

  group('Future dates — Custom timeagoLimit —', () {
    test(
        '45 minutes from now with 30-minute limit → falls through to Today (time string)',
        () {
      final result = fromNow(const Duration(minutes: 45)).toTimeagoFormat(
        referenceTime: now,
        timeagoLimit: const Duration(minutes: 30),
      );
      expect(result, '03:15 PM');
    });

    test('10 minutes from now with 30-minute limit → "in 10m"', () {
      final result = fromNow(const Duration(minutes: 10)).toTimeagoFormat(
        referenceTime: now,
        timeagoLimit: const Duration(minutes: 30),
      );
      expect(result, 'in 10m');
    });
  });

  group('Future dates — Custom locale hours —', () {
    const de = TimestampLocale(
      justNow: 'Gerade eben',
      minutesFromNowPrefix: 'in ',
      hoursFromNowPrefix: 'in ',
      tomorrow: 'Morgen',
      unknownTime: 'Unbekannte Zeit',
    );

    test('hoursFromNow with custom locale', () {
      final result = fromNow(const Duration(hours: 2)).toTimeagoFormat(
        referenceTime: now,
        locale: de,
        timeagoLimit: const Duration(hours: 3),
      );
      expect(result, 'in 2h');
    });
  });

  group('TimestampLocale future defaults —', () {
    test('hoursFromNow() returns correct string with default prefix', () {
      const locale = TimestampLocale();
      expect(locale.hoursFromNow(3), 'in 3h');
    });

    test('minutesFromNow() returns correct string with default prefix', () {
      const locale = TimestampLocale();
      expect(locale.minutesFromNow(15), 'in 15m');
    });
  });
}
