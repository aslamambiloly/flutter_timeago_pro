import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timeago_pro/flutter_timeago_pro.dart';

void main() {
  // Fixed reference point so tests are deterministic
  final now = DateTime(2024, 6, 15, 14, 30); // Saturday, 15 Jun 2024, 14:30

  DateTime ago(Duration d) => now.subtract(d);

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
}
