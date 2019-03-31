import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class StarItem extends StatelessWidget {

  final double animationValue;
  final Matrix4 itemMatrix;
  final Offset anchor;
  final Widget item;
  final VoidCallback onItemPressed;

  StarItem({
    Key key,
    @required this.animationValue,
    @required this.itemMatrix,
    @required this.anchor,
    @required this.item,
    this.onItemPressed
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CenteredWidget(
      center: anchor,
      child: Transform(
        alignment: FractionalOffset.center,
        transform: itemMatrix,
        child: Opacity(
          opacity: animationValue<=1.0 ? (animationValue>=0.0 ? animationValue : 0.0) : 1.0,
          child: GestureDetector(
            child: item,
            onTap: () {onItemPressed();},
          ),
        ),
      ),
    );
  }
}





/// Helper class to determine the size and position of a widget
class WidgetParams {
  double xPosition;
  double yPosition;
  Rect rect;

  WidgetParams({
    this.xPosition,
    this.yPosition,
    this.rect,
  });

  WidgetParams.fromContext(BuildContext context){
    // Get the widget RenderObject
    final RenderObject object = context.findRenderObject();
    // Get the dimensions and position of the widget
    final translation = object?.getTransformTo(null)?.getTranslation();
    final Size size = object?.semanticBounds?.size;

    xPosition = translation.x;
    yPosition = translation.y;
    rect = Rect.fromLTWH(translation.x, translation.y, size.width, size.height);
  }

  @override
  String toString(){
    return 'X,Y,rect: $xPosition,$yPosition  $rect';
  }
}


/// Center child widget using [center] position
class CenteredWidget extends StatelessWidget {

  final Offset center;
  final Widget child;

  CenteredWidget({
    key,
    this.center,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: center.dx,
      top: center.dy,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}