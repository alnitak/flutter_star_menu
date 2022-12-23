import 'package:flutter/material.dart';
import 'package:star_menu/star_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StarMenu Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StarMenuController backgroundStarMenuController = StarMenuController();
    StarMenuController centerStarMenuController = StarMenuController();
    ValueNotifier<double> sliderValue = ValueNotifier(0.5);
    GlobalKey containerKey = GlobalKey();

    // entries for the dropdown menu
    List<Widget> upperMenuItems = [
      Text('menu entry 1'),
      Text('menu entry 3'),
      Text('menu entry 3'),
      Text('menu entry 4'),
      Text('menu entry 5'),
      Text('menu entry 6'),
    ];

    // other entries
    // Every items may have a sub-menu.
    // Here the sub-menus are added with [addStarMenu] extension
    List<Widget> otherEntries = [
      FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ).addStarMenu(
          items: upperMenuItems, params: StarMenuParameters.dropdown(context)),
      FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.black,
        child: Icon(Icons.add_call),
      ).addStarMenu(
          items: upperMenuItems, params: StarMenuParameters.dropdown(context)),
      FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.indigo,
        child: Icon(Icons.adb),
      ).addStarMenu(
          items: upperMenuItems, params: StarMenuParameters.dropdown(context)),
      FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.purple,
        child: Icon(Icons.home),
      ).addStarMenu(
          items: upperMenuItems, params: StarMenuParameters.dropdown(context)),
      FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.delete),
      ).addStarMenu(
          items: upperMenuItems, params: StarMenuParameters.dropdown(context)),
      FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.get_app),
      ).addStarMenu(
          items: upperMenuItems, params: StarMenuParameters.dropdown(context)),
    ];

    // bottom left menu entries
    List<Widget> chipsEntries = [
      Chip(
        avatar: CircleAvatar(child: const Text('SM')),
        label: const Text('of widgets'),
      ),
      Chip(
        avatar: CircleAvatar(child: const Text('SM')),
        label: const Text('any kind'),
      ),
      Chip(
        avatar: CircleAvatar(child: const Text('SM')),
        label: const Text('almost'),
      ),
      Chip(
        avatar: CircleAvatar(child: const Text('SM')),
        label: const Text('can be'),
      ),
      Chip(
        avatar: CircleAvatar(child: const Text('SM')),
        label: const Text('entries'),
      ),
      Chip(
        avatar: CircleAvatar(child: const Text('SM')),
        label: const Text('The menu'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('StarMenu demo'),
        actions: [
          // upper bar menu
          StarMenu(
            params: StarMenuParameters.dropdown(context).copyWith(
              backgroundParams: BackgroundParams().copyWith(
                sigmaX: 3,
                sigmaY: 3,
              ),
            ),
            items: upperMenuItems,
            onItemTapped: (index, _) => print('Item $index tapped'),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Icon(Icons.menu),
            ),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              /// add a menu to the background
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
              ).addStarMenu(
                items: upperMenuItems,
                params: StarMenuParameters.dropdown(context).copyWith(
                  useTouchAsCenter: true,
                ),
                controller: backgroundStarMenuController,
              ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 1,
                  height: double.maxFinite,
                  color: Colors.black45,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: double.maxFinite,
                  height: 1,
                  color: Colors.black45,
                ),
              ),

              // background
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Touch the background to open the menu '
                  'at the coordinates you touched',
                  textAlign: TextAlign.center,
                  textScaleFactor: 2,
                ),
              ),

              // center menu with default [StarMenuParameters] parameters
              Align(
                alignment: Alignment.center,
                child: StarMenu(
                  params: StarMenuParameters(),
                  controller: centerStarMenuController,
                  items: otherEntries,
                  child: FloatingActionButton(
                    onPressed: null,
                    mini: true,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.add),
                  ),
                ),
              ),

              // center right menu.
              Align(
                alignment: Alignment.centerRight,
                child: StarMenu(
                  params: StarMenuParameters.arc(
                    context,
                    ArcType.semiLeft,
                    radiusX: 100,
                    radiusY: 180,
                  ),
                  items: otherEntries,
                  child: FloatingActionButton(
                      onPressed: null, child: Icon(Icons.home_work_outlined)),
                ),
              ),

              // bottom right panel menu
              Align(
                alignment: Alignment.bottomRight,
                child: StarMenu(
                  params: StarMenuParameters.panel(context, columns: 3)
                      .copyWith(centerOffset: Offset(-150, -150)),
                  items: [
                    IconMenu(icon: Icons.skip_previous, text: 'previous'),
                    IconMenu(icon: Icons.play_arrow, text: 'play'),
                    IconMenu(icon: Icons.skip_next, text: 'next'),
                    IconMenu(icon: Icons.album, text: 'album'),
                    IconMenu(icon: Icons.alarm, text: 'alarm'),
                    IconMenu(icon: Icons.info_outline, text: 'info'),
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
                  ],
                  child: FloatingActionButton(
                      onPressed: null, child: Icon(Icons.grid_view)),
                ),
              ),

              // bottom left linear menu
              Align(
                alignment: Alignment.bottomLeft,
                child: StarMenu(
                  params: StarMenuParameters(
                    shape: MenuShape.linear,
                    linearShapeParams: LinearShapeParams(
                      angle: 90,
                      alignment: LinearAlignment.left,
                      space: 15,
                    ),
                    animationCurve: Curves.easeOutCubic,
                    centerOffset: Offset(50, -50),
                    openDurationMs: 150,
                  ),
                  items: chipsEntries,
                  parentContext: containerKey.currentContext,
                  child: FloatingActionButton(
                    onPressed: null,
                    child: Icon(Icons.view_stream_rounded),
                  ),
                ),
              ),

              // a generic Widget with its key defined.
              // This key will be used to show the menu with an event
              // like pressing a button
              Align(
                alignment: Alignment(0.0, -0.4),
                child: Container(
                  key: containerKey,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),

              // open centered menu programmatically
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // programmatically open the menu using StartMenu controller
                    ElevatedButton(
                      onPressed: () => centerStarMenuController.openMenu!(),
                      child: Text(
                        'Open centered menu\nprogrammatically\nwith controller',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // programmatically open the menu using
                    // a key of a widget
                    ElevatedButton(
                      onPressed: () {
                        StarMenuOverlay.displayStarMenu(
                          containerKey.currentContext!,
                          StarMenu(
                            params: StarMenuParameters(),
                            items: otherEntries,
                            parentContext: containerKey.currentContext,
                          ),
                        );
                      },
                      child: Text(
                        'Open menu\nprogrammatically\nwith a Widget key',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class IconMenu extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconMenu({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 6),
        Text(text),
      ],
    );
  }
}
