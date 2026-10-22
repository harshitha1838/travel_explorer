import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../screens/details_screen.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../utils.dart';
import 'safe_image.dart';

/// Big card: photo, name, location, short description, best time and cost.
class DestinationCard extends StatelessWidget {
  final Destination destination;
  final String? tripLine; // shown on the wishlist when a trip is planned

  const DestinationCard({super.key, required this.destination, this.tripLine});

  @override
  Widget build(BuildContext context) {
    final d = destination;
    final saved = appState.isSaved(d.id);
    final color = context.cat(d.category);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(destination: d)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              SizedBox(
                width: double.infinity,
                height: 170,
                child: SafeImage(source: d.image, label: d.name, category: d.category),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(20)),
                  child: Text('${categoryEmoji(d.category)} ${d.category}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: saved ? 'Remove from wishlist' : 'Add to wishlist',
                    icon: Icon(saved ? Icons.favorite : Icons.favorite_border,
                        color: saved ? Colors.red : const Color(0xFF2B2118)),
                    onPressed: () => appState.toggleWishlist(d.id),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.name,
                      style: TextStyle(
                          fontFamily: serif,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: context.ink)),
                  const SizedBox(height: 2),
                  Row(children: [
                    Icon(Icons.place_outlined, size: 15, color: context.muted),
                    const SizedBox(width: 3),
                    Text(d.location, style: TextStyle(color: context.muted)),
                  ]),
                  const SizedBox(height: 8),
                  Text(d.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.35, color: context.ink)),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 6, children: [
                    _chip(Icons.wb_sunny_outlined, 'Best: ${d.bestTime}', color),
                    _chip(Icons.payments_outlined,
                        'from ${rupees(d.costPerPersonPerDay)}/day', color),
                  ]),
                  if (tripLine != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.flight_takeoff, size: 16, color: color),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(tripLine!,
                                style: const TextStyle(fontSize: 12.5))),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Small coloured pill with an icon.
  Widget _chip(IconData icon, String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(text,
                style: TextStyle(
                    fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ),
        ]),
      );
}
