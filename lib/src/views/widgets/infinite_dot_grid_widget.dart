part of 'flutter_painter.dart';

/// Draws a dot grid across the entire viewport, in screen space, that keeps
/// up with [controller]'s current pan and zoom ([PainterController.transformationController])
/// instead of being bounded to the canvas's own size. Sits behind the actual
/// painter content. Used when [FlutterPainter.infiniteDotGrid] is set.
class _InfiniteDotGridLayer extends StatelessWidget {
  const _InfiniteDotGridLayer({required this.controller, required this.grid});

  final PainterController controller;
  final DotGridBackgroundDrawable grid;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller.transformationController,
        builder: (context, child) => CustomPaint(
          painter: _InfiniteDotGridPainter(
            transform: controller.transformationController.value,
            grid: grid,
          ),
        ),
      ),
    );
  }
}

class _InfiniteDotGridPainter extends CustomPainter {
  _InfiniteDotGridPainter({required this.transform, required this.grid});

  final Matrix4 transform;
  final DotGridBackgroundDrawable grid;

  @override
  void paint(Canvas canvas, Size size) {
    // An unbounded size here would make the loops below spin forever.
    if (!size.width.isFinite || !size.height.isFinite) return;

    canvas.drawColor(grid.backgroundColor, BlendMode.src);

    final scale = transform.getMaxScaleOnAxis();
    final spacing = grid.spacing * scale;
    if (spacing <= 0 || !spacing.isFinite) return;

    final translation = transform.getTranslation();
    final offsetX = translation.x % spacing;
    final offsetY = translation.y % spacing;

    final points = <Offset>[];
    for (
      double y = offsetY - spacing;
      y <= size.height + spacing;
      y += spacing
    ) {
      for (
        double x = offsetX - spacing;
        x <= size.width + spacing;
        x += spacing
      ) {
        points.add(Offset(x, y));
      }
    }

    final paint = Paint()
      ..color = grid.dotColor
      ..strokeWidth = grid.dotRadius * 2 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(ui.PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(covariant _InfiniteDotGridPainter oldDelegate) =>
      oldDelegate.transform != transform || oldDelegate.grid != grid;
}
