library star_menu;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'utils/star_item.dart';
import 'utils/widget_params.dart';

enum MenuState {
  closed,
  closing,
  opening,
  open,
}
enum MenuShape {
  circle,
  linear,
  grid,
}

/// Extension on Widget to add a StarMenu easily
extension AddStarMenu on Widget {
  addStarMenu(
      BuildContext context, List<Widget> items, StarMenuParameters params) {
    return StarMenu(params: params, items: items, child: this);
  }
}

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
      {this.radiusX: 100,
      this.radiusY: 100,
      this.startAngle: 0,
      this.endAngle: 360});
}

class GridShapeParams {
  /// Number of columns
  final int columns;

  /// Horizontal space between items
  final int columnsSpaceH;

  /// Vertical space between items
  final int columnsSpaceV;

  const GridShapeParams(
      {this.columns: 3, this.columnsSpaceH: 0, this.columnsSpaceV: 0});
}

enum LinearAlignment { left, center, right, top, bottom }

class LinearShapeParams {
  /// Degree angle. Anticlockwise with 0° on 3 o'clock
  final double angle;

  /// Space between items
  final double space;

  /// left, center, right, top, bottom. Useful when the linear shape
  /// is vertical or horizontal
  final LinearAlignment alignment;

  const LinearShapeParams(
      {this.angle: 90, this.space: 0, this.alignment: LinearAlignment.center});
}

class BackgroundParams {
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

  const BackgroundParams(
      {this.animatedBlur: false,
      this.sigmaX: 0.0,
      this.sigmaY: 0.0,
      this.animatedBackgroundColor: false,
      this.backgroundColor: const Color.fromARGB(128, 0, 0, 0)});
}

class StarMenuParameters {
  /// Menu shape kind. Could be [MenuShape.circle], [MenuShape.linear], [MenuShape.grid]
  final MenuShape shape;

  /// parameters for the linear shape
  final linearShapeParams;

  /// parameters for the circle shape
  final circleShapeParams;

  /// parameters for the grid shape
  final gridShapeParams;

  /// parameters for the background
  final backgroundParams;

  /// Open animation duration
  final int openDurationMs;

  /// Close animation duration
  final int closeDurationMs;

  /// Starting rotation angle of the items that will reach 0 DEG when animation ends
  final double rotateItemsAnimationAngle;

  /// Starting scale of the items that will reach 1 when animation ends
  final double startItemScaleAnimation;

  /// Shift offset of menu center from the center of parent widget
  final Offset centerOffset;

  /// Use the screen center instead of parent widget center
  final bool useScreenCenter;

  /// Checks if the whole menu boundaries exceed screen edges, if so set it in place to be all visible
  final bool checkItemsScreenBoundaries;

  /// Checks if items exceed screen edges, if so set them in place to be visible
  final bool checkMenuScreenBoundaries;

  /// Animation curve kind to use
  final Curve animationCurve;

  /// The callback that is called when a menu item is tapped.
  /// It gives the `ID` of the item and a `controller` to
  /// eventually close the menu
  final Function(int index, StarMenuController controller)? onItemTapped;

  StarMenuParameters({
    this.linearShapeParams: const LinearShapeParams(),
    this.circleShapeParams: const CircleShapeParams(),
    this.gridShapeParams: const GridShapeParams(),
    this.backgroundParams: const BackgroundParams(),
    this.shape: MenuShape.circle,
    this.openDurationMs: 400,
    this.closeDurationMs: 150,
    this.rotateItemsAnimationAngle: 0.0,
    this.startItemScaleAnimation: 0.3,
    this.centerOffset: Offset.zero,
    this.useScreenCenter: false,
    this.checkItemsScreenBoundaries: false,
    this.checkMenuScreenBoundaries: true,
    this.animationCurve: Curves.fastOutSlowIn,
    this.onItemTapped,
  });
}

/// Controller sent back with [StarMenuParameters.onItemTapped] to
/// let you choose to close the menu
class StarMenuController {
  final VoidCallback closeMenu;

  StarMenuController(
    this.closeMenu,
  );
}

