import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlutterPainter.infiniteDotGrid', () {
    Finder gridFinder() => find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_InfiniteDotGridPainter',
    );

    testWidgets('fills the whole viewport', (tester) async {
      final controller = PainterController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 400,
              child: FlutterPainter(
                controller: controller,
                infiniteDotGrid: const DotGridBackgroundDrawable(),
              ),
            ),
          ),
        ),
      );

      expect(gridFinder(), findsOneWidget);
      expect(tester.getSize(gridFinder()), const Size(300, 400));
    });
  });
}
