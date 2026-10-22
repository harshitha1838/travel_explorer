import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/destination.dart';

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// "5 Nov 2026"
String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

/// 12500 -> "₹12,500"
String rupees(int n) =>
    '₹${n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';

/// e.g. "12 Nov 2026 - 15 Nov 2026 · 2 travellers · starts in 21 days"
String tripSummary(TripPlan t) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final left = t.start.difference(today).inDays;
  final when = left > 1
      ? 'starts in $left days'
      : left == 1
          ? 'starts tomorrow'
          : left == 0
              ? 'starts today'
              : 'dates have passed';
  final people = t.travelers == 1 ? '1 traveller' : '${t.travelers} travellers';
  return '${formatDate(t.start)} - ${formatDate(t.end)} · $people · $when';
}

/// Opens Google Maps (in a new tab / the Maps app) for a place name.
Future<void> openInMaps(BuildContext context, String query) async {
  final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
  final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Could not open Google Maps')));
  }
}
