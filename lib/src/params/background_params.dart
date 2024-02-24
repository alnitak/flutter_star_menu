import 'package:flutter/material.dart';

/// class to define background
@immutable
class BackgroundParams {
  const BackgroundParams({
    this.animatedBlur = false,
    this.sigmaX = 0.0,
    this.sigmaY = 0.0,
    this.animatedBackgroundColor = false,
    this.backgroundColor = Colors.transparent,
  });

  /// Animate background blur from 0.0 to sigma if true
  final bool animatedBlur;

  /// Horizontal blur
  final double sigmaX;

  /// Vertical blur
  final double sigmaY;

  /// Animate [backgroundColor] from transparent if true
  final bool animatedBackgroundColor;

  /// Background color
  final Color backgroundColor;

  BackgroundParams copyWith({
    bool? animatedBlur,
    double? sigmaX,
    double? sigmaY,
    bool? animatedBackgroundColor,
    Color? backgroundColor,
  }) {
    return BackgroundParams(
      animatedBlur: animatedBlur ?? this.animatedBlur,
      sigmaX: sigmaX ?? this.sigmaX,
      sigmaY: sigmaY ?? this.sigmaY,
      animatedBackgroundColor:
          animatedBackgroundColor ?? this.animatedBackgroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
