import 'package:tictac_duel/lib.dart';

class WaitingIndicatorPainter extends CustomPainter {
  const WaitingIndicatorPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 - 3;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.border;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.neonPurple;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      progress * 2 * 3.14159265359,
      4.2,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant WaitingIndicatorPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
