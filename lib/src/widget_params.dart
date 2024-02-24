import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

/// Helper class to determine the size and position of a widget
class WidgetParams {
  WidgetParams({
    required this.xPosition,
    required this.yPosition,
    required this.rect,
  });

  WidgetParams.fromContext(BuildContext? context) {
    // Get the widget RenderObject
    final object = context?.findRenderObject();
    // Get the dimensions and position of the widget
    final translation =
        object?.getTransformTo(null).getTranslation() ?? vector.Vector3.zero();
    final size = object?.semanticBounds.size ?? Size.zero;

    xPosition = translation.x;
    yPosition = translation.y;
    rect = Rect.fromLTWH(translation.x, translation.y, size.width, size.height);
  }

  late double xPosition;
  late double yPosition;
  late Rect rect;

  @override
  String toString() {
    return 'X,Y,rect: $xPosition,$yPosition  $rect';
  }
}
