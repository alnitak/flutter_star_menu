library star_menu;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:star_menu/src/star_item.dart';

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

/// Controller for StarMenu class.
///
/// Create the overlay based on the [parentKey] context.
/// Call [StarMenuController.displayStarMenu] with the [starMenu] widget and
/// its [parentKey] widget object which is used also to calculate the menu center position.
///
///
/// '''
/// GlobalKey menuFabKey = GlobalKey();
/// FloatingActionButton(
///          key: menuFabKey,
///          backgroundColor: Colors.lightBlueAccent,
///          child: Icon(Icons.menu),
///          onPressed: () {
///            StarMenuController.displayStarMenu(_buildStarMenu(menuFabKey), menuFabKey);
///          },
///        )
/// '''
///
GlobalKey? _overlayKey;
class StarMenuController {
  static List<OverlayEntry> _overlayEntry = [];

  static late double screenWidth;
  static late double screenHeight;



  // Build the StarMenu on an overlay
  static displayStarMenu(StarMenu starMenu, GlobalKey parentKey) async{
    // Retrieve the parent Overlay
    OverlayState _overlayState = Overlay.of(starMenu.parentKey.currentContext!)!;

    // Generate the Stack containing all StarItems that will be displayed onto the Overlay
    _overlayEntry.add(OverlayEntry(
      builder: (BuildContext context) {
        screenWidth = MediaQuery.of(context).size.width;
        screenHeight = MediaQuery.of(context).size.height;

        _overlayKey = new GlobalKey();

        return RepaintBoundary(
          key: _overlayKey,
          child: Stack(
            children: <Widget>[
              starMenu,
            ],
          ),
        );
      },
    ));

    // Add it to the Overlay
    _overlayState.insert(_overlayEntry.last);
  }

  // Used internally to close the last visible StarMenu
  static removeLast() {
    _overlayEntry.last.remove();
    _overlayEntry.removeLast();
  }
}

/// # The StarMenu widget.
///
/// ## Contextual popup menu with different shapes and multiple ways to fine-tune animation
/// and position. The menu entries can be almost any kind of widgets.
///
/// * [parentKey] GlobalKey of the parent widget. Needed to retrieve its position.
/// * [items] List of menu widget items.
/// * [radiusX] Horizontal radius of circle shape.
/// * [radiusY] Vertical radius of circle shape.
/// * [radiusIncrement] Menu items spacing of linear shape.
/// * [startAngle] Starting degree angle in circle shape and angle of the linear shape.
/// * [endAngle] Ending degree angle in circle shape.
/// * [columns] Number of columns in grid shape.
/// * [columnsSpaceH] Horizontal space between columns in grid shape.
/// * [columnsSpaceV] Vertical space between rows in grid shape.
/// * [shape] Menu shape kind. Could be [MenuShape.circle], [MenuShape.linear], [MenuShape.grid].
/// * [durationMs] Duration of the items animation.
/// * [itemDelayMs] Items animation delay. The first item starts at 0, the second starts after
///                 [itemDelayMs]*1, the third after [itemDelayMs]*2 and so on. Every items animation
///                 take [durationMs] ms, but the whole animation will take durationMs+(N items -1)*itemDelayMs ms
/// * [rotateItemsAnimationAngle] Start rotation angle of the animation to reach 0 DEG when animation ends.
/// * [startItemScaleAnimation] Start scale of the animation to reach 1.0 when animation ends.
/// * [backgroundColor] Color of screen background.
/// * [centerOffset] Shift offset of menu center.
/// * [useScreenCenter] Use the screen center instead of [parentKey] center.
/// * [checkScreenBoundaries] Checks if items exceed screen edges, if so set them in place to be visible.
/// * [animationCurve] Animation curve to use.
/// * [onItemPressed] The callback that is called when the widget item is tapped.
///                   If the widget has its own tap event, this callback is not delivered.
///                   See the below code example to see how to manually close the menu.
///
///
/// ```dart
/// // Optional for an use case like the FloatingActionButton widget below
/// GlobalKey starMenuKey = GlobalKey();
///
/// // Optional for an use case like the Checkbox widget below
/// var _value = ValueNotifier<bool>(false);
///
/// Widget _buildStarMenu(GlobalKey parent) {
/// return StarMenu(
///      key: starMenuKey,  // used to close the menu in the case a button has the onTap event
///      parentKey: parent,
///      shape: MenuShape.circle,
///      radiusX: 100,
///      radiusY: 150,
///      durationMs: 400,
///      itemDelayMs: 80,
///      backgroundColor: Color.fromARGB(180, 0, 0, 0),
///      animationCurve: Curves.easeIn,
///      onItemPressed: (i) => {print("Item pressed: $i")},
///      items: <Widget>[
///        FloatingActionButton(
///          backgroundColor: Colors.red,
///          child: Icon(Icons.beach_access),
///          onPressed: () {
///            // This widget has the onPressed event and StarMenu doesn't grab its [onItemPressed].
///            // If you want to manually close this menu, assign a
///            // GlobalKey to it and do the following:
///            StarMenuState sms = starMenuKey.currentState;
///            sms.close();
///          },
///        ),
///        Material(
///          color: Colors.yellow,
///          child: ValueListenableBuilder(
///            // Since StarMenu is built on an overlay, it has a different context and
///            // its [value] property should be binded to a Listenable to be updated.
///            // The same happens for example to the [Switch] widget and others widgets
///            // that need to be updated.
///            valueListenable: _value,
///            builder: (context, value, child) {
///              return Checkbox(
///                value: _value.value,
///                onChanged: (bool b) {
///                  setState( () => _value.value = b );
///                },
///              );
///            }
///          ),
///        ),
///        [...] // other Widgets menu entries
///      ],
///    );
/// }
/// ```
///
/// Then call _buildStarMenu() for example when the user tap on a widget:
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    fabKey = GlobalKey();
///
///    return Scaffold(
///      appBar: AppBar(
///        title: Text(widget.title),
///      ),
///      body: Stack(
///        children: <Widget>[
///          FloatingActionButton(
///              key: fabKey,
///              backgroundColor: Colors.amberAccent,
///              foregroundColor: Colors.black,
///              child: Icon(Icons.ac_unit),
///              onPressed: () {
///                StarMenuController.displayStarMenu(_buildMenu(fabKey), fabKey);
///              },
///          ),
///        ],
///      ),
///    );
///  }
/// ```
///
class StarMenu extends StatefulWidget {
  final List<Widget> items;
  // GlobalKey of the parent. Needed to retrieve its parameters (size and position)
  final GlobalKey parentKey;
  final double radiusX;
  final double radiusY;
  final double radiusIncrement;
  final double startAngle;
  final double endAngle;
  final int columns;
  final int columnsSpaceH;
  final int columnsSpaceV;
  final MenuShape shape;
  final int durationMs;
  final int itemDelayMs;
  final double rotateItemsAnimationAngle;
  final double startItemScaleAnimation;
  final Color backgroundColor;
  final Offset centerOffset;
  final bool useScreenCenter;
  final bool checkScreenBoundaries;
  final bool useBlur;
  final Curve animationCurve;
  final void Function(int)? onItemPressed;

