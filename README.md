# flutter_timeago_pro

[![pub.dev](https://img.shields.io/pub/v/flutter_timeago_pro.svg)](https://pub.dev/packages/flutter_timeago_pro)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A Flutter extension that formats `DateTime?` values into **human-friendly, context-aware timestamps** — the way notification apps, chat apps, and social feeds actually show time.

Unlike packages that say *"48 hours ago"* or *"7 days ago"* forever, `flutter_timeago_pro` adapts intelligently based on how far in the past the date is:

| Age | Output |
|---|---|
| < 1 minute | `Just now` |
| < 1 hour | `45m ago` |
| Today | `02:30 PM` |
| Yesterday | `Yesterday, 02:30 PM` |
| 2–6 days ago | `Friday, 02:30 PM` |
| Same year, > 1 week | `15 Jan, 02:30 PM` |
| Different year | `15 Jan 2024, 02:30 PM` |
| `null` | `Unknown time` |

---

## Getting started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_timeago_pro: ^0.0.1
```

Then run:
```bash
flutter pub get
```

---

## Usage

```dart
import 'package:flutter_timeago_pro/flutter_timeago_pro.dart';

// In any widget:
Text(notification.createdAt.toTimeagoFormat())
```

### Hide the time portion

```dart
post.publishedAt.toTimeagoFormat(isShowTime: false);
// → "Friday" | "15 Jan" | "15 Jan 2024"
```

### 24-hour clock

```dart
dateTime.toTimeagoFormat(timePattern: 'HH:mm');
// → "14:30"
```

### Custom locale / i18n

```dart
const bahasa = TimestampLocale(
  justNow: 'Baru saja',
  yesterday: 'Kemarin',
  minutesAgoSuffix: 'm lalu',
  unknownTime: 'Waktu tidak diketahui',
);

dateTime.toTimeagoFormat(locale: bahasa);
```

### Testing / custom reference time

```dart
// Pass a fixed "now" so your widget tests are deterministic:
dateTime.toTimeagoFormat(
  referenceTime: DateTime(2024, 6, 15, 14, 30),
);
```

---

## API

### `toTimeagoFormat`

```dart
String toTimeagoFormat({
  bool isShowTime = true,
  TimestampLocale locale = const TimestampLocale(),
  String timePattern = 'hh:mm a',
  DateTime? referenceTime,
})
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isShowTime` | `bool` | `true` | Append the time portion to the label |
| `locale` | `TimestampLocale` | English defaults | Customise "Just now", "Yesterday", etc. |
| `timePattern` | `String` | `'hh:mm a'` | Any `intl` `DateFormat` pattern |
| `referenceTime` | `DateTime?` | `DateTime.now()` | Anchor for relative comparison |

### `TimestampLocale`

```dart
const TimestampLocale({
  String justNow = 'Just now',
  String minutesAgoSuffix = 'm ago',
  String yesterday = 'Yesterday',
  String unknownTime = 'Unknown time',
});
```

---

## Why not `timeago` or `jiffy`?

Those packages are great but they keep emitting relative phrases (`"2 days ago"`, `"a week ago"`) no matter how old the date is. For notifications, chat bubbles, or feed items, showing *"a month ago"* is less useful than showing the actual date. `flutter_timeago_pro` switches to absolute dates exactly when relative labels stop being helpful.

---

## License

MIT — see [LICENSE](LICENSE).
