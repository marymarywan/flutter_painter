import 'package:flutter/material.dart';

import '../drawables/path/brush_drawable.dart';
import 'free_style_factory.dart';

/// A [FreeStyleFactory] that creates [BrushDrawable]s, for a brush-like
/// free-style pen instead of the default uniform-width stroke.
class BrushFreeStyleFactory extends FreeStyleFactory<BrushDrawable> {
  /// Creates a [BrushFreeStyleFactory].
  const BrushFreeStyleFactory();

  @override
  BrushDrawable create({
    required List<Offset> path,
    required Color color,
    required double strokeWidth,
  }) {
    return BrushDrawable(path: path, color: color, strokeWidth: strokeWidth);
  }
}
