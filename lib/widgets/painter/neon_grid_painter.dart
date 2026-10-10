import 'package:tictac_duel/lib.dart';

class NeonGridPainter extends CustomPainter {
  NeonGridPainter({required this.spacing}) : assert(spacing > 0);

  final double spacing;

  late final Paint _paint = Paint()
    ..color = AppColors.neonCyan.withValues(alpha: 0.025)
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    _drawVerticalLines(canvas, size);
    _drawHorizontalLines(canvas, size);
  }

  void _drawVerticalLines(Canvas canvas, Size size) {
    for (var x = 0.0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _paint);
    }
  }

  void _drawHorizontalLines(Canvas canvas, Size size) {
    for (var y = 0.0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant NeonGridPainter oldDelegate) =>
      spacing != oldDelegate.spacing;
}
