import 'package:flutter/material.dart';

/// boundary background parameters
@immutable
class BoundaryBackground {
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

  BoundaryBackground(
      {this.color: Colors.white,
      this.padding: const EdgeInsets.all(8.0),
      decoration,
      this.blurSigmaX,
      this.blurSigmaY})
      : decoration = decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color,
            );

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
