import 'package:flutter/material.dart';
import '../services/image_service.dart';
import '../theme.dart';

/// Shows a photo from an asset, a web link, or a Wikipedia search phrase.
/// While loading, or if nothing is found, it shows a coloured placeholder
/// with the category emoji and the name, so the screen never looks broken.
class SafeImage extends StatelessWidget {
  final String source;
  final String label;
  final String category;
  final double? width;
  final double? height;

  const SafeImage({
    super.key,
    required this.source,
    required this.label,
    required this.category,
    this.width,
    this.height,
  });

  Widget _placeholder(BuildContext context) {
    final color = context.cat(category);
    final big = (height ?? 100) > 150;
    return Container(
      width: width,
      height: height,
      color: color.withAlpha(45),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(categoryEmoji(category), style: TextStyle(fontSize: big ? 44 : 24)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: color, fontSize: big ? 15 : 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _network(BuildContext context, String url) => Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (c, child, progress) =>
            progress == null ? child : _placeholder(context),
        errorBuilder: (c, e, s) => _placeholder(context),
      );

  @override
  Widget build(BuildContext context) {
    if (source.startsWith('assets/')) {
      return Image.asset(source,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => _placeholder(context));
    }
    if (source.startsWith('http')) return _network(context, source);

    // Otherwise it is a search phrase: look the photo up first.
    return FutureBuilder<String?>(
      future: ImageService.resolve(source),
      builder: (context, snapshot) {
        final url = snapshot.data;
        if (url == null) return _placeholder(context);
        return _network(context, url);
      },
    );
  }
}
