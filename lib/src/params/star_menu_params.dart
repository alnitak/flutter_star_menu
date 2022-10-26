import 'package:flutter/material.dart';

import '../star_menu.dart';
import 'background_params.dart';
import 'boundary_background.dart';
import 'circle_shape_params.dart';
import 'grid_shape_params.dart';
import 'linear_shape_params.dart';

/// class which is used to feed [StarMenu.params]
@immutable
class StarMenuParameters {
  /// Menu shape kind: [MenuShape.circle], [MenuShape.linear], [MenuShape.grid]
  final MenuShape shape;

  /// put a background behind all the items boundary
  final BoundaryBackground? boundaryBackground;

  /// parameters for the linear shape
  final linearShapeParams;

  /// parameters for the circle shape
  final CircleShapeParams circleShapeParams;

  /// parameters for the grid shape
  final GridShapeParams gridShapeParams;

  /// parameters for the background
  final BackgroundParams backgroundParams;

  /// Use long press behavior instead of a tap to open the menu
  final bool useLongPress;

  /// scale item when mouse is hover (desktop only)
  final double onHoverScale;

  /// long press duration
  final Duration longPressDuration;

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

  /// Use the touch coordinate as the menu center
  final bool useTouchAsCenter;

  /// Checks if the whole menu boundaries exceed screen edges, if so set it in place to be all visible
  final bool checkItemsScreenBoundaries;

  /// Checks if items exceed screen edges, if so set them in place to be visible
  final bool checkMenuScreenBoundaries;

  /// Animation curve kind to use
  final Curve animationCurve;

  const StarMenuParameters({
    this.linearShapeParams = const LinearShapeParams(),
    this.circleShapeParams = const CircleShapeParams(),
    this.gridShapeParams = const GridShapeParams(),
    this.backgroundParams = const BackgroundParams(),
    this.shape = MenuShape.circle,
    this.boundaryBackground,
    this.useLongPress = false,
    this.longPressDuration = const Duration(milliseconds: 500),
    this.onHoverScale = 1.0,
    this.openDurationMs = 400,
    this.closeDurationMs = 150,
    this.rotateItemsAnimationAngle = 0.0,
    this.startItemScaleAnimation = 1.0,
    this.centerOffset = Offset.zero,
    this.useScreenCenter = false,
    this.useTouchAsCenter = false,
    this.checkItemsScreenBoundaries = false,
    this.checkMenuScreenBoundaries = true,
    this.animationCurve = Curves.fastOutSlowIn,
  });

  StarMenuParameters copyWith({
    MenuShape? shape,
    BoundaryBackground? boundaryBackground,
    LinearShapeParams? linearShapeParams,
    CircleShapeParams? circleShapeParams,
    GridShapeParams? gridShapeParams,
    BackgroundParams? backgroundParams,
    bool? useLongPress,
    double? onHoverScale,
    Duration? longPressDuration,
    int? openDurationMs,
    int? closeDurationMs,
    double? rotateItemsAnimationAngle,
    double? startItemScaleAnimation,
    Offset? centerOffset,
    bool? useScreenCenter,
    bool? useTouchAsCenter,
    bool? checkItemsScreenBoundaries,
    bool? checkMenuScreenBoundaries,
    Curve? animationCurve,
  }) {
    return StarMenuParameters(
      shape: shape ?? this.shape,
      boundaryBackground: boundaryBackground ?? this.boundaryBackground,
      linearShapeParams: linearShapeParams ?? this.linearShapeParams,
      circleShapeParams: circleShapeParams ?? this.circleShapeParams,
      gridShapeParams: gridShapeParams ?? this.gridShapeParams,
      backgroundParams: backgroundParams ?? this.backgroundParams,
      useLongPress: useLongPress ?? this.useLongPress,
      onHoverScale: onHoverScale ?? this.onHoverScale,
      longPressDuration: longPressDuration ?? this.longPressDuration,
      openDurationMs: openDurationMs ?? this.openDurationMs,
      closeDurationMs: closeDurationMs ?? this.closeDurationMs,
      rotateItemsAnimationAngle:
          rotateItemsAnimationAngle ?? this.rotateItemsAnimationAngle,
      startItemScaleAnimation:
          startItemScaleAnimation ?? this.startItemScaleAnimation,
      centerOffset: centerOffset ?? this.centerOffset,
      useScreenCenter: useScreenCenter ?? this.useScreenCenter,
      useTouchAsCenter: useTouchAsCenter ?? this.useTouchAsCenter,
      checkItemsScreenBoundaries:
          checkItemsScreenBoundaries ?? this.checkItemsScreenBoundaries,
      checkMenuScreenBoundaries:
          checkMenuScreenBoundaries ?? this.checkMenuScreenBoundaries,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  /// preset to display a dropdown menu like
  factory StarMenuParameters.dropdown(BuildContext context) {
    return StarMenuParameters(
      shape: MenuShape.linear,
      centerOffset: Offset(-80, 25),
      openDurationMs: 200,
      closeDurationMs: 60,
      startItemScaleAnimation: 1.0,
      linearShapeParams: LinearShapeParams(
        space: 16,
        angle: 270,
      ),
      backgroundParams: BackgroundParams(
        backgroundColor: Colors.transparent,
      ),
      boundaryBackground: BoundaryBackground(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).popupMenuTheme.color ??
              Theme.of(context).cardColor,
          boxShadow: kElevationToShadow[6],
        ),
      ),
    );
  }

  /// preset to display items in an arc shape
  factory StarMenuParameters.arc(
    BuildContext context,
    ArcType type, {
    double radiusX = 130,
    double radiusY = 130,
  }) {
    double start = 0;
    double end = 0;
    switch (type) {
      case ArcType.semiUp:
        start = 0.0;
        end = 180.0;
        break;
      case ArcType.semiDown:
        start = 180.0;
        end = 360.0;
        break;
      case ArcType.semiLeft:
        start = 90.0;
        end = 270.0;
        break;
      case ArcType.semiRight:
        start = -90.0;
        end = 90.0;
        break;
      case ArcType.quarterTopRight:
        start = 0.0;
        end = 90.0;
        break;
      case ArcType.quarterTopLeft:
        start = 90.0;
        end = 180.0;
        break;
      case ArcType.quarterBottomRight:
        start = 270.0;
        end = 360.0;
        break;
      case ArcType.quarterBottomLeft:
        start = 180.0;
        end = 270.0;
        break;
    }
    return StarMenuParameters(
      shape: MenuShape.circle,
      circleShapeParams: CircleShapeParams(
        startAngle: start,
        endAngle: end,
        radiusX: radiusX,
        radiusY: radiusY,
      ),
      backgroundParams: BackgroundParams(
        backgroundColor: Colors.transparent,
      ),
      onHoverScale: 1.5,
    );
  }

  /// preset to display a grid menu inscribed into a card
  factory StarMenuParameters.panel(BuildContext context, {int columns = 3}) {
    return StarMenuParameters(
      shape: MenuShape.grid,
      onHoverScale: 1.3,
      gridShapeParams: GridShapeParams(
        columns: columns,
        columnsSpaceV: 20,
        columnsSpaceH: 40,
      ),
      backgroundParams: BackgroundParams(
        backgroundColor: Colors.transparent,
      ),
      boundaryBackground: BoundaryBackground(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
          boxShadow: kElevationToShadow[6],
        ),
      ),
    );
  }
}
