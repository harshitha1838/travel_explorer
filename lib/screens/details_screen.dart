import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets/safe_image.dart';

/// Destination details: best time, about, attractions, food, stays, map and trip planner.
class DetailsScreen extends StatefulWidget {
  final Destination destination;
  const DetailsScreen({super.key, required this.destination});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  DateTimeRange? range;
  int travelers = 1;

  @override
  void initState() {
    super.initState();
    // Reload a previously saved trip for this destination.
    final trip = appState.trips[widget.destination.id];
    if (trip != null) {
      range = DateTimeRange(start: trip.start, end: trip.end);
      travelers = trip.travelers;
    }
  }

  Future<void> pickDates() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final canReuse = range != null && !range!.start.isBefore(today);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 730)),
      initialDateRange: canReuse ? range : null,
    );
    if (picked != null) setState(() => range = picked);
  }

  void saveTrip() {
    if (range == null) return;
    appState.saveTrip(
      widget.destination.id,
      TripPlan(start: range!.start, end: range!.end, travelers: travelers),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Trip saved to your bucket list')));
  }

  // ---------- small reusable pieces ----------

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 10),
        child: Text(text,
            style: const TextStyle(
                fontFamily: serif, fontSize: 20, fontWeight: FontWeight.bold)),
      );

  BoxDecoration _box() => BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.line),
      );

  Widget _fact(IconData icon, String label, String value, Color color) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: _box(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(fontSize: 12, color: context.muted)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );

  // ---------- sections ----------

  Widget _attractionRow(Destination d, Attraction a) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: _box(),
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          SafeImage(
              source: a.image,
              label: a.name,
              category: d.category,
              width: 100,
              height: 90),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
                  const SizedBox(height: 3),
                  Text(a.about, style: TextStyle(fontSize: 13, color: context.muted)),
                ],
              ),
            ),
          ),
        ]),
      );

  Widget _foodCard(Destination d, Food f) => Container(
        width: 165,
        margin: const EdgeInsets.only(right: 12),
        decoration: _box(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              width: double.infinity,
              child: SafeImage(source: f.image, label: f.name, category: d.category),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 3),
                  Text(f.about,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: context.muted)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _stayCard(Stay s, Color color) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: _box(),
        child: Row(children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                color: color.withAlpha(30), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.bed_outlined, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text('${s.type} · from ${rupees(s.pricePerNight)}/night',
                    style: TextStyle(fontSize: 12.5, color: context.muted)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF2A900)),
                  const SizedBox(width: 3),
                  Text('${s.rating} on Google',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ]),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'View on Google Maps',
            icon: const Icon(Icons.map_outlined),
            onPressed: () => openInMaps(context, s.mapQuery),
          ),
        ]),
      );

  /// Trip planner with a photo banner, dates, travellers and budget estimate.
  Widget _planCard(Destination d, Color color) {
    final days = range == null ? 0 : range!.duration.inDays + 1;
    final estimate = days * travelers * d.costPerPersonPerDay;
    final people = travelers == 1 ? '1 traveller' : '$travelers travellers';
    return Container(
      decoration: _box(),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: SafeImage(source: d.image, label: d.name, category: d.category),
          ),
          Positioned.fill(child: Container(color: Colors.black45)),
          Positioned(
            left: 14,
            right: 14,
            bottom: 12,
            child: Text(
              range == null ? 'Your trip to ${d.name}' : '${d.name} · $days days · $people',
              style: const TextStyle(
                  fontFamily: serif,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            OutlinedButton.icon(
              onPressed: pickDates,
              icon: const Icon(Icons.date_range),
              label: Text(range == null
                  ? 'Choose travel dates'
                  : '${formatDate(range!.start)} - ${formatDate(range!.end)}'),
            ),
            const SizedBox(height: 10),
            Row(children: [
              const Expanded(child: Text('Travellers')),
              IconButton(
                onPressed: travelers > 1 ? () => setState(() => travelers--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$travelers',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              IconButton(
                onPressed: travelers < 20 ? () => setState(() => travelers++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ]),
            const Divider(),
            if (range == null)
              Text('Pick dates to see an estimated budget.',
                  style: TextStyle(color: context.muted))
            else ...[
              Text('${rupees(d.costPerPersonPerDay)} × $people × $days day(s)',
                  style: TextStyle(fontSize: 12.5, color: context.muted)),
              const SizedBox(height: 4),
              Text('Estimated budget: ${rupees(estimate)}',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: color),
                    onPressed: saveTrip,
                    child: const Text('Save trip')),
              ),
            ],
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    final color = context.cat(d.category);

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final saved = appState.isSaved(d.id);
        return Scaffold(
          appBar: AppBar(
            title: Text(d.name),
            actions: [
              IconButton(
                tooltip: saved ? 'Remove from wishlist' : 'Add to wishlist',
                icon: Icon(saved ? Icons.favorite : Icons.favorite_border,
                    color: saved ? Colors.red : null),
                onPressed: () => appState.toggleWishlist(d.id),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: SafeImage(source: d.image, label: d.name, category: d.category),
                ),
              ),
              const SizedBox(height: 16),
              Text('${categoryEmoji(d.category)}  ${d.category.toUpperCase()}',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1)),
              const SizedBox(height: 4),
              Text(d.name,
                  style: const TextStyle(
                      fontFamily: serif, fontSize: 32, fontWeight: FontWeight.bold)),
              Row(children: [
                Icon(Icons.place_outlined, size: 16, color: context.muted),
                const SizedBox(width: 4),
                Text(d.location, style: TextStyle(color: context.muted)),
              ]),
              const SizedBox(height: 14),
              // Best time to visit
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withAlpha(28),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withAlpha(90)),
                ),
                child: Row(children: [
                  Icon(Icons.wb_sunny_outlined, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BEST TIME TO VISIT',
                            style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: color,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(d.bestTime,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              Row(children: [
                _fact(Icons.payments_outlined, 'Budget',
                    '${rupees(d.costPerPersonPerDay)}/day', color),
                const SizedBox(width: 10),
                _fact(Icons.timelapse, 'Ideal trip', '${d.idealDays} days', color),
              ]),
              _title('About'),
              Text(d.description, style: const TextStyle(fontSize: 15.5, height: 1.5)),
              _title('Popular attractions'),
              ...d.attractions.map((a) => _attractionRow(d, a)),
              _title('Must-try food'),
              SizedBox(
                height: 215,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: d.foods.map((f) => _foodCard(d, f)).toList(),
                ),
              ),
              _title('Where to stay'),
              ...d.stays.map((s) => _stayCard(s, color)),
              Text(
                  'Ratings are approximate Google review scores. Tap the map button for live reviews, photos and directions.',
                  style: TextStyle(fontSize: 12, color: context.muted)),
              _title('Location'),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: color,
                    side: BorderSide(color: color)),
                onPressed: () => openInMaps(context, d.mapQuery),
                icon: const Icon(Icons.map_outlined),
                label: Text('Open ${d.name} in Google Maps'),
              ),
              _title('Plan your trip'),
              _planCard(d, color),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: color, minimumSize: const Size.fromHeight(50)),
                onPressed: () => appState.toggleWishlist(d.id),
                icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
                label: Text(saved ? 'Remove from wishlist' : 'Add to wishlist'),
              ),
            ),
          ),
        );
      },
    );
  }
}
