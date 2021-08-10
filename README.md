# The StarMenu widget.
## Contextual popup menu with different shapes and multiple ways to fine-tune animation and position. The menu entries can be almost any kind of widgets.

![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/StarMenuDemo.gif)

Every widgets can now popup a menu on tap!
There are currently 3 shapes to choose:
* linear: items are lined by a given angle with a given space between them and with a 3-way alignment.
* circle: items are lined up in a circle shape with a given radius and a star-end angle.
* grid: items are aligned in a grid shape with N columns and a given horizontal and vertical shape.

Using the package is pretty simple:
* make your widget a child of StarMenu:

```dart
StarMenu(
  params: StarMenuParameters(),
    onItemTapped: (index, controller) {
      if (index == 7)
        controller.closeMenu();
    }
  ),
  items: entries,
  child: FloatingActionButton(
    onPressed: () {print('FloatingActionButton tapped');},
    child: Icon(Icons.looks_one),
  ),
)
```
* add the provided **addStarMenu()** Widget extension to your widget:

```dart
FloatingActionButton(
  onPressed: () {print('FloatingActionButton tapped');},
  child: Icon(Icons.looks_one),
).addStarMenu(context, entries, StarMenuParameters()),
```
where **`entries`** is a **`List<Widget>`** for the menu entries and **`StarMenuParameters()`** is defined as follow:

|Name|Type|Description|
|:-------|:----------|:-----------|
|shape|enum|Menu shape kind. Could be [MenuShape.circle], [MenuShape.linear], [MenuShape.grid].|
|linearShapeParams|class|See below.|
|circleShapeParams|class|See below.|
|gridShapeParams|class|See below.
|backgroundParams|class|See below.
|openDurationMs|int|Open animation duration.
|closeDurationMs|int|Close animation duration.
|rotateItemsAnimationAngle|double|Starting rotation angle of the items that will reach 0 DEG when animation ends.
|startItemScaleAnimation|double|Starting scale of the items that will reach 1 when animation ends.
|centerOffset|Offset|Shift offset of menu center from the center of parent widget.
|useScreenCenter|bool|Use the screen center instead of parent widget center.
|checkItemsScreenBoundaries|bool|Checks if the whole menu boundaries exceed screen edges, if so set it in place to be all visible.
|checkMenuScreenBoundaries|bool|Checks if items exceed screen edges, if so set them in place to be visible.
|animationCurve|Curve|Animation curve to use.
|onItemTapped|Function|The callback that is called when a menu item is tapped. It gives the `ID` of the item and a `controller` to eventually close the menu.

***LinearShapeParams***

|Name|Type|Description|
|:-------|:----------|:-----------|
|*angle*|double|Degree angle. Anticlockwise with 0° on the right.|
|*space*|double|Space between items.|
|*alignment*|LinearAlignment| *left*, *center*, *right*, *top*, *bottom*. Useful when the linear shape is vertical or horizontal.|

***CircleShapeParams***

|Name|Type|Description|
|:-------|:----------|:-----------|
|*radiusX*|double|Horizontal radius.|
|*radiusY*|double|Vertical radius.|
|*startAngle*|double|Starting angle for the 1st item. Anticlockwise with 0° on the right.|
|*endAngle*|double|Ending angle for the 1st item. Anticlockwise with 0° on the right.|

***GridShapeParams***

|Name|Type|Description|
|:-------|:----------|:-----------|
|*columns*|int|Number of columns.|
|*columnsSpaceH*|int|Horizontal space between items.| 
|*columnsSpaceV*|int|Vertical space between items.|

***BackgroundParams***

|Name|Type|Description|
|:-------|:----------|:-----------|
|*animatedBlur*|bool|Animate background blur from 0.0 to sigma if true.|
|*sigmaX*|double|Horizontal blur.|
|*sigmaY*|double|Vertical blur.|
|*animatedBackgroundColor*|bool|Animate [backgroundColor] from transparent if true.|
|*backgroundColor*|Color|Background color.| 