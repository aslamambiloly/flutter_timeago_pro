import 'package:flutter/material.dart';
import 'package:flutter_timeago_pro/flutter_timeago_pro.dart';

void main() => runApp(const FlutterTimeagoDemo());

class FlutterTimeagoDemo extends StatelessWidget {
  const FlutterTimeagoDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_timeago_pro demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const _DemoPage(),
    );
  }
}

class _DemoPage extends StatelessWidget {
  const _DemoPage();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final timestamps = <(String, DateTime?)>[
      ('null value', null),
      ('20 seconds ago', now.subtract(const Duration(seconds: 20))),
      ('45 minutes ago', now.subtract(const Duration(minutes: 45))),
      ('2 hours ago (today)', now.subtract(const Duration(hours: 2))),
      ('Yesterday', now.subtract(const Duration(days: 1))),
      ('3 days ago', now.subtract(const Duration(days: 3))),
      ('6 days ago', now.subtract(const Duration(days: 6))),
      ('10 days ago (same year)', now.subtract(const Duration(days: 10))),
      ('Different year', DateTime(now.year - 2, 3, 5, 14, 30)),
    ];

    const idLocale = TimestampLocale(
      justNow: 'Baru saja',
      yesterday: 'Kemarin',
      minutesAgoSuffix: 'm lalu',
      hoursAgoSuffix: 'j lalu',
      unknownTime: 'Waktu tidak diketahui',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_timeago_pro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader('Default (showTimeForOveraged: true)'),
          for (final (label, dt) in timestamps)
            _TimestampTile(
              label: label,
              value: dt.toTimeagoFormat(),
            ),
          const SizedBox(height: 24),
          _SectionHeader('showTimeForOveraged: false'),
          for (final (label, dt) in timestamps)
            _TimestampTile(
              label: label,
              value: dt.toTimeagoFormat(showTimeForOveraged: false),
            ),
          const SizedBox(height: 24),
          _SectionHeader('Custom locale (Bahasa Indonesia)'),
          for (final (label, dt) in timestamps)
            _TimestampTile(
              label: label,
              value: dt.toTimeagoFormat(locale: idLocale),
            ),
          const SizedBox(height: 24),
          _SectionHeader('Custom timeago limit (2 hours)'),
          for (final (label, dt) in timestamps)
            _TimestampTile(
              label: label,
              value: dt.toTimeagoFormat(timeagoLimit: const Duration(hours: 2)),
            ),
          const SizedBox(height: 24),
          _SectionHeader('24-hour clock (timePattern: "HH:mm")'),
          for (final (label, dt) in timestamps)
            _TimestampTile(
              label: label,
              value: dt.toTimeagoFormat(timePattern: 'HH:mm'),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.tealAccent),
      ),
    );
  }
}

class _TimestampTile extends StatelessWidget {
  final String label;
  final String value;
  const _TimestampTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
