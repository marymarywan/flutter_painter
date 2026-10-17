import 'package:flutter/widgets.dart';

/// Represents the settings of scaling the FlutterPainter.
@immutable
class ScaleSettings {
  /// Whether scaling is enabled or not.
  /// If `true`, you'll be able to zoom the FlutterPainter canvas in and out.
  final bool enabled;

  /// The minimum scale that the user can "zoom out" to.
  /// Must be positive.
  final double minScale;

  /// The maximum scale that the user can "zoom in" to.
  /// Must be larger than or equal to [minScale].
  final double maxScale;

  /// How far the user can pan past the painter's own bounds, passed through
  /// to [InteractiveViewer.boundaryMargin].
  ///
  /// When `null` (the default), a margin proportional to [minScale] is
  /// computed automatically, which only allows panning a little past the
  /// edges. Pass `EdgeInsets.all(double.infinity)` for an unbounded,
  /// Miro-style canvas the user can pan around freely in any direction.
  final EdgeInsets? boundaryMargin;

  /// Creates a [ScaleSettings] with the given [enabled], [minScale] and [maxScale] values.
  /// [minScale] will be set to `1` if the provided value is not positive.
  /// [maxScale] will be set equal to [minScale] if the provided value is less than [minScale].
  const ScaleSettings({
    this.enabled = false,
    double minScale = 1,
    double maxScale = 5,
    this.boundaryMargin,
  }) : minScale = minScale <= 0 ? 1 : minScale,
       maxScale = maxScale >= minScale ? maxScale : minScale;

  /// Creates a copy of this but with the given fields replaced with the new values.
  ScaleSettings copyWith({
    bool? enabled,
    double? minScale,
    double? maxScale,
    EdgeInsets? boundaryMargin,
  }) {
    return ScaleSettings(
      enabled: enabled ?? this.enabled,
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      boundaryMargin: boundaryMargin ?? this.boundaryMargin,
    );
  }
}
