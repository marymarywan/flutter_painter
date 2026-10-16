part of 'flutter_painter.dart';

/// Wraps [_FlutterPainterWidget] and overlays a circular cursor that follows
/// the pointer while a free-style drawing gesture is active, sized to the
/// current stroke width. Used when [FlutterPainter.showBrushCursor] is true.
class _BrushCursorOverlay extends StatefulWidget {
  const _BrushCursorOverlay({
    required this.controller,
    this.onDrawableCreated,
    this.onDrawableDeleted,
    this.onSelectedObjectDrawableChanged,
    this.onPainterSettingsChanged,
    this.onIsDrawingStateChanged,
    this.onFreeStyleDrawingStarted,
    this.onFreeStyleDrawingUpdated,
    this.onFreeStyleDrawingEnded,
    this.onFreeStyleDrawingCanceled,
  });

  final PainterController controller;
  final DrawableCreatedCallback? onDrawableCreated;
  final DrawableDeletedCallback? onDrawableDeleted;
  final ValueChanged<ObjectDrawable?>? onSelectedObjectDrawableChanged;
  final ValueChanged<PainterSettings>? onPainterSettingsChanged;
  final ValueChanged<bool>? onIsDrawingStateChanged;
  final FreeStyleDrawingCallback? onFreeStyleDrawingStarted;
  final FreeStyleDrawingCallback? onFreeStyleDrawingUpdated;
  final FreeStyleDrawingCallback? onFreeStyleDrawingEnded;
  final FreeStyleDrawingCallback? onFreeStyleDrawingCanceled;

  @override
  State<_BrushCursorOverlay> createState() => _BrushCursorOverlayState();
}

class _BrushCursorOverlayState extends State<_BrushCursorOverlay> {
  final ValueNotifier<Offset?> _cursor = ValueNotifier<Offset?>(null);

  @override
  void dispose() {
    _cursor.dispose();
    super.dispose();
  }

  void _handleStarted(PathDrawable drawable) {
    _cursor.value = drawable.path.isNotEmpty ? drawable.path.last : null;
    widget.onFreeStyleDrawingStarted?.call(drawable);
  }

  void _handleUpdated(PathDrawable drawable) {
    _cursor.value = drawable.path.isNotEmpty ? drawable.path.last : null;
    widget.onFreeStyleDrawingUpdated?.call(drawable);
  }

  void _handleEnded(PathDrawable drawable) {
    _cursor.value = null;
    widget.onFreeStyleDrawingEnded?.call(drawable);
  }

  void _handleCanceled(PathDrawable drawable) {
    _cursor.value = null;
    widget.onFreeStyleDrawingCanceled?.call(drawable);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        _FlutterPainterWidget(
          controller: widget.controller,
          onDrawableCreated: widget.onDrawableCreated,
          onDrawableDeleted: widget.onDrawableDeleted,
          onPainterSettingsChanged: widget.onPainterSettingsChanged,
          onSelectedObjectDrawableChanged:
              widget.onSelectedObjectDrawableChanged,
          onIsDrawingStateChanged: widget.onIsDrawingStateChanged,
          onFreeStyleDrawingStarted: _handleStarted,
          onFreeStyleDrawingUpdated: _handleUpdated,
          onFreeStyleDrawingEnded: _handleEnded,
          onFreeStyleDrawingCanceled: _handleCanceled,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: ValueListenableBuilder<Offset?>(
              valueListenable: _cursor,
              builder: (context, position, child) {
                return ValueListenableBuilder<PainterControllerValue>(
                  valueListenable: widget.controller,
                  builder: (context, value, child) {
                    final freeStyle = value.settings.freeStyle;
                    return CustomPaint(
                      painter: _BrushCursorPainter(
                        position: position,
                        diameter: freeStyle.strokeWidth,
                        color: freeStyle.mode == FreeStyleMode.erase
                            ? Colors.grey
                            : freeStyle.color,
                        filled: freeStyle.mode != FreeStyleMode.erase,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BrushCursorPainter extends CustomPainter {
  _BrushCursorPainter({
    required this.position,
    required this.diameter,
    required this.color,
    required this.filled,
  });

  final Offset? position;
  final double diameter;
  final Color color;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final pos = position;
    if (pos == null) return;

    final radius = diameter / 2;
    if (filled) {
      canvas.drawCircle(
        pos,
        radius,
        Paint()..color = color.withValues(alpha: 0.35),
      );
    }
    canvas.drawCircle(
      pos,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _BrushCursorPainter oldDelegate) =>
      oldDelegate.position != position ||
      oldDelegate.diameter != diameter ||
      oldDelegate.color != color ||
      oldDelegate.filled != filled;
}
