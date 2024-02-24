/*
Copyright (c) 2019-2021, Marco Bavagnoli <marcobavagnolidev@gmail.com>
All rights reserved.
 */
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:star_menu/src/center_widget.dart';

class StarItem extends StatelessWidget {
  const StarItem({
    required Key key,
    required this.totItems,
    required this.index,
    required this.itemMatrix,
    required this.onItemTapped,
    required this.child,
    this.animValue = 0.0,
    this.center = Offset.zero,
    this.shift = Offset.zero,
    this.rotateRAD = 0.0,
    this.scale = 1.0,
    this.onHoverScale = 1.0,
  })  : assert(totItems > 0, '[totItems] must be > 0'),
        assert(
          index >= 0 && index < totItems,
          '0<[index]<[totItems] not in range ',
        ),
        super(key: key);

  final double animValue;
  final int totItems;
  final int index;
  final Offset center;
  final Offset shift;
  final Matrix4 itemMatrix;
  final double rotateRAD;
  final double scale;
  final double onHoverScale;
  final void Function(int index) onItemTapped;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // stretch item animation: the last one starts when animValue reach c
    // item1  item2  item3  item4  item5  item6  item7  item8  item9  item10
    //  |------|------|------|------|------|------|------|------|------|
    // 0.0           0.3                                              1.0
    // ie: item3 starts when animValue reach 0.3.
    // So for item3, lerp animValue to be 0.0 when it is 0.3
    final step = (1.0 / totItems) * index;
    final stepDelta = 1.0 / (1 - step);
    final a = (animValue - step < 0.0 ? 0.0 : animValue - step) * stepDelta;

    final onHover = ValueNotifier<bool>(false);

    // lerp from parentBounds position to items end position
    final mat = Matrix4.identity()
      ..translate(
        lerpDouble(center.dx, shift.dx, a) ?? 0,
        lerpDouble(center.dy, shift.dy, a) ?? 0,
      );
    if (rotateRAD > 0) mat.setRotationZ((1.0 - a) * rotateRAD);
    // if (scale < 1)
    //   mat.scale(lerpDouble(scale, 1.0, a));
    final newScale = lerpDouble(scale, 1.0, a)!;

    return Transform(
      // key: itemKeys.elementAt(index),
      transform: mat,
      child: CenteredWidget(
        child: Opacity(
          opacity: a,
          child: Listener(
            behavior: HitTestBehavior.deferToChild,
            onPointerUp: (_) => onItemTapped(index),
            child: MouseRegion(
              onEnter: (event) => onHover.value = true,
              onExit: (event) => onHover.value = false,
              child: ValueListenableBuilder<bool>(
                valueListenable: onHover,
                builder: (_, isHover, __) {
                  return AnimatedScale(
                    scale: a < 1.0
                        ? newScale
                        : (isHover ? newScale * onHoverScale : newScale),
                    duration: const Duration(milliseconds: 200),
                    child: child,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