  StarMenu({
    key,
    required this.parentKey,
    required this.items,
    this.radiusX = 100,
    this.radiusY = 100,
    this.radiusIncrement = 0,
    this.startAngle = 0,
    this.endAngle = 360,
    this.columns = 3,
    this.columnsSpaceH = 0,
    this.columnsSpaceV = 0,
    this.shape = MenuShape.circle,
    this.durationMs = 400,
    this.itemDelayMs = 50,
    this.rotateItemsAnimationAngle = 180.0,
    this.startItemScaleAnimation = 0.52,
    this.backgroundColor = const Color.fromARGB(180, 0, 0, 0),
    this.centerOffset = const Offset(0, 0),
    this.useScreenCenter = false,
    this.checkScreenBoundaries = false,
    this.useBlur = true,
    this.animationCurve = Curves.fastOutSlowIn,
    this.onItemPressed,
  })  : assert(parentKey != null),
        assert(items != null),
        assert(columns >= 1),
        assert(durationMs > 0),
        assert(itemDelayMs > 0),
        super(key: key);

  @override
  StarMenuState createState() => StarMenuState();
}

class StarMenuState extends State<StarMenu>
    with SingleTickerProviderStateMixin {
  late double startAngleRAD;
  late double endAngleRAD;
  late double rotateItemsAnimationAngleRAD;
  WidgetParams? _parentParams;
  List<Widget>? _starItems;
  late List<GlobalKey> _starItemsKeys;
  late List<WidgetParams?> _starItemsParams;
  Uint8List? _backgroundImage = null;
  MenuState? state;
  late int _nItems;
  late Matrix4 _itemMatrix;
  // used to take track of the current radius and size when calculating linear shape
  double radius = 0.0;
  // used to store items position for grid shape
  List<Point> itemPos = [];

  AnimationController? _controller;
  List<Animation<double>> _animation = [];
  late Animation<double> _animationPercent;
  late Animation<Color?> animationColor;

  Future<Uint8List> takeScreenShot(GlobalKey widgetKey) async{
    print("TAKESCREENSHOT  ${widgetKey.currentContext}");
    RenderRepaintBoundary boundary = widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData>);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    return pngBytes;
  }
  Future<Uint8List?> _capturePng(GlobalKey widgetKey) async {
    try {
      print('CAPTURE1    $widgetKey');
      RenderRepaintBoundary boundary = widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      print('CAPTURE2    $boundary');
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      print('CAPTURE3    ${image.width} x ${image.height}');
      ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData>);
      print('CAPTURE4');
      var pngBytes = byteData.buffer.asUint8List();
      print('CAPTURE5');
      var bs64 = base64Encode(pngBytes);
      print('CAPTURE6');
//      print(bs64);
      print('CAPTURE7 $pngBytes');
//      widgetKey.currentState.setState(() {});
      setState(() {
        _backgroundImage = pngBytes;
        print("********BACKGROUNDIMAGE:  $_backgroundImage");
      });
      print('CAPTURE8');
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }


  @override
  void initState() {
    super.initState();
    startAngleRAD = vector.radians(widget.startAngle);
    endAngleRAD = vector.radians(widget.endAngle);
    rotateItemsAnimationAngleRAD =
        vector.radians(widget.rotateItemsAnimationAngle);
    _parentParams = WidgetParams.fromContext(widget.parentKey.currentContext!);
    _nItems = widget.items.length;
    _itemMatrix = Matrix4.identity();
    _starItemsParams = []..length = widget.items.length;

    // duration of the whole animation including each items' delay
    int totalDuration = widget.durationMs + widget.itemDelayMs * (_nItems - 1);
    // percentage of delay
    double d = widget.itemDelayMs / totalDuration;
    // percentage of duration
    double d1 = widget.durationMs / totalDuration;

    _controller = AnimationController(
      duration: Duration(milliseconds: totalDuration),
      vsync: this,
    );

    animationColor = ColorTween(
      begin: Colors.transparent,
      end: widget.backgroundColor,
    ).animate(_controller!);

    _animationPercent = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn))
      ..addListener(() {
        if (widget.shape == MenuShape.grid) {
          _calcGrid();
        }
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            if (state == MenuState.closing) StarMenuController.removeLast();
            state = MenuState.closing;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
        }
      });

    for (int i = 0; i < _nItems; i++) {
      double start = d * i;
      double end = d * i + d1;
      if (end > 1.0) end = 1.0;
      _animation.add(Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _controller!,
          curve: Interval(start, end, curve: widget.animationCurve)))
        ..addListener(() {
          setState(() {
            _starItemsParams[i] =
                WidgetParams.fromContext(_starItemsKeys[i].currentContext!);
          });
        }));
    }

    _controller!.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  close() {
    _controller?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // with grid shape and with a durationMs less then ~50 ms, happens that itemPos
    // are not already calculated when animation ends
    if (itemPos.isEmpty && _animationPercent.value == 1.0) {
      _calcGrid();
    }
//    if (_backgroundImage == null) {
//      final result = _capturePng(_overlayKey);
////      Future.wait([_capturePng(_overlayKey)]);
//      result.then((result) {});
//    }

//    final _background =
//    Container(
//      color: Colors.green.withAlpha(100),
//      child: Image(image: MemoryImage(
//          _backgroundImage == null ? Uint8List(1): _backgroundImage,
//          scale: 0.5),)
//    );

    List<Widget> _items = [];//[_background];
    _items.addAll(_setItemPosition()!);

    return GestureDetector(
      onTap: () {
        _controller!.reverse();
      },
      child: (widget.useBlur)
          ? BackdropFilter(
              filter: ui.ImageFilter.blur(
                  sigmaY: _animationPercent.value * 3,
                  sigmaX: _animationPercent.value * 3),
              child: _buildBody(_items),
            )
          : _buildBody(_items),
    );
  }

  Widget _buildBody(List<Widget> items) {
    return Container(
      color: animationColor.value,
      alignment: Alignment.center,
      child: Stack(
        children: items,
      ),
    );
  }

  List<Widget>? _setItemPosition() {
    _starItemsKeys =
        List<GlobalKey>.generate(widget.items.length, (i) => (GlobalKey()));
    _starItems = List<Widget>.generate(
        widget.items.length,
        (i) => (StarItem(
              key: _starItemsKeys[i],
              animationValue: _animation[i].value,
              item: widget.items.elementAt(i),
              anchor: (widget.useScreenCenter || _parentParams == null
                  ? Offset(StarMenuController.screenWidth / 2,
                      StarMenuController.screenHeight / 2)
                  : _parentParams!.rect!.center),
              itemMatrix: _calcPosition(i),
              onItemPressed: () {
                if (widget.onItemPressed != null) widget.onItemPressed!(i);
                close();
              },
            )));
    return _starItems;
  }

  Matrix4 _calcPosition(int index) {
    double A = _animation[index].value;

    vector.Vector3 T = _itemMatrix.getTranslation();
    switch (widget.shape) {
      // CIRCLE SHAPE
      case MenuShape.circle:
        T.x = cos(endAngleRAD / widget.items.length * index + startAngleRAD) *
                widget.radiusX *
                A +
            widget.centerOffset.dx;
        T.y = -sin(endAngleRAD / widget.items.length * index + startAngleRAD) *
                widget.radiusY *
                A +
            widget.centerOffset.dy;
        break;

      // LINEAR SHAPE
      case MenuShape.linear:
        if (_starItemsParams[index] == null) break;
        double rotate = startAngleRAD;
        double itemDiameter = 0.0;
        double firstItemHalfWidth = 0.0;
        double firstItemHalfHeight = 0.0;
        double halfWidth;
        double halfHeight;
        double secH;
        double secV;

        halfWidth = _starItemsParams[index]!.rect!.width / 2;
        halfHeight = _starItemsParams[index]!.rect!.height / 2;

        // itemDiameter is calculated by the segment length that intersect the item bounding box
        // passing through the center of the item and intersect the opposite edges by m_startingAngle angle
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
          radius = -itemDiameter / 2;
        }

        T.x =
            cos(startAngleRAD) * (radius + halfWidth - firstItemHalfWidth) * A +
                widget.centerOffset.dx;
        T.y = -sin(startAngleRAD) *
                (radius + halfHeight - firstItemHalfHeight) *
                A +
            widget.centerOffset.dy;

        if (index == 0) {
          firstItemHalfWidth = halfWidth;
          firstItemHalfHeight = halfHeight;
        }

        radius += itemDiameter + widget.radiusIncrement;

        break;

      // GRID SHAPE
      case MenuShape.grid:
        if (itemPos.isEmpty) break;
        T.x = itemPos[index].x * A;
        T.y = itemPos[index].y * A;
        break;
    }

    // Check boundaries
    if (widget.checkScreenBoundaries && _starItemsParams[index] != null) {
      if (_starItemsParams[index]!.rect!.right + T.x >
          StarMenuController.screenWidth)
        T.x = (StarMenuController.screenWidth -
                (_starItemsParams[index]!.rect!.width / 2)) -
            _parentParams!.rect!.center.dx;
      if (_starItemsParams[index]!.rect!.bottom + T.y >
          StarMenuController.screenHeight)
        T.y = (StarMenuController.screenHeight -
                (_starItemsParams[index]!.rect!.height / 2)) -
            _parentParams!.rect!.bottom;
    }

    return Matrix4.identity()
      ..setTranslation(T)
      ..setRotationZ((1.0 - A) * rotateItemsAnimationAngleRAD)
      ..scale(A + (widget.startItemScaleAnimation * (1.0 - A)));
  }

  // Calculate items position in grid shape. It's called only once when animation starts
  _calcGrid() {
    // return if positions are already computed
    if (itemPos.isNotEmpty) return;

    // Check if all items params are been taken
    for (int i = 0; i < widget.items.length; i++) {
      if (_starItemsParams[i] == null) return;
    }

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

    // Calculating the grid
    while (j * widget.columns + k < widget.items.length) {
      count = 0;
      hMax = 0;
      x = 0;
      // Calculate x position and rows height
      while (
          k < widget.columns && j * widget.columns + k < widget.items.length) {
        itemWidth = _starItemsParams[j * widget.columns + k]!.rect!.width;
        itemHeight = _starItemsParams[j * widget.columns + k]!.rect!.height;
        itemPos.add(Point(x + itemWidth / 2, y));
        // hMax = max item height in this row
        hMax = max(hMax, itemHeight);
        x += itemWidth + widget.columnsSpaceH;
        count++;
        k++;
      }
      // wMax = max width of all rows
      wMax = max(wMax, x);
      rowsWidth.add(x - widget.columnsSpaceH);
      // Calculate y position for items in current row
      for (int i = 0; i < count; i++) {
        itemHeight =
            _starItemsParams[j * widget.columns + k - i - 1]!.rect!.height;
        double x1 = itemPos[itemPos.length - i - 1].x as double;
        double y1 = y + hMax / 2;
        itemPos[itemPos.length - i - 1] = Point(x1, y1);
      }
      y += hMax + widget.columnsSpaceV;
      k = 0;
      j++;
    }
    y -= widget.columnsSpaceV;
    // At this point:
    //    y = grid height
    //    wMax = grid width
    //    rowsWidth = list containing all the rows width
    //    so it's possible to center rows and center the grid in parent item
    n = 0;
    int dx;
    while (n < widget.items.length) {
      dx = ((wMax - rowsWidth[(n / widget.columns).floor()]) / 2).floor();
      itemPos[n] = Point(
          (itemPos[n].x + dx - wMax / 2) + widget.centerOffset.dx,
          (itemPos[n].y - y / 2) + widget.centerOffset.dy);
      n++;
    }
  }
}
