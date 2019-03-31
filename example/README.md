# The StarMenu widget.
## Contextual popup menu with different shapes and multiple ways to fine-tune animation and position. The menu entries can be almost any kind of widgets.

![Alt text](https://bitbucket.org/lildeimos/flutterstarmenu/raw/master/images/StarMenuDemo.gif "StarMenu Demo")

* [**parentKey**] GlobalKey of the parent widget. Needed to retrieve its position.
* [**items**] List of menu widget items.
* [**radiusX**] Horizontal radius of circle shape.
* [**radiusY**] Vertical radius of circle shape.
* [**radiusIncrement**] Menu items spacing of linear shape.
* [**startAngle**] Starting degree angle in circle shape and angle of the linear shape.
* [**endAngle**] Ending degree angle in circle shape.
* [**columns**] Number of columns in grid shape.
* [**columnsSpaceH**] Horizontal space between columns in grid shape.
* [**columnsSpaceV**] Vertical space between rows in grid shape.
* [**shape**] Menu shape kind. Could be [MenuShape.circle], [MenuShape.linear], [MenuShape.grid].
* [**durationMs**] Duration of the items animation.
* [**itemDelayMs**] Items animation delay. The first item starts at 0, the second starts after
                [itemDelayMs]\*1, the third after [itemDelayMs]\*2 and so on. Every items animation
                take [durationMs] ms, but the whole animation will take durationMs+(N items -1)\*itemDelayMs ms
* [**rotateItemsAnimationAngle**] Start rotation angle of the animation to reach 0 DEG when animation ends.
* [**startItemScaleAnimation**] Start scale of the animation to reach 1.0 when animation ends.
* [**backgroundColor**] Color of screen background.
* [**centerOffset**] Shift offset of menu center.
* [**useScreenCenter**] Use the screen center instead of [parentKey] center.
* [**checkScreenBoundaries**] Checks if items exceed screen edges, if so set them in place to be visible.
* [**animationCurve**] Animation curve to use.
* [**onItemPressed**] The callback that is called when the widget item is tapped.
                  If the widget has its own tap event, this callback is not delivered.
                  See the below code example to see how to manually close the menu.

### Import the StarMenu package
To use the StarMenu plugin, follow the [plugin installation instructions](https://pub.dartlang.org/packages/star_menu#pub-pkg-tab-installing).

### Use the package

Add the following import to your Dart code:
```dart
import 'package:star_menu/star_menu.dart';
```

We can now use a function to build StarMenu widget and open it within an user event with the _StarMenuController.displayStarMenu()_ method.


```dart
// Optional for an use case like the FloatingActionButton widget below
GlobalKey starMenuKey = GlobalKey();
// Optional for an use case like the Checkbox widget below
var _value = ValueNotifier<bool>(false);
Widget _buildStarMenu(GlobalKey parent) {
return StarMenu(
     key: starMenuKey,  // used to close the menu in the case a widget has the onTap event
     parentKey: parent,
     shape: MenuShape.circle,
     radiusX: 100,
     radiusY: 150,
     durationMs: 400,
     itemDelayMs: 80,
     backgroundColor: Color.fromARGB(180, 0, 0, 0),
     animationCurve: Curves.easeIn,
     onItemPressed: (i) => {print("Item pressed: $i")},
     items: <Widget>[
       FloatingActionButton(
         backgroundColor: Colors.red,
         child: Icon(Icons.beach_access),
         onPressed: () {
           // This widget has the onPressed event and StarMenu doesn't grab its [onItemPressed].
           // If you want to manually close this menu, assign a
           // GlobalKey to it and do the following:
           StarMenuState sms = starMenuKey.currentState;
           sms.close();
         },
       ),
       Material(
         color: Colors.yellow,
         child: ValueListenableBuilder(
           // Since StarMenu is built on an overlay, it has a different context and
           // its [value] property should be binded to a Listenable to be updated.
           // The same happens for example to the [Switch] widget and others widgets
           // that need to be updated.
           valueListenable: _value,
           builder: (context, value, child) {
             return Checkbox(
               value: _value.value,
               onChanged: (bool b) {
                 setState( () => _value.value = b );
               },
             );
           }
         ),
       ),
       [...] // other Widgets menu entries
     ],
   );
}
```

Then call _buildStarMenu() for example when the user tap on a widget:

```dart
 @override
 Widget build(BuildContext context) {
   fabKey = GlobalKey();
   return Scaffold(
     appBar: AppBar(
       title: Text(widget.title),
     ),
     body: Stack(
       children: <Widget>[
         FloatingActionButton(
             key: fabKey,
             backgroundColor: Colors.amberAccent,
             foregroundColor: Colors.black,
             child: Icon(Icons.ac_unit),
             onPressed: () {
               StarMenuController.displayStarMenu(_buildMenu(fabKey), fabKey);
             },
         ),
       ],
     ),
   );
 }
```