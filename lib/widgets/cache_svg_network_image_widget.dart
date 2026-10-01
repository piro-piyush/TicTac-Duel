import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tictac_duel/lib.dart';

class CachedSvgNetworkImageWidget extends StatelessWidget {
  const CachedSvgNetworkImageWidget({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    required this.color,
  });

  final String url;
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(url),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.file(
            snapshot.data!,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        }

        if (snapshot.hasError) {
          return const ColoredBox(
            color: AppColors.card,
            child: Icon(Icons.person_outline),
          );
        }

        return ColoredBox(
          color: AppColors.card,
          child: Center(
            child: SizedBox(
              width: width * 0.18,
              height: height * 0.18,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            ),
          ),
        );
      },
    );
  }
}
