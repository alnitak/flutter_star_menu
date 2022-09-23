import 'dart:math';

import 'package:flutter/material.dart';
import 'package:star_menu/star_menu.dart';
import 'package:star_menu_example/submenu_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarMenu Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Widget> entries;
  late List<Widget> subEntries;

  @override
  void initState() {
    super.initState();
    subEntries = subMenuEntries();
    entries = menuEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StarMenu demo'),
      ),
      body: Stack(
        children: [
          Center(
            // Scroll view to test the item centers are always
            // computed even if its position changes
            child: SingleChildScrollView(
              child: SizedBox(
                height: 1000,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text('Load items at runtime'),

                    // LAZY MENU
                    StarMenu(
                      onStateChanged: (state) {
                        print('State changed: $state');
                      },
                      params: StarMenuParameters(
                        shape: MenuShape.linear,
                        linearShapeParams: LinearShapeParams(
                            angle: 270,
                            space: 30,
                            alignment: LinearAlignment.center),
                      ),

                      onItemTapped: (index, controller) {
                        // don't close if the item tapped is not the ListView
                        if (index != 1) controller.closeMenu();
                      },
                      // lazyItemsLoad let you build menu entries at runtime
                      lazyItems: () async {
                        return [
                          Container(
                            color: Color.fromARGB(255, Random().nextInt(255),
                                Random().nextInt(255), Random().nextInt(255)),
                            width: 60,
                            height: 40,
                          ),
                          Container(
                            width: 150,
                            height: 200,
                            child: Card(
                              elevation: 6,
                              margin: EdgeInsets.all(6),
                              child: ListView(
                                children: [
                                  'the',
                                  'menu',
                                  'entries',
                                  'can',
                                  'be',
                                  'almost',
                                  'any',
                                  'kind',
                                  'of',
                                  'widgets',
                                ].map((s) {
                                  return Card(
                                    child: Text(s),
                                    margin: EdgeInsets.all(10),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ];
                      },
                      child: FloatingActionButton(
                        onPressed: () {
                          print('FloatingActionButton Menu1 tapped');
                        },
                        child: Icon(Icons.looks_one),
                      ),
                    ),

                    SizedBox(height: 40),
                    Text('Colored and blurred background'),

                    // LINEAR MENU
                    StarMenu(
                      params: StarMenuParameters(
                        shape: MenuShape.linear,
                        openDurationMs: 400,
                        onHoverScale: 1.3,
                        linearShapeParams: LinearShapeParams(
                            angle: 270,
                            space: 10,
                            alignment: LinearAlignment.center),
                        boundaryBackground: BoundaryBackground(),
                        backgroundParams: BackgroundParams(
                          backgroundColor: Colors.blue.withOpacity(0.2),
                          animatedBackgroundColor: false,
                          animatedBlur: false,
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                      ),
                      onItemTapped: (index, controller) {
                        if (index == 7) controller.closeMenu();
                      },
                      items: entries,
                      child: FloatingActionButton(
                        onPressed: () {
                          print('FloatingActionButton Menu1 tapped');
                        },
                        child: Icon(Icons.looks_two),
                      ),
                    ),

                    SizedBox(height: 40),
                    Text('Animated blur background'),

                    // CIRCLE MENU
                    // it's possible to use the extension addStarMenu()
                    // with all Widgets
                    FloatingActionButton(
                      onPressed: () {
                        print('FloatingActionButton Menu2 tapped');
                      },
                      backgroundColor: Colors.red,
                      child: Icon(Icons.looks_3),
                    ).addStarMenu(
                        entries,
                        StarMenuParameters(
                          backgroundParams: BackgroundParams(
                              animatedBlur: true,
                              sigmaX: 4.0,
                              sigmaY: 4.0,
                              backgroundColor: Colors.transparent),
                          circleShapeParams: CircleShapeParams(radiusY: 280),
                          openDurationMs: 1000,
                          rotateItemsAnimationAngle: 360,
                        ), onItemTapped: (index, controller) {
                      if (index == 7) controller.closeMenu();
                    }),

                    SizedBox(height: 40),
                    Text('Animated color background'),

                    // GRID MENU
                    StarMenu(
                      params: StarMenuParameters(
                          shape: MenuShape.grid,
                          openDurationMs: 1200,
                          gridShapeParams: GridShapeParams(
                              columns: 3, columnsSpaceH: 6, columnsSpaceV: 6),
                          backgroundParams: BackgroundParams(
                              sigmaX: 0,
                              sigmaY: 0,
                              animatedBackgroundColor: true,
                              backgroundColor: Colors.black.withOpacity(0.4)),
                      ),
                      onItemTapped: (index, controller) {
                        if (index == 7) controller.closeMenu();
                      },
                      items: entries,
                      child: FloatingActionButton(
                        onPressed: () {
                          print('FloatingActionButton Menu3 tapped');
                        },
                        backgroundColor: Colors.black,
                        child: Icon(Icons.looks_4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the list of menu entries
  List<Widget> menuEntries() {
    ValueNotifier<double> sliderValue = ValueNotifier(0.5);
    return [
      SubMenuCard(
        width: 100,
        text: 'Linear, check whole menu boundaries',
      ).addStarMenu(
          subEntries,
          StarMenuParameters(
              shape: MenuShape.linear,
              linearShapeParams: LinearShapeParams(
                angle: 120,
                space: 15,
              ),
              checkMenuScreenBoundaries: true)),
      SubMenuCard(
        width: 70,
        text: 'Linear, centered items',
      ).addStarMenu(
          subEntries,
          StarMenuParameters(
            shape: MenuShape.linear,
            linearShapeParams: LinearShapeParams(
                angle: 90, space: 15, alignment: LinearAlignment.center),
          )),
      SubMenuCard(
        width: 70,
        text: 'Linear, check items boundaries',
      ).addStarMenu(
          subEntries,
          StarMenuParameters(
              shape: MenuShape.linear,
              linearShapeParams: LinearShapeParams(
                angle: 60,
                space: 15,
              ),
              checkItemsScreenBoundaries: true,
              checkMenuScreenBoundaries: false)),
      SubMenuCard(
        width: 70,
        text: 'Linear, left aligned',
      ).addStarMenu(
          subEntries,
          StarMenuParameters(
            shape: MenuShape.linear,
            linearShapeParams: LinearShapeParams(
                angle: 90, space: 15, alignment: LinearAlignment.left),
          )),
      SubMenuCard(
        width: 60,
        text: 'Centered circle',
      ).addStarMenu(
          subEntries,
          StarMenuParameters(
            shape: MenuShape.circle,
            useScreenCenter: true,
          )),
      SubMenuCard(
        width: 70,
        text: 'Linear, right aligned',
      ).addStarMenu(
          subEntries,
          StarMenuParameters(
            shape: MenuShape.linear,
            linearShapeParams: LinearShapeParams(
                angle: 90, space: 0, alignment: LinearAlignment.right),
          )),
      SizedBox(
        width: 180,
        height: 20,
        child: ValueListenableBuilder<double>(
            valueListenable: sliderValue,
            builder: (_, v, __) {
              return Slider(
                  value: v,
                  onChanged: (value) {
                    sliderValue.value = value;
                  });
            }),
      ),
      FloatingActionButton(child: Text('close'), onPressed: () {})
    ];
  }

  // Build the list of sub-menu entries
  List<Widget> subMenuEntries() {
    return [
      Chip(
        avatar: CircleAvatar(
          child: const Text('SM'),
        ),
        label: const Text('of widgets'),
      ),
      Chip(
        avatar: CircleAvatar(
          child: const Text('SM'),
        ),
        label: const Text('any kind'),
      ),
      Chip(
        avatar: CircleAvatar(
          child: const Text('SM'),
        ),
        label: const Text('almost'),
      ),
      Chip(
        avatar: CircleAvatar(
          child: const Text('SM'),
        ),
        label: const Text('can be'),
      ),
      Chip(
        avatar: CircleAvatar(
          child: const Text('SM'),
        ),
        label: const Text('The menu entries'),
      ),
    ];
  }
}
