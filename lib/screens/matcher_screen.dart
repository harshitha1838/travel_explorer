import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../models/destination.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets/safe_image.dart';
import '../widgets/screen_header.dart';
import 'details_screen.dart';

/// Smart Trip Matcher: answer three quick questions, get ranked suggestions.
class MatcherScreen extends StatefulWidget {
  const MatcherScreen({super.key});

  @override
  State<MatcherScreen> createState() => _MatcherScreenState();
}

class _MatcherScreenState extends State<MatcherScreen> {
  final Set<String> types = {}; // empty = any style
  double budget = 3500; // rupees per person per day
  int days = 4;

  /// How well a destination fits the answers, from 0 to 100.
  int score(Destination d) {
    var s = 0;
    if (types.isEmpty || types.contains(d.category)) s += 50;
    if (d.costPerPersonPerDay <= budget) {
      s += 30;
    } else {
      s += (30 - (d.costPerPersonPerDay - budget) / 50).round().clamp(0, 30).toInt();
    }
    s += (20 - (d.idealDays - days).abs() * 5).clamp(0, 20).toInt();
    return s;
  }

  /// Short explanations shown under each suggestion.
  List<String> reasons(Destination d) => [
        if (types.isEmpty || types.contains(d.category)) 'Matches your travel style',
        if (d.costPerPersonPerDay <= budget)
          'Fits your budget (${rupees(d.costPerPersonPerDay)}/day)',
        if ((d.idealDays - days).abs() <= 1) 'Great for a ${d.idealDays}-day trip',
      ];

  @override
  Widget build(BuildContext context) {
    final ranked = [...destinations]..sort((a, b) => score(b).compareTo(score(a)));
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const ScreenHeader(
                title: 'Trip Matcher',
                subtitle: 'Tell us what you like, we suggest places.'),
            const SizedBox(height: 18),
            const Text('What kind of trip?',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: categories.where((c) => c != 'All').map((c) {
                final color = context.cat(c);
                final on = types.contains(c);
                return FilterChip(
                  label: Text('${categoryEmoji(c)} $c'),
                  selected: on,
                  selectedColor: color.withAlpha(50),
                  backgroundColor: context.card,
                  showCheckmark: false,
                  side: BorderSide(color: on ? color : context.line),
                  onSelected: (v) => setState(() => v ? types.add(c) : types.remove(c)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Budget: up to ${rupees(budget.round())} per person per day',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: budget,
              min: 2000,
              max: 6000,
              divisions: 8,
              onChanged: (v) => setState(() => budget = v),
            ),
            Row(children: [
              Expanded(
                child: Text('Trip length: $days days',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              IconButton(
                onPressed: days > 1 ? () => setState(() => days--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              IconButton(
                onPressed: days < 14 ? () => setState(() => days++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ]),
            const Divider(height: 28),
            const Text('Best matches for you',
                style: TextStyle(
                    fontFamily: serif, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...ranked.map((d) => _matchTile(d)),
          ],
        ),
      ),
    );
  }

  /// One suggestion row with photo, reasons and match percentage.
  Widget _matchTile(Destination d) {
    final s = score(d);
    final color = context.cat(d.category);
    final why = reasons(d);
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DetailsScreen(destination: d))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          SafeImage(
              source: d.image,
              label: d.name,
              category: d.category,
              width: 90,
              height: 90),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.name,
                      style: const TextStyle(
                          fontFamily: serif, fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(why.isEmpty ? 'Not a close match right now' : why.join(' · '),
                      style: TextStyle(fontSize: 12, color: context.muted)),
                ],
              ),
            ),
          ),
          Container(
            width: 56,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(children: [
              Text('$s%',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 16)),
              Text('match', style: TextStyle(color: color, fontSize: 10)),
            ]),
          ),
        ]),
      ),
    );
  }
}
