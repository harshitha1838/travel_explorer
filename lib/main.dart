import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/matcher_screen.dart';
import 'screens/wishlist_screen.dart';
import 'services/app_state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.load(); // read saved wishlist, trips and theme choice
  runApp(const TravelExplorerApp());
}

/// Lets horizontal lists be dragged with a mouse too (useful in Chrome).
class _DragEverywhere extends MaterialScrollBehavior {
  const _DragEverywhere();
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class TravelExplorerApp extends StatelessWidget {
  const TravelExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild when the user changes the theme.
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => MaterialApp(
        title: 'Travel Explorer',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: appState.themeMode,
        scrollBehavior: const _DragEverywhere(),
        home: const MainShell(),
      ),
    );
  }
}

/// Holds the bottom navigation bar: Explore, Match, Wishlist.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [HomeScreen(), MatcherScreen(), WishlistScreen()],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final count = appState.wishlist.length;
          return NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (i) => setState(() => index = i),
            destinations: [
              const NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: 'Explore'),
              const NavigationDestination(
                  icon: Icon(Icons.auto_awesome_outlined),
                  selectedIcon: Icon(Icons.auto_awesome),
                  label: 'Match'),
              NavigationDestination(
                  icon: Badge(
                      isLabelVisible: count > 0,
                      label: Text('$count'),
                      child: const Icon(Icons.favorite_border)),
                  selectedIcon: const Icon(Icons.favorite),
                  label: 'Wishlist'),
            ],
          );
        },
      ),
    );
  }
}
