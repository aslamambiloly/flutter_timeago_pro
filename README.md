# flutter_timeago

[![pub.dev](https://img.shields.io/pub/v/flutter_timeago.svg)](https://pub.dev/packages/flutter_timeago)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A Flutter extension that formats `DateTime?` values into **human-friendly, context-aware timestamps** — the way notification apps, chat apps, and social feeds actually show time.

Unlike packages that say *"48 hours ago"* or *"7 days ago"* forever, `flutter_timeago` adapts intelligently based on how far in the past the date is:

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
  flutter_timeago: ^0.0.1
```

Then run:
```bash
flutter pub get
```

---

## Usage

```dart
import 'package:flutter_timeago/flutter_timeago.dart';

// In any widget:
Text(notification.createdAt.toNotificationFormat())
```

### Hide the time portion

```dart
post.publishedAt.toNotificationFormat(isShowTime: false);
// → "Friday" | "15 Jan" | "15 Jan 2024"
```

### 24-hour clock

```dart
dateTime.toNotificationFormat(timePattern: 'HH:mm');
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

dateTime.toNotificationFormat(locale: bahasa);
```

### Testing / custom reference time

```dart
// Pass a fixed "now" so your widget tests are deterministic:
dateTime.toNotificationFormat(
  referenceTime: DateTime(2024, 6, 15, 14, 30),
);
```

---

## API

### `toNotificationFormat`

```dart
String toNotificationFormat({
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

Those packages are great but they keep emitting relative phrases (`"2 days ago"`, `"a week ago"`) no matter how old the date is. For notifications, chat bubbles, or feed items, showing *"a month ago"* is less useful than showing the actual date. `flutter_timeago` switches to absolute dates exactly when relative labels stop being helpful.

---

## License

MIT — see [LICENSE](LICENSE).
