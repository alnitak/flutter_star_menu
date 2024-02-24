import 'package:flutter/material.dart';

/// boundary background parameters
@immutable
class BoundaryBackground {
  BoundaryBackground({
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(8),
    Decoration? decoration,
    this.blurSigmaX,
    this.blurSigmaY,
  }) : decoration = decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color,
            );

  /// color of the boundary background
  final Color color;

  /// padding
  final EdgeInsets padding;

  /// background Container widget decoration
  final Decoration? decoration;

  /// background blur sigmaX value
  final double? blurSigmaX;

  /// background blur sigmaY value
  final double? blurSigmaY;

  BoundaryBackground copyWith({
    Color? color,
    EdgeInsets? padding,
    Decoration? decoration,
  }) {
    return BoundaryBackground(
      color: color ?? this.color,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
    );
  }
}
