# Upgrade Guide: v2.x → v3.0.1

## What's New in v3.0.1

The `flutter_timeago_pro` package now supports **future dates** in addition to past dates! 

## New Features

### Future Date Formatting
- **Future minutes**: `in 45m`
- **Future hours**: `in 2h`
- **Tomorrow**: `Tomorrow, 02:30 PM`
- **Upcoming weekdays**: `Monday, 02:30 PM`
- **Future dates**: `23 Jun, 02:30 PM`

### New Locale Properties

The `TimestampLocale` class now includes:
- `tomorrow` — Label for the next calendar day (default: `"Tomorrow"`)
- `minutesFromNowPrefix` — Prefix for future minutes (default: `"in "`)
- `hoursFromNowPrefix` — Prefix for future hours (default: `"in "`)

### New Locale Methods
- `minutesFromNow(int minutes)` — Formats future minute count (default: `"in 15m"`)
- `hoursFromNow(int hours)` — Formats future hour count (default: `"in 2h"`)

## Migration Guide

### For Basic Usage (No Breaking Changes)
If you're using the default locale, **no changes are needed**:

```dart
// This works exactly as before for past dates
dateTime.toTimeagoFormat()

// And now also works for future dates!
futureDateTime.toTimeagoFormat() // → "in 45m" or "Tomorrow, 02:30 PM"
```

### For Custom Locales (Optional Updates)

If you have custom `TimestampLocale` instances, you can optionally add future date labels:

#### Before (v2.x)
```dart
const myLocale = TimestampLocale(
  justNow: 'Baru saja',
  yesterday: 'Kemarin',
  minutesAgoSuffix: 'm lalu',
  hoursAgoSuffix: 'j lalu',
);
```

#### After (v3.0.1) — Optional Enhancement
```dart
const myLocale = TimestampLocale(
  justNow: 'Baru saja',
  yesterday: 'Kemarin',
  tomorrow: 'Besok',                    // NEW
  minutesAgoSuffix: 'm lalu',
  hoursAgoSuffix: 'j lalu',
  minutesFromNowPrefix: 'dalam ',       // NEW
  hoursFromNowPrefix: 'dalam ',         // NEW
);
```

If you don't add these new properties, the defaults will be used (`"Tomorrow"`, `"in "`, etc.).

## What Hasn't Changed

- All existing functionality for past dates works identically
- All existing parameters remain the same
- Backward compatibility is maintained
- Default behavior for past dates is unchanged

## Use Cases

Future date support is perfect for:
- **Calendar reminders**: "Event in 45m"
- **Scheduled posts**: "Publishing Tomorrow, 02:30 PM"
- **Upcoming events**: "Meeting in 2h"
- **Countdowns**: "Stream starts in 30m"
- **Deadlines**: "Due Monday, 03:00 PM"

## Questions or Issues?

If you encounter any issues or have questions about the upgrade:
- Open an issue: https://github.com/aslamambiloly/flutter_timeago_pro/issues
- Check the updated README for examples

---

**Note**: This is a major version bump (v3.0.1) due to the new `TimestampLocale` parameters, but existing code will continue to work without modifications thanks to default values.
