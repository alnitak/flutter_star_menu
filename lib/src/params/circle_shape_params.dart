import 'package:flutter/material.dart';

/// class to define circle shape params
@immutable
class CircleShapeParams {
  /// Horizontal radius
  final double radiusX;

  /// Vertical radius
  final double radiusY;

  /// Starting angle for the 1st item. Anticlockwise with 0° on the right
  final double startAngle;

  /// Ending angle for the 1st item. Anticlockwise with 0° on the right
  final double endAngle;

  const CircleShapeParams(
      {this.radiusX = 100,
      this.radiusY = 100,
      this.startAngle = 0,
      this.endAngle = 360});

  CircleShapeParams copyWith({
    double? radiusX,
    double? radiusY,
    double? startAngle,
    double? endAngle,
  }) {
    return CircleShapeParams(
      radiusX: radiusX ?? this.radiusX,
      radiusY: radiusY ?? this.radiusY,
      startAngle: startAngle ?? this.startAngle,
      endAngle: endAngle ?? this.endAngle,
    );
  }
}
