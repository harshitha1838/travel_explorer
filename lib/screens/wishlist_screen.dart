import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets/destination_card.dart';
import '../widgets/screen_header.dart';

/// Bucket list: every saved destination, with trip dates if planned.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final saved = destinations.where((d) => appState.isSaved(d.id)).toList();
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ScreenHeader(
                  title: 'My Bucket List',
                  subtitle: saved.isEmpty
                      ? 'Places you love will live here.'
                      : '${saved.length} saved · tap the heart to remove',
                ),
                const SizedBox(height: 18),
                if (saved.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(children: [
                      const Text('🧳', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 12),
                      Text(
                        'Nothing saved yet.\nTap the heart on any destination to add it.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.muted),
                      ),
                    ]),
                  ),
                ...saved.map((d) {
                  final trip = appState.trips[d.id];
                  return DestinationCard(
                      destination: d,
                      tripLine: trip == null ? null : tripSummary(trip));
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
