import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination.dart';

/// Keeps the wishlist, planned trips and theme choice, and saves them on the
/// device so they are still there after restarting the app.
class AppState extends ChangeNotifier {
  final Set<String> wishlist = {};
  final Map<String, TripPlan> trips = {};
  ThemeMode themeMode = ThemeMode.system;
  SharedPreferences? _prefs;

  /// Reads saved data. Call once before the app starts.
  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    wishlist.addAll(_prefs!.getStringList('wishlist') ?? []);
    final savedTheme = _prefs!.getString('theme');
    themeMode = ThemeMode.values
        .firstWhere((m) => m.name == savedTheme, orElse: () => ThemeMode.system);
    try {
      final rawTrips = _prefs!.getString('trips');
      if (rawTrips != null) {
        (jsonDecode(rawTrips) as Map<String, dynamic>).forEach((id, json) {
          trips[id] = TripPlan.fromJson(json as Map<String, dynamic>);
        });
      }
    } catch (_) {
      // Saved trips were damaged; start fresh.
    }
  }

  bool isSaved(String id) => wishlist.contains(id);

  void toggleWishlist(String id) {
    if (!wishlist.remove(id)) wishlist.add(id);
    _prefs?.setStringList('wishlist', wishlist.toList());
    notifyListeners();
  }

  void saveTrip(String id, TripPlan plan) {
    trips[id] = plan;
    _prefs?.setString(
        'trips', jsonEncode(trips.map((k, v) => MapEntry(k, v.toJson()))));
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    _prefs?.setString('theme', mode.name);
    notifyListeners();
  }
}

/// One shared instance used by every screen.
final appState = AppState();
