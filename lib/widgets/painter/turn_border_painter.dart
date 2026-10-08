import 'package:flutter/material.dart';

class TurnBorderPainter extends CustomPainter {
  const TurnBorderPainter({
    required this.progress,
    required this.color,
    required this.borderRadius,
  });

  final double progress;
  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    final rect = Offset.zero & size;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect.deflate(0.75),
          Radius.circular(borderRadius),
        ),
      );

    final metric = path.computeMetrics().first;
    final length = metric.length;

    if (length <= 0) {
      return;
    }

    final normalizedProgress = progress.clamp(0.0, 1.0);

    const snakeLengthRatio = 0.20;
    final snakeLength = length * snakeLengthRatio;

    final head = normalizedProgress * length;
    final tail = head - snakeLength;

    Path extract(double start, double end) {
      final result = Path();

      if (start >= 0 && end <= length) {
        return metric.extractPath(start, end);
      }

      if (start < 0) {
        result.addPath(
          metric.extractPath(0, end),
          Offset.zero,
        );

        result.addPath(
          metric.extractPath(length + start, length),
          Offset.zero,
        );

        return result;
      }

      result.addPath(
        metric.extractPath(start, length),
        Offset.zero,
      );

      result.addPath(
        metric.extractPath(0, end - length),
        Offset.zero,
      );

      return result;
    }

    // -------------------------------------------------------------------------
    // Base border
    // -------------------------------------------------------------------------

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color.withValues(alpha: 0.18);

    canvas.drawPath(path, basePaint);

    // -------------------------------------------------------------------------
    // Snake
    // -------------------------------------------------------------------------

    final snakePath = extract(tail, head);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        6,
      );

    canvas.drawPath(snakePath, glowPaint);

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = color;

    canvas.drawPath(snakePath, corePaint);

    // -------------------------------------------------------------------------
    // Head
    // -------------------------------------------------------------------------

    final headOffset = head >= length ? 0.0 : head;

    final tangent = metric.getTangentForOffset(headOffset);

    if (tangent == null) {
      return;
    }

    final headPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        3,
      );

    canvas.drawCircle(
      tangent.position,
      1.8,
      headPaint,
    );
  }

  @override
  bool shouldRepaint(covariant TurnBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}