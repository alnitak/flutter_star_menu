import 'package:flutter/material.dart';

enum LinearAlignment { left, center, right, top, bottom }

/// class to define linear shape params
@immutable
class LinearShapeParams {
  /// Degree angle. Anticlockwise with 0° on 3 o'clock
  final double angle;

  /// Space between items
  final double space;

  /// left, center, right, top, bottom. Useful when the linear shape
  /// is vertical or horizontal
  final LinearAlignment alignment;

  const LinearShapeParams(
      {this.angle = 90,
      this.space = 0,
      this.alignment = LinearAlignment.center});

  LinearShapeParams copyWith({
    double? angle,
    double? space,
    LinearAlignment? alignment,
  }) {
    return LinearShapeParams(
      angle: angle ?? this.angle,
      space: space ?? this.space,
      alignment: alignment ?? this.alignment,
    );
  }
}
