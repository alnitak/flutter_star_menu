import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:star_menu/star_menu.dart';
import 'package:star_menu_example/submenu_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarMenu Demo',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        // enable mouse dragging on desktop
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      theme: ThemeData(useMaterial3: false),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
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
        title: const Text('StarMenu demo'),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text('Load items at runtime'),

                    // LAZY MENU
                    StarMenu(
                      onStateChanged: (state) {
                        debugPrint('State changed: $state');
                      },
                      params: const StarMenuParameters(
                        shape: MenuShape.linear,
                        linearShapeParams: LinearShapeParams(
                          angle: 270,
                          space: 30,
                        ),
                      ),

                      onItemTapped: (index, controller) {
                        // don't close if the item tapped is not the ListView
                        if (index != 1) controller.closeMenu!();
                      },
                      // lazyItemsLoad let you build menu entries at runtime
                      lazyItems: () async {
                        return [
                          Container(
                            color: Color.fromARGB(
                              255,
                              Random().nextInt(255),
                              Random().nextInt(255),
                              Random().nextInt(255),
                            ),
                            width: 100,
                            height: 40,
                          ),
                          SizedBox(
                            width: 150,
                            height: 230,
                            child: Card(
                              elevation: 6,
                              margin: const EdgeInsets.all(6),
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
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      s,
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ];
                      },
                      child: FloatingActionButton(
                        onPressed: () {
                          debugPrint('FloatingActionButton Menu1 tapped');
                        },
                        child: const Icon(Icons.looks_one),
                      ),
                    ),

                    const SizedBox(height: 40),
                    const Text('Colored and blurred background'),

                    // LINEAR MENU
                    StarMenu(
                      params: StarMenuParameters(
                        shape: MenuShape.linear,
                        onHoverScale: 1.3,
                        linearShapeParams: const LinearShapeParams(
                          angle: 270,
                          space: 10,
                        ),
                        boundaryBackground: BoundaryBackground(),
                        backgroundParams: BackgroundParams(
                          backgroundColor: Colors.blue.withValues(alpha: 0.2),
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                      ),
                      onItemTapped: (index, controller) {
                        if (index == 7) controller.closeMenu!();
                      },
                      items: entries,
                      child: FloatingActionButton(
                        onPressed: () {
                          debugPrint('FloatingActionButton Menu1 tapped');
                        },
                        child: const Icon(Icons.looks_two),
                      ),
                    ),

                    const SizedBox(height: 40),
                    const Text('Animated blur background'),

                    // CIRCLE MENU
                    // it's possible to use the extension addStarMenu()
                    // with all Widgets
                    FloatingActionButton(
                      onPressed: () {
                        debugPrint('FloatingActionButton Menu2 tapped');
                      },
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.looks_3),
                    ).addStarMenu(
                      items: entries,
                      params: const StarMenuParameters(
                        backgroundParams: BackgroundParams(
                          animatedBlur: true,
                          sigmaX: 4,
                          sigmaY: 4,
                        ),
                        circleShapeParams: CircleShapeParams(radiusY: 280),
                        openDurationMs: 1000,
                        rotateItemsAnimationAngle: 360,
                      ),
                      onItemTapped: (index, controller) {
                        if (index == 7) controller.closeMenu!();
                      },
                    ),

                    const SizedBox(height: 40),
                    const Text('Animated color background'),

                    // GRID MENU
                    StarMenu(
                      params: StarMenuParameters(
                        shape: MenuShape.grid,
                        openDurationMs: 1200,
                        gridShapeParams: const GridShapeParams(
                          columnsSpaceH: 6,
                          columnsSpaceV: 6,
                        ),
                        backgroundParams: BackgroundParams(
                          animatedBackgroundColor: true,
                          backgroundColor: Colors.black.withValues(alpha: 0.4),
                        ),
                      ),
                      onItemTapped: (index, controller) {
                        if (index == 7) controller.closeMenu!();
                      },
                      items: entries,
                      child: FloatingActionButton(
                        onPressed: () {
                          debugPrint('FloatingActionButton Menu3 tapped');
                        },
                        backgroundColor: Colors.black,
                        child: const Icon(Icons.looks_4),
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
    final sliderValue = ValueNotifier<double>(0.5);
    return [
      const SubMenuCard(
        width: 100,
        text: 'Linear, check whole menu boundaries',
      ).addStarMenu(
        items: subEntries,
        params: const StarMenuParameters(
          shape: MenuShape.linear,
          linearShapeParams: LinearShapeParams(
            angle: 120,
            space: 15,
          ),
        ),
      ),
      const SubMenuCard(
        width: 70,
        text: 'Linear, centered items',
      ).addStarMenu(
        items: subEntries,
        params: const StarMenuParameters(
          shape: MenuShape.linear,
          linearShapeParams: LinearShapeParams(
            space: 15,
          ),
        ),
      ),
      const SubMenuCard(
        width: 70,
        text: 'Linear, check items boundaries',
      ).addStarMenu(
        items: subEntries,
        params: const StarMenuParameters(
          shape: MenuShape.linear,
          linearShapeParams: LinearShapeParams(
            angle: 60,
            space: 15,
          ),
          checkItemsScreenBoundaries: true,
          checkMenuScreenBoundaries: false,
        ),
      ),
      const SubMenuCard(
        width: 70,
        text: 'Linear, left aligned',
      ).addStarMenu(
        items: subEntries,
        params: const StarMenuParameters(
          shape: MenuShape.linear,
          linearShapeParams: LinearShapeParams(
            space: 15,
            alignment: LinearAlignment.left,
          ),
        ),
      ),
      const SubMenuCard(
        width: 60,
        text: 'Centered circle',
      ).addStarMenu(
        items: subEntries,
        params: const StarMenuParameters(
          useScreenCenter: true,
        ),
      ),
      const SubMenuCard(
        width: 70,
        text: 'Linear, right aligned',
      ).addStarMenu(
        items: subEntries,
        params: const StarMenuParameters(
          shape: MenuShape.linear,
          linearShapeParams: LinearShapeParams(
            alignment: LinearAlignment.right,
          ),
        ),
      ),
      SizedBox(
        width: 180,
        height: 20,
        child: ValueListenableBuilder<double>(
          valueListenable: sliderValue,
          builder: (_, v, _) {
            return Slider(
              value: v,
              onChanged: (value) {
                sliderValue.value = value;
              },
            );
          },
        ),
      ),
      FloatingActionButton(child: const Text('close'), onPressed: () {}),
    ];
  }

  // Build the list of sub-menu entries
  List<Widget> subMenuEntries() {
    return [
      const Chip(
        avatar: CircleAvatar(
          child: Text('SM'),
        ),
        label: Text('of widgets'),
      ),
      const Chip(
        avatar: CircleAvatar(
          child: Text('SM'),
        ),
        label: Text('any kind'),
      ),
      const Chip(
        avatar: CircleAvatar(
          child: Text('SM'),
        ),
        label: Text('almost'),
      ),
      const Chip(
        avatar: CircleAvatar(
          child: Text('SM'),
        ),
        label: Text('can be'),
      ),
      const Chip(
        avatar: CircleAvatar(
          child: Text('SM'),
        ),
        label: Text('The menu entries'),
      ),
    ];
  }
}
