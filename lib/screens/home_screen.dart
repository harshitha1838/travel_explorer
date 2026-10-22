import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../models/destination.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/destination_card.dart';
import '../widgets/screen_header.dart';

/// Home: header, search, category chips and the list of destinations.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';
  String category = 'All';

  /// Destinations that match both the search text and the chosen category.
  List<Destination> get results {
    final q = query.trim().toLowerCase();
    return destinations
        .where((d) =>
            (category == 'All' || d.category == category) &&
            d.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = results;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: ScreenHeader(
                  title: 'Where to next?',
                  subtitle: 'Discover India, one trip at a time.'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: TextField(
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  hintText: 'Search by destination name',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: context.card,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.line),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: categories.map((c) {
                  final selected = category == c;
                  final color = context.cat(c);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c == 'All' ? 'All' : '${categoryEmoji(c)} $c'),
                      selected: selected,
                      selectedColor: color.withAlpha(50),
                      backgroundColor: context.card,
                      side: BorderSide(color: selected ? color : context.line),
                      showCheckmark: false,
                      onSelected: (_) => setState(() => category = c),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text('${list.length} place${list.length == 1 ? '' : 's'} to explore',
                  style: TextStyle(color: context.muted, fontSize: 13)),
            ),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Text('No destinations found.\nTry another name or category.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.muted)))
                  : ListenableBuilder(
                      listenable: appState,
                      builder: (context, _) => ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        itemCount: list.length,
                        itemBuilder: (context, i) =>
                            DestinationCard(destination: list[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
