import 'package:flutter/material.dart';

import 'path_drawable.dart';

/// A [PathDrawable] that mimics a brush stroke.
///
/// Instead of a single uniform-width line, the stroke is stamped as
/// overlapping filled circles whose radius tapers with how far apart
/// consecutive points are: points close together (slow movement) draw
/// thicker, points far apart (fast movement) draw thinner, giving a rough
/// calligraphy-brush feel without needing pressure input.
class BrushDrawable extends PathDrawable {
  /// The color the brush stroke will be drawn with.
  final Color color;

  /// Creates a [BrushDrawable] to draw [path].
  BrushDrawable({
    required super.path,
    super.strokeWidth,
    this.color = Colors.black,
    super.hidden,
  });

  @override
  BrushDrawable copyWith({
    bool? hidden,
    List<Offset>? path,
    Color? color,
    double? strokeWidth,
  }) {
    return BrushDrawable(
      path: path ?? this.path,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      hidden: hidden ?? this.hidden,
    );
  }

  @protected
  @override
  Paint get paint => Paint()
    ..style = PaintingStyle.fill
    ..color = color.withValues(alpha: 0.85);

  @override
  void draw(Canvas canvas, Size size) {
    final brushPaint = paint;

    if (path.length == 1) {
      canvas.drawCircle(path.first, strokeWidth / 2, brushPaint);
      return;
    }

    for (var i = 1; i < path.length; i++) {
      final start = path[i - 1];
      final end = path[i];
      final distance = (end - start).distance;
      if (distance == 0) continue;

      final speedFactor = (6 / distance).clamp(0.5, 1.8);
      final radius = (strokeWidth / 2) * speedFactor;

      final steps = (distance / 1.5).ceil().clamp(1, 40);
      for (var step = 0; step <= steps; step++) {
        final point = Offset.lerp(start, end, step / steps)!;
        canvas.drawCircle(point, radius, brushPaint);
      }
    }
  }
}
