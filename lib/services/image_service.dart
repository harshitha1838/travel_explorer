import 'dart:convert';
import 'package:http/http.dart' as http;

/// Finds a photo for a search phrase (e.g. "Hawa Mahal") using Wikipedia's
/// free search API. Results are remembered so each photo is fetched only once.
class ImageService {
  static final Map<String, Future<String?>> _cache = {};

  /// Returns an image URL, or null if none was found.
  static Future<String?> resolve(String query) {
    final future = _cache.putIfAbsent(query, () => _fetch(query));
    // Do not remember failures, so a retry is possible later.
    future.then((url) {
      if (url == null) _cache.remove(query);
    });
    return future;
  }

  static Future<String?> _fetch(String query) async {
    try {
      final uri = Uri.https('en.wikipedia.org', '/w/api.php', {
        'action': 'query',
        'generator': 'search',
        'gsrsearch': query,
        'gsrlimit': '5',
        'prop': 'pageimages',
        'piprop': 'thumbnail',
        'pithumbsize': '700',
        'format': 'json',
        'origin': '*',
      });
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body);
      final pages = (data['query']?['pages'] as Map?)?.values.toList();
      if (pages == null) return null;
      // Best search match first.
      pages.sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
      for (final page in pages) {
        final url = page['thumbnail']?['source'];
        if (url is String) return url;
      }
    } catch (_) {
      // No internet or unexpected reply: the app shows a placeholder instead.
    }
    return null;
  }
}
