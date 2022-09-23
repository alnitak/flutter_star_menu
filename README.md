<h1 align="center"> 
StarMenu<br>
Easy and Fast Way to build Context Menus
</h1>


[![Pub Version](https://img.shields.io/pub/v/star_menu?style=flat-square&logo=dart)](https://pub.dev/packages/star_menu)
![Pub Likes](https://img.shields.io/pub/likes/star_menu)
![Pub Likes](https://img.shields.io/pub/points/star_menu)
![Pub Likes](https://img.shields.io/pub/popularity/star_menu)
![GitHub repo size](https://img.shields.io/github/repo-size/alnitak/flutter_star_menu?style=flat-square)
![GitHub forks](https://img.shields.io/github/forks/alnitak/flutter_star_menu?style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/alnitak/flutter_star_menu?style=flat-square)
![GitHub license](https://img.shields.io/github/license/alnitak/flutter_star_menu?style=flat-square)

A simple way to attach a popup menu to any widget with any widget as menu entries. 
Menu entry widgets can bind a sub-menu with different shapes. 
Multiple ways to fine-tune animation and position.

<img src="https://github.com/alnitak/flutter_star_menu/blob/master/images/StarMenuDemo2.gif" height="350"> <img src="https://github.com/alnitak/flutter_star_menu/blob/master/images/StarMenuDemo.gif" height="350">

Every widgets can be tapped to display a popup menu!
There are currently 3 shapes to choose:

- `linear`: items are lined by a given angle with a given space between them and with a 3-way alignment.
- `circle`: items are lined up in a circle shape with a given radius and a star-end angle.
- `grid`: items are aligned in a grid shape with N columns and a given horizontal and vertical space.

|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/linear.png)|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/circle.png)|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/panel.png)|
|:--|:--|:--|
|*linear*|*circle*|*panel*|

Using the package is pretty simple:

- feed the `items` parameter with the menu entry widgets list
- set the `params` with `StarMenuParameters`
- set the `child` with a widget you like to press to open the menu

```dart
StarMenu(
  params: StarMenuParameters(),
  onStateChanged: (state) => print('State changed: $state'),
  onItemTapped: (index, controller) {
    // here you can programmatically close the menu
    if (index == 7)
      controller.closeMenu();
	print('Menu item $index tapped');
  }),
  items: entries,
  child: FloatingActionButton(
    onPressed: () {print('FloatingActionButton tapped');},
    child: Icon(Icons.looks_one),
  ),
)
```
- `onStateChanged` triggers menu state canges: 

```
enum MenuState {
  closed,
  closing,
  opening,
  open,
}
```

- `items` parameter is used when entries are known. 
If you want to build items in runtime use `lazyItems`, 
ie when StarMenu is already builded in the widget tree, but the menu items changed:

```dart
StarMenu(
  ...
  lazyItems: () async{
      return [
        Container(
          color: Color.fromARGB(255, Random().nextInt(255),
              Random().nextInt(255), Random().nextInt(255)),
          width: 60,
          height: 40,
          child: Text(userName),
        ),
        ...
      ];
  }
)
```
`lazyItems` is a callback function which returns `Future<List<Widget>>` which is called before opening the menu.
Only `lazyItems` or `items` can be used. 

*StarMenu* can be created also with **addStarMenu()** widget extension:

```dart
FloatingActionButton(
  onPressed: () {print('FloatingActionButton tapped');},
  child: Icon(Icons.looks_one),
).addStarMenu(
	context, 
	entries, 
	StarMenuParameters(), 
	onItemTapped: (index, controller) {}),
```

### StarMenuParameters

Class to define all the parameters for the shape, animation and menu behavior.

|Name|Type|Defaults|Description|
|:-------|:----------|:----------|:-----------|
|*shape*|enum|MenuShape.circle|Menu shape kind. Could be [MenuShape.circle], [MenuShape.linear], [MenuShape.grid].|
|*boundaryBackground*|class|-|See below.|
|*linearShapeParams*|class|-|See below.|
|*circleShapeParams*|class|-|See below.|
|*gridShapeParams*|class|-|See below.|
|*backgroundParams*|class|-|See below.|
|*openDurationMs*|int|400|Open animation duration ms.|
|*closeDurationMs*|int|150|Close animation duration ms.|
|*rotateItemsAnimationAngle*|double|0.0|Starting rotation angle of the items that will reach 0 DEG when animation ends.|
|*startItemScaleAnimation*|double|0.3|Starting scale of the items that will reach 1 when animation ends.|
|*centerOffset*|Offset|Offset.zero|Shift offset of menu center from the center of parent widget.|
|*useScreenCenter*|bool|false|Use the screen center instead of parent widget center.|
|*checkItemsScreenBoundaries*|bool|false|Checks if the whole menu boundaries exceed screen edges, if so set it in place to be all visible.|
|*checkMenuScreenBoundaries*|bool|true|Checks if items exceed screen edges, if so set them in place to be visible.|
|*animationCurve*|Curve|Curves.fastOutSlowIn|Animation curve kind to use.|
|*useLongPress*|bool|false|Use long press instead of a tap to open the menu.|
|*longPressDuration*|Duration|500 ms|The timing to trigger long press.|
|*onHoverScale*|double|1.0|Scale item when mouse is hover (desktop only)|

There are some ***StarMenuParameters*** factory presets with which you can set *StarMenu.params*

|||
|:-------|:----------|
|*StarMenuParameters.dropdown(BuildContext context)*|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/dropdown.png)|
|*StarMenuParameters.panel(BuildContext context, {int columns = 3})*|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/panel.png)|

*StarMenuParameters.arc(BuildContext context, ArcType type, {double radiusX = 130, double radiusY = 130})*

|type|result|
|:-------|:----------|
|ArcType.semiUp|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/semiUp.png)|
|ArcType.semiDown|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/semiDown.png)|
|ArcType.semiLeft|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/semiL.png)|
|ArcType.semiRight|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/semiR.png)|
|ArcType.quarterTopRight|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/quarterTopR.png)|
|ArcType.quarterTopLeft|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/quarterTopL.png)|
|ArcType.quarterBottomRight|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/quarterBottomR.png)|
|ArcType.quarterBottomLeft|![Image](https://github.com/alnitak/flutter_star_menu/blob/master/images/quarterBottomL.png)|



---

### BoundaryBackground

|Name|Type|Defaults|Description|
|:-------|:----------|:----------|:-----------|
|*color*|Color|0x80000000|color of the boundary background.|
|*padding*|EdgeInsets|EdgeInsets.all(8.0)|Padding of the boundary background.|
|*decoration*|Decoration|BorderRadius.circular(8)| background Container widget decoration.|

---

### LinearShapeParams

|Name|Type|Defaults|Description|
|:-------|:----------|:----------|:-----------|
|*angle*|double|90.0|Degree angle. Anticlockwise with 0° on 3 o'clock.|
|*space*|double|0.0|Space between items.|
|*alignment*|LinearAlignment|center| *left*, *center*, *right*, *top*, *bottom*. Useful when the linear shape is vertical or horizontal.|

---

### CircleShapeParams

|Name|Type|Defaults|Description|
|:-------|:----------|:----------|:-----------|
|*radiusX*|double|100.0|Horizontal radius.|
|*radiusY*|double|100.0|Vertical radius.|
|*startAngle*|double|0.0|Starting angle for the 1st item. Anticlockwise with 0° on the right.|
|*endAngle*|double|360.0|Ending angle for the 1st item. Anticlockwise with 0° on the right.|

---

### GridShapeParams

|Name|Type|Defaults|Description|
|:-------|:----------|:----------|:-----------|
|*columns*|int|3|Number of columns.|
|*columnsSpaceH*|int|0|Horizontal space between items.| 
|*columnsSpaceV*|int|0|Vertical space between items.|

---

### BackgroundParams

|Name|Type|Defaults|Description|
|:-------|:----------|:----------|:-----------|
|*animatedBlur*|bool|false|Animate background blur from 0.0 to sigma if true.|
|*sigmaX*|double|0.0|Horizontal blur.|
|*sigmaY*|double|0.0|Vertical blur.|
|*animatedBackgroundColor*|bool|false|Animate [backgroundColor] from transparent if true.|
|*backgroundColor*|Color|#80000000|Background color.| 
