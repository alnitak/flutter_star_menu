
import 'dart:ui';

import 'package:flutter/material.dart';

import 'center_widget.dart';

class StarItem extends StatelessWidget {
  final double animValue;
  final int totItems;
  final int index;
  final Offset center;
  final Offset shift;
  final Matrix4 itemMatrix;
  final double rotateRAD;
  final double scale;
  final Function(int index) onItemTapped;
  final Widget child;

  const StarItem(
      {required Key key,
      this.animValue: 0.0,
      required this.totItems,
      required this.index,
      this.center: Offset.zero,
      this.shift: Offset.zero,
      required this.itemMatrix,
      this.rotateRAD: 0.0,
      this.scale: 1.0,
      required this.onItemTapped,
      required this.child})
      : assert(totItems > 0),
        assert(index >= 0 && index < totItems),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // stretch item animation: the last one starts when animValue reach c
    // item1  item2  item3  item4  item5  item6  item7  item8  item9  item10
    //  |------|------|------|------|------|------|------|------|------|
    // 0.0           0.3                                              1.0
    // ie: item3 starts when animValue reach 0.3.
    // So for item3, lerp animValue to be 0.0 when it is 0.3
    double step = (1.0 / totItems) * index;
    double stepDelta = 1.0 / (1 - step);
    double a = (animValue - step < 0.0 ? 0.0 : animValue - step) * stepDelta;

    // lerp from parentBounds position to items end position
    Matrix4 mat = Matrix4.identity()
      ..translate(lerpDouble(center.dx, shift.dx, a) ?? 0,
          lerpDouble(center.dy, shift.dy, a) ?? 0, 0);
    if (rotateRAD > 0) mat.setRotationZ((1.0 - a) * rotateRAD);
    if (scale < 1) mat.scale(lerpDouble(scale, 1.0, a));

    return Transform(
      // key: itemKeys.elementAt(index),
      transform: mat,
      transformHitTests: true,
      child: CenteredWidget(
        child: Opacity(
          opacity: a,
          child: Listener(
            behavior: HitTestBehavior.deferToChild,
            onPointerUp: (_) {
              onItemTapped(index);
            },
            child: child,
          ),
        ),
      ),
    );
  }
}
