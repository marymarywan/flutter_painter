import 'package:flutter/material.dart';

import '../drawables/drawable.dart';
import '../drawables/path/brush_drawable.dart';
import 'drawable_json_codec.dart';

/// A [DrawableJsonAdapter] that serializes and deserializes [BrushDrawable]s.
///
/// [BrushDrawable] is not a built-in drawable type, so pass an instance of
/// this adapter to [DrawableJsonCodec]'s `adapters` to be able to save and
/// load canvases that use the brush pen:
///
/// ```dart
/// final codec = DrawableJsonCodec(
///   adapters: const [BrushDrawableJsonAdapter()],
/// );
/// ```
class BrushDrawableJsonAdapter implements DrawableJsonAdapter {
  /// Creates a [BrushDrawableJsonAdapter].
  const BrushDrawableJsonAdapter();

  @override
  String get type => 'brush';

  @override
  bool canEncode(Drawable drawable) => drawable is BrushDrawable;

  @override
  Map<String, Object?> encode(Drawable drawable) {
    final brush = drawable as BrushDrawable;
    return <String, Object?>{
      'hidden': brush.hidden,
      'strokeWidth': brush.strokeWidth,
      'color': _encodeColor(brush.color),
      'path': [for (final point in brush.path) _encodeOffset(point)],
    };
  }

  @override
  BrushDrawable decode(Map<String, Object?> data) {
    final rawPath = (data['path'] as List?) ?? const [];
    return BrushDrawable(
      path: [
        for (final point in rawPath)
          _decodeOffset(point as Map<String, Object?>),
      ],
      color: _decodeColor(data['color'] as Map<String, Object?>),
      strokeWidth: (data['strokeWidth'] as num).toDouble(),
      hidden: data['hidden'] as bool? ?? false,
    );
  }

  static Map<String, Object?> _encodeColor(Color color) => <String, Object?>{
    'alpha': color.a,
    'red': color.r,
    'green': color.g,
    'blue': color.b,
  };

  static Color _decodeColor(Map<String, Object?> data) => Color.from(
    alpha: (data['alpha'] as num).toDouble(),
    red: (data['red'] as num).toDouble(),
    green: (data['green'] as num).toDouble(),
    blue: (data['blue'] as num).toDouble(),
  );

  static Map<String, Object?> _encodeOffset(Offset offset) =>
      <String, Object?>{'dx': offset.dx, 'dy': offset.dy};

  static Offset _decodeOffset(Map<String, Object?> data) => Offset(
    (data['dx'] as num).toDouble(),
    (data['dy'] as num).toDouble(),
  );
}
