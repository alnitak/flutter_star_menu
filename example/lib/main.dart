import 'package:flutter/material.dart';
import 'package:star_menu/star_menu.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'StarMenu demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final String? title;

  MyHomePage({Key? key, this.title}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  GlobalKey? iconKey;
  GlobalKey? fabKey1;
  GlobalKey? fabKey2;
  GlobalKey? fabKey3;
  GlobalKey? menuBluFabKey;
  GlobalKey? starMenuKey;
  var _value = ValueNotifier<bool?>(false);


  Widget _buildSubMenu(GlobalKey parent) {
    return StarMenu(
      parentKey: parent,
      radiusX: 80,
      radiusY: 80,
      startAngle: 0,
      endAngle: 180.0 / 3.0 * 4.0, // to let the last item to be exactly at 180 degree: [angle / (items-1) * items]
      durationMs: 600,
      itemDelayMs: 200,
      backgroundColor: Color.fromARGB(0, 100, 0, 0),
      onItemPressed: (i) => {print("PRESSED $i")},
      items: <Widget>[
        Container(
          decoration: ShapeDecoration(
              color: Colors.purple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
          ),
          width: 40,
          height: 40,
        ),
        Container(
          decoration: ShapeDecoration(
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
          ),
          width: 40,
          height: 40,
        ),
        Container(
          decoration: ShapeDecoration(
              color: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
          ),
          width: 40,
          height: 40,
        ),
        Container(
          decoration: ShapeDecoration(
              color: Colors.limeAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
          ),
          width: 40,
          height: 40,
        ),
      ],
    );
  }

  Widget _buildMenu(GlobalKey parent, MenuShape shape, double startAngle) {
    return StarMenu(
      key: starMenuKey,
      parentKey: parent,
      shape: shape,
      radiusX: 100,
      radiusY: 150,
      radiusIncrement: 5,
      startAngle: startAngle,
      endAngle: 360,
      durationMs: 500,
      rotateItemsAnimationAngle: 180.0,
      startItemScaleAnimation: 0.5,
      columns: 3,
      columnsSpaceH: 20,
      columnsSpaceV: 10,
      backgroundColor: Color.fromARGB(0, 0, 0, 50),
      checkScreenBoundaries: true,
      useScreenCenter: false,
      centerOffset: Offset(0,0),
      animationCurve: Curves.easeIn,
      onItemPressed: (i) => {print("PRESSED $i")},
      items: <Widget>[
        Container(
          child: Image.asset('assets/images/emoticon_017.png', width: 50, height: 50,),
        ),
        Material(
          color: Colors.yellow,
          child: ValueListenableBuilder(
            valueListenable: _value,
            builder: (context, dynamic value, child) {
              return Checkbox(
                value: _value.value,
                onChanged: (bool? b) {
                  setState( () => _value.value = b );
                },
              );
            }
          ),
        ),
        Container(
          child: Image.asset('assets/images/emoticon_008.png', width: 50, height: 50,),
        ),
        FloatingActionButton(
          key: menuBluFabKey,
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(Icons.menu),
          onPressed: () {
            StarMenuController.displayStarMenu(_buildSubMenu(menuBluFabKey!) as StarMenu, menuBluFabKey!);
          },
        ),
        Container(
          child: Image.asset('assets/images/flutter.png', width: 80, height: 80,),
          color: Colors.white,
        ),
        FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.close),
          onPressed: () {
            // This FAB has the onPressed event and StarMenu doesn't grab the item pressed.
            // If you want to manually close this menu, assign to this menu a
            // GlobalKey and do the following code
            StarMenuState sms = starMenuKey!.currentState as StarMenuState;
            sms.close();
          },
        ),
        Container(
          child: Image.asset('assets/images/emoticon_050.png', width: 50, height: 50,),
        ),
        Container(
          child: Image.asset('assets/images/emoticon_114.png', width: 80, height: 80,),
        ),
        Container(
          child: Image.asset('assets/images/emoticon_100.png', width: 50, height: 50,),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    fabKey1 = GlobalKey();
    fabKey2 = GlobalKey();
    fabKey3 = GlobalKey();
    iconKey = GlobalKey();
    menuBluFabKey = GlobalKey();
    starMenuKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Stack(
        children: <Widget>[
          PerformanceOverlay(),
          Container(
            decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
              ),
            ),
          ),



          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

            FloatingActionButton(
                key: fabKey1,
                backgroundColor: Colors.amberAccent,
                foregroundColor: Colors.black,
                child: Icon(Icons.adjust),
                onPressed: () {
                  StarMenuController.displayStarMenu(_buildMenu(fabKey1!, MenuShape.circle, 0.0) as StarMenu, fabKey1!);
                },
            ),

            Divider(height: 120,),

            FloatingActionButton(
                key: fabKey2,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                child: Icon(Icons.apps),
                onPressed: () {
                  StarMenuController.displayStarMenu(_buildMenu(fabKey2!, MenuShape.grid, 0.0) as StarMenu, fabKey2!);
                },
            ),

            Divider(height: 120,),

            FloatingActionButton(
                key: fabKey3,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                child: Icon(Icons.more_vert),
                onPressed: () {
                  StarMenuController.displayStarMenu(_buildMenu(fabKey3!, MenuShape.linear, 90.0) as StarMenu, fabKey3!);
                },
            ),




            ],
          ),


        ],


      ),
    );
  }
}
