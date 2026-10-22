import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';

/// Big serif title with a subtitle and a button to choose light/dark theme.
class ScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const ScreenHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontFamily: serif,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: context.ink)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: context.muted)),
          ],
        ),
      ),
      IconButton.filledTonal(
        tooltip: 'Appearance',
        icon: Icon(context.isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
        onPressed: () => showThemeSheet(context),
      ),
    ]);
  }
}

/// Bottom sheet where the user picks Light, Dark or Auto (follow the device).
void showThemeSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) => ListenableBuilder(
      listenable: appState,
      builder: (context, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Appearance',
                style: TextStyle(
                    fontFamily: serif, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Your choice is remembered next time.',
                style: TextStyle(color: context.muted)),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text('Light')),
                  ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_outlined),
                      label: Text('Dark')),
                  ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto_outlined),
                      label: Text('Auto')),
                ],
                selected: {appState.themeMode},
                onSelectionChanged: (s) => appState.setThemeMode(s.first),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
