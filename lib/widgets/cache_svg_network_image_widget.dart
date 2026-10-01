import 'package:tictac_duel/lib.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';

class CacheSvgNetworkImageWidget extends StatelessWidget {
  const CacheSvgNetworkImageWidget({
    super.key,
    required this.url,
    required this.size,
    required this.color,
  });

  final String url;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkSVGImage(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      placeholder: ColoredBox(
        color: AppColors.card,
        child: Center(
          child: SizedBox(
            width: size * 0.18,
            height: size * 0.18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color,
            ),
          ),
        ),
      ),
      errorWidget: ColoredBox(
        color: AppColors.card,
        child: Icon(
          Icons.person_outline_rounded,
          color: color,
          size: size * 0.45,
        ),
      ),
    );
  }
}