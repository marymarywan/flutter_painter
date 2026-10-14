import 'package:flutter/cupertino.dart';

import 'background_drawable.dart';

/// Drawable to use an evenly-spaced grid of dots as a background.
@immutable
class DotGridBackgroundDrawable extends BackgroundDrawable {
  /// The base color painted behind the dots.
  final Color backgroundColor;

  /// The color of each dot.
  final Color dotColor;

  /// The radius of each dot.
  final double dotRadius;

  /// The distance between each dot, horizontally and vertically.
  final double spacing;

  /// Creates a [DotGridBackgroundDrawable] to use a dot grid as a background.
  const DotGridBackgroundDrawable({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.dotColor = const Color(0xFFDADFE6),
    this.dotRadius = 1.4,
    this.spacing = 24,
  });

  /// Draws the background on the provided [canvas] of size [size].
  @override
  void draw(Canvas canvas, Size size) {
    canvas.drawColor(backgroundColor, BlendMode.src);

    final points = <Offset>[];
    for (double y = 0; y <= size.height; y += spacing) {
      for (double x = 0; x <= size.width; x += spacing) {
        points.add(Offset(x, y));
      }
    }

    final paint = Paint()
      ..color = dotColor
      ..strokeWidth = dotRadius * 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.points, points, paint);
  }
}