class StarMenu extends StatefulWidget {
  final StarMenuParameters params;
  final List<Widget> items;
  final Widget child;
  final StarMenuController? controller;

  const StarMenu({
    Key? key,
    this.controller,
    required this.params,
    required this.items,
    required this.child,
  })  : assert(items.length > 0),
        super(key: key);

  @override
  StarMenuState createState() => StarMenuState();
}

class StarMenuState extends State<StarMenu>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? _controller;
  late Animation<double> _animationPercent;

  late double lineAngleRAD;
  late double circleStartAngleRAD;
  late double circleEndAngleRAD;
  late double rotateItemsAnimationAngleRAD;
  OverlayEntry? overlayEntry;
  late Rect parentBounds;
  late MenuState menuState;
  late Size screenSize;
  late double topPadding;
  late List<WidgetParams> itemsParams;
  late List<GlobalKey> itemKeys;
  late List<Matrix4> itemsMatrix; // final position matrix of animation
  late ValueNotifier<double> animationProgress;
  late bool paramsAlreadyGot;
  late Offset offsetToFitMenuIntoScreen;

  StarMenuController? _starMenuController;

  @override
  void initState() {
    _starMenuController = widget.controller;
    if (_starMenuController == null) {
      _starMenuController = StarMenuController(closeMenu);
    }

    menuState = MenuState.closed;
    overlayEntry = null;
    lineAngleRAD = vector.radians(widget.params.linearShapeParams.angle);
    circleStartAngleRAD =
        vector.radians(widget.params.circleShapeParams.startAngle);
    circleEndAngleRAD =
        vector.radians(widget.params.circleShapeParams.endAngle);
    rotateItemsAnimationAngleRAD =
        vector.radians(widget.params.rotateItemsAnimationAngle);

    animationProgress = ValueNotifier<double>(0.0);
    offsetToFitMenuIntoScreen = Offset.zero;
    paramsAlreadyGot = false;
    itemsParams = List.generate(widget.items.length,
        (index) => WidgetParams(xPosition: 0, yPosition: 0, rect: Rect.zero));
    itemsMatrix =
        List.generate(widget.items.length, (index) => Matrix4.identity());

    _addPostFrameCallback();

    _setupAnimationController();
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    _controller?.dispose();
  }

  @override
  void didChangeMetrics() {
    if (!paramsAlreadyGot && MediaQuery.of(context).size != screenSize) return;

    _addPostFrameCallback();

    overlayEntry?.remove();
    overlayEntry = null;
    paramsAlreadyGot = false;
    _controller?.dispose();
    _setupAnimationController();
    if (menuState == MenuState.open) {
      menuState = MenuState.closed;
      showMenu();
    } else
      menuState = MenuState.closed;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(onPointerUp: (event) => showMenu(), child: widget.child);
  }

  _addPostFrameCallback() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (context.size is Size) {
        // padding, viewInsets and viewPadding return 0 here! Force to be 24
        // topPadding = MediaQuery.of(context).viewPadding.top;
        topPadding = 24;
        screenSize = Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height);
      }
    });
  }

  // setup animation controller
  _setupAnimationController() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.params.openDurationMs),
      vsync: this,
    );

    _animationPercent = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller!, curve: widget.params.animationCurve))
      ..addListener(() {
        animationProgress.value = _animationPercent.value;

        /// Time to get items parameters?
        if (_animationPercent.value > 0 && !paramsAlreadyGot) {
          itemsParams = List.generate(
              widget.items.length,
              (index) => WidgetParams.fromContext(
                  itemKeys.elementAt(index).currentContext));
          paramsAlreadyGot = true;
          itemsMatrix = _calcPosition();
          _checkBoundaries();
        }
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.completed:
            if (_controller?.value == 1.0) {
              menuState = MenuState.open;
            } else
              menuState = MenuState.closed;
            break;
          case AnimationStatus.dismissed:
            if (_animationPercent.value == 0) {
              overlayEntry?.remove();
              overlayEntry = null;
              _controller?.value = 0;
              menuState = MenuState.closed;
            }
            break;
          case AnimationStatus.reverse:
            menuState = MenuState.closing;
            break;
          case AnimationStatus.forward:
            menuState = MenuState.opening;
            break;
        }
      });
  }

  /// Close the menu
  closeMenu() {
    _controller?.animateBack(0,
        duration: Duration(milliseconds: widget.params.closeDurationMs));
  }

  /// Open the menu
  showMenu() {
    overlayEntry = _overlayEntryBuilder();
    _controller?.reset();

    if (overlayEntry != null) {
      // find parent widget bounds
      RenderBox? renderBox = context.findRenderObject() as RenderBox;
      Rect widgetRect = renderBox.paintBounds;
      Offset parentPosition = renderBox.localToGlobal(Offset.zero);
      parentBounds = widgetRect.translate(parentPosition.dx, parentPosition.dy);

      Overlay.of(context)?.insert(overlayEntry!);
      overlayEntry?.addListener(() {
        if (overlayEntry != null &&
            overlayEntry!.mounted &&
            menuState == MenuState.closed) _controller?.forward();
      });
    }
  }

  // Create the overlay object
  OverlayEntry _overlayEntryBuilder() {
    // keys used to get items rect
    itemKeys = List.generate(widget.items.length, (index) => GlobalKey());

    return OverlayEntry(
      // maintainState: true,
      builder: (context) {
        return ValueListenableBuilder(
            valueListenable: animationProgress,
            builder: (_, double animValue, __) {
              Color background = widget.params.backgroundParams.backgroundColor;
              if (widget.params.backgroundParams.animatedBackgroundColor)
                background =
                    Color.lerp(Colors.transparent, background, animValue) ??
                        background;

              Widget child = Material(
                color: background,
                child: Stack(
                    children: [
                  GestureDetector(
                    onTap: () {
                      // this optional check is to just not call closeMenu() if an
                      // item without an onTap event is tapped. Else the
                      // tap is on background and the menu must be closed
                      if (!(menuState == MenuState.closing ||
                          menuState == MenuState.closed)) closeMenu();
                    },
                  )
                ]..addAll(List.generate(
                        widget.items.length,
                        (index) => StarItem(
                              key: itemKeys.elementAt(index),
                              child: widget.items[index],
                              totItems: widget.items.length,
                              index: index,
                              center: parentBounds.center,
                              itemMatrix: itemsMatrix[index],
                              rotateRAD: rotateItemsAnimationAngleRAD,
                              scale: widget.params.startItemScaleAnimation,
                              shift: Offset(
                                  itemsMatrix
                                          .elementAt(index)
                                          .getTranslation()
                                          .x +
                                      offsetToFitMenuIntoScreen.dx,
                                  itemsMatrix
                                          .elementAt(index)
                                          .getTranslation()
                                          .y +
                                      offsetToFitMenuIntoScreen.dy),
                              animValue: animValue,
                              onItemTapped: (id) {
                                print(
                                  'StarMenu: tapped item index $id',
                                );
                                if (widget.params.onItemTapped != null)
                                  widget.params.onItemTapped!(
                                      id, _starMenuController!);
                              },
                            )))),
              );

              if ((widget.params.backgroundParams.sigmaX > 0 ||
                      widget.params.backgroundParams.sigmaY > 0) &&
                  animValue > 0) {
                late double db;
                if (widget.params.backgroundParams.animatedBlur)
                  db = animValue;
                else
                  db = 1.0;
                child = BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0 * db, sigmaY: 3.0 * db),
                  child: child,
                );
              }

              return child;
            });
      },
    );
  }

  // Calculate item center position relative to the animation value
  List<Matrix4> _calcPosition() {
    List<Matrix4> ret =
        List.generate(widget.items.length, (index) => Matrix4.identity());
    Offset newCenter = widget.params.useScreenCenter
        ? Offset(screenSize.width / 2 + widget.params.centerOffset.dx,
            screenSize.height / 2 + widget.params.centerOffset.dy)
        : parentBounds.center + widget.params.centerOffset;

    switch (widget.params.shape) {
      case MenuShape.circle:
        ret.asMap().forEach((index, mat) {
          mat.translate(
              newCenter.dx +
                  cos((circleEndAngleRAD - circleStartAngleRAD) /
                              widget.items.length *
                              index +
                          circleStartAngleRAD) *
                      widget.params.circleShapeParams.radiusX,
              newCenter.dy -
                  sin((circleEndAngleRAD - circleStartAngleRAD) /
                              widget.items.length *
                              index +
                          circleStartAngleRAD) *
                      widget.params.circleShapeParams.radiusY);
        });
        break;

      case MenuShape.linear:
        double radius = 0.0;
        double rotate = lineAngleRAD;
        double itemDiameter = 0.0;
        double firstItemHalfWidth = 0.0;
        double firstItemHalfHeight = 0.0;
        late double halfWidth;
        late double halfHeight;
        double secH;
        double secV;

        ret.asMap().forEach((index, mat) {
          halfWidth = itemsParams[index].rect.width / 2;
          halfHeight = itemsParams[index].rect.height / 2;

          // itemDiameter is calculated by the segment length that intersect
          // the item bounding box passing through the center of the item
          // and intersect the opposite edges by m_startingAngle angle
          secH = (halfHeight / sin(rotate)).abs();
          secV = (halfWidth / sin(pi / 2 - rotate)).abs();

          // checks if the line intersect horizontal or vertical edges
          if (secH < secV)
            itemDiameter = secH * 2.0;
          else
            itemDiameter = secV * 2.0;

          // These checks if the line is perfectly vertical or horizontal
          if ((rotate + pi / 2) / pi == ((rotate + pi / 2) / pi).ceil())
            itemDiameter = halfHeight * 2;
          if (rotate / pi == (rotate / pi).ceil()) itemDiameter = halfWidth * 2;

          if (index == 0) {
            firstItemHalfWidth = halfWidth;
            firstItemHalfHeight = halfHeight;
            mat.translate(newCenter.dx, newCenter.dy);
          } else {
            double alignmentShiftX = 0;
            double alignmentShiftY = 0;
            if (widget.params.linearShapeParams.alignment ==
                LinearAlignment.left) {
              alignmentShiftX = halfWidth - firstItemHalfWidth;
            }
            if (widget.params.linearShapeParams.alignment ==
                LinearAlignment.right) {
              alignmentShiftX = -halfWidth + firstItemHalfWidth;
            }
            if (widget.params.linearShapeParams.alignment ==
                LinearAlignment.top) {
              alignmentShiftY = halfHeight - firstItemHalfHeight;
            }
            if (widget.params.linearShapeParams.alignment ==
                LinearAlignment.bottom) {
              alignmentShiftY = -halfHeight + firstItemHalfHeight;
            }
            mat.translate(
                cos(lineAngleRAD) * (radius + halfWidth - firstItemHalfWidth) +
                    newCenter.dx +
                    alignmentShiftX,
                -sin(lineAngleRAD) *
                        (radius + halfHeight - firstItemHalfHeight) +
                    newCenter.dy +
                    alignmentShiftY);
          }

          radius += itemDiameter + widget.params.linearShapeParams.space;
        });

        break;

      case MenuShape.grid:
        int j = 0;
        int k = 0;
        int n = 0;
        double x = 0;
        double y = 0;
        int count = 0;
        double hMax = 0;
        double wMax = 0;
        double itemWidth;
        double itemHeight;
        List<double> rowsWidth = [];
        List<Point> itemPos = [];

        // Calculating the grid
        while (j * widget.params.gridShapeParams.columns + k <
            widget.items.length) {
          count = 0;
          hMax = 0;
          x = 0;
          // Calculate x position and rows height
          while (k < widget.params.gridShapeParams.columns &&
              j * widget.params.gridShapeParams.columns + k <
                  widget.items.length) {
            itemWidth =
                itemsParams[widget.params.gridShapeParams.columns * j + k]
                    .rect
                    .width;
            itemHeight =
                itemsParams[widget.params.gridShapeParams.columns * j + k]
                    .rect
                    .height;
            itemPos.add(Point(x + itemWidth / 2, y));
            // hMax = max item height in this row
            hMax = max(hMax, itemHeight);
            x += itemWidth + widget.params.gridShapeParams.columnsSpaceH;
            count++;
            k++;
          }
          // wMax = max width of all rows
          wMax = max(wMax, x);
          rowsWidth.add(x - widget.params.gridShapeParams.columnsSpaceH);
          // Calculate y position for items in current row
          for (int i = 0; i < count; i++) {
            itemHeight = itemsParams[
                    widget.params.gridShapeParams.columns * j + k - i - 1]
                .rect
                .height;
            double x1 = itemPos[itemPos.length - i - 1].x.toDouble();
            double y1 = y + hMax / 2;
            itemPos[itemPos.length - i - 1] = Point(x1, y1);
          }
          y += hMax + widget.params.gridShapeParams.columnsSpaceV;
          k = 0;
          j++;
        }

        y -= widget.params.gridShapeParams.columnsSpaceV;
        // At this point:
        //    y = grid height
        //    wMax = grid width
        //    rowsWidth = list containing all the rows width
        //    it is now possible to center rows and center the grid in parent item
        n = 0;
        int dx;
        while (n < widget.items.length) {
          dx = ((wMax -
                      rowsWidth[(n / widget.params.gridShapeParams.columns)
                          .floor()]) /
                  2)
              .floor();
          ret[n] = Matrix4.identity()
            ..translate((itemPos[n].x + dx - wMax / 2) + newCenter.dx,
                (itemPos[n].y - y / 2) + newCenter.dy);
          n++;
        }
        break;
    }

    return ret;
  }

  // check if the items rect exceeds the screen. Move the item positions
  // to fit into the screen
  _checkBoundaries() {
    if (widget.params.checkItemsScreenBoundaries && itemsParams.isNotEmpty) {
      for (int i = 0; i < itemsParams.length; i++) {
        Rect shifted = itemsParams[i].rect.translate(
            itemsMatrix.elementAt(i).getTranslation().x -
                itemsParams[i].rect.width / 2,
            itemsMatrix.elementAt(i).getTranslation().y -
                itemsParams[i].rect.height / 2);

        if (shifted.left < 0) itemsMatrix.elementAt(i).translate(-shifted.left);
        if (shifted.right > screenSize.width)
          itemsMatrix.elementAt(i).translate(screenSize.width - shifted.right);
        if (shifted.top < topPadding)
          itemsMatrix.elementAt(i).translate(0.0, topPadding - shifted.top);
        if (shifted.bottom > screenSize.height)
          itemsMatrix
              .elementAt(i)
              .translate(0.0, screenSize.height - shifted.bottom);
      }
    }

    // check if the rect that include all the items on final position
    // exceeds the screen. Move all items position accordingly
    if (widget.params.checkMenuScreenBoundaries && itemsParams.isNotEmpty) {
      Rect boundaries = itemsParams[0].rect.translate(
          itemsMatrix.elementAt(0).getTranslation().x -
              itemsParams[0].rect.width / 2,
          itemsMatrix.elementAt(0).getTranslation().y -
              itemsParams[0].rect.height / 2);
      for (int i = 1; i < itemsParams.length; i++) {
        boundaries = boundaries.expandToInclude(itemsParams[i].rect.translate(
            itemsMatrix.elementAt(i).getTranslation().x -
                itemsParams[i].rect.width / 2,
            itemsMatrix.elementAt(i).getTranslation().y -
                itemsParams[i].rect.height / 2));
      }

      if (boundaries.top < topPadding)
        offsetToFitMenuIntoScreen = offsetToFitMenuIntoScreen.translate(
            0, -boundaries.top + topPadding);
      if (boundaries.bottom > screenSize.height)
        offsetToFitMenuIntoScreen = offsetToFitMenuIntoScreen.translate(
            0, screenSize.height - boundaries.bottom);
      if (boundaries.left < 0)
        offsetToFitMenuIntoScreen =
            offsetToFitMenuIntoScreen.translate(-boundaries.left, 0);
      if (boundaries.right > screenSize.width)
        offsetToFitMenuIntoScreen = offsetToFitMenuIntoScreen.translate(
            screenSize.width - boundaries.right, 0);
    }
  }
}
