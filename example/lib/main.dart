import 'package:flutter/material.dart';
import 'package:star_menu/star_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StarMenu Demo',
      home: const MyHomePage(),
      theme: ThemeData(useMaterial3: false),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundStarMenuController = StarMenuController();
    final centerStarMenuController = StarMenuController();
    final sliderValue = ValueNotifier<double>(0.5);
    final containerKey = GlobalKey();

    // entries for the dropdown menu
    final upperMenuItems = <Widget>[
      const Text('menu entry 1'),
      const Text('menu entry 2'),
      const Text('menu entry 3'),
      const Text('menu entry 4'),
      const Text('menu entry 5'),
      const Text('menu entry 6'),
    ];

    // other entries
    // Every items may have a sub-menu.
    // Here the sub-menus are added with [addStarMenu] extension
    final otherEntries = <Widget>[
      const FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.black,
        child: Icon(Icons.add_call),
      ).addStarMenu(
        items: upperMenuItems,
        params: StarMenuParameters.dropdown(context),
      ),
      const FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.indigo,
        child: Icon(Icons.adb),
      ).addStarMenu(
        items: upperMenuItems,
        params: StarMenuParameters.dropdown(context),
      ),
      const FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.purple,
        child: Icon(Icons.home),
      ).addStarMenu(
        items: upperMenuItems,
        params: StarMenuParameters.dropdown(context),
      ),
      const FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.delete),
      ).addStarMenu(
        items: upperMenuItems,
        params: StarMenuParameters.dropdown(context),
      ),
      const FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.get_app),
      ).addStarMenu(
        items: upperMenuItems,
        params: StarMenuParameters.dropdown(context),
      ),
    ];

    // bottom left menu entries
    final chipsEntries = <Widget>[
      const Chip(
        avatar: CircleAvatar(child: Text('SM')),
        label: Text('of widgets'),
      ),
      const Chip(
        avatar: CircleAvatar(child: Text('SM')),
        label: Text('any kind'),
      ),
      const Chip(
        avatar: CircleAvatar(child: Text('SM')),
        label: Text('almost'),
      ),
      const Chip(
        avatar: CircleAvatar(child: Text('SM')),
        label: Text('can be'),
      ),
      const Chip(
        avatar: CircleAvatar(child: Text('SM')),
        label: Text('entries'),
      ),
      const Chip(
        avatar: CircleAvatar(child: Text('SM')),
        label: Text('The menu'),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('StarMenu demo'),
        actions: [
          // upper bar menu
          StarMenu(
            params: StarMenuParameters.dropdown(context).copyWith(
              backgroundParams: const BackgroundParams().copyWith(
                sigmaX: 3,
                sigmaY: 3,
              ),
            ),
            items: upperMenuItems,
            onItemTapped: (index, c) {
              debugPrint('Item $index tapped');
              c.closeMenu!();
            },
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Icon(Icons.menu),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
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
              child: Container(
                width: 1,
                height: double.maxFinite,
                color: Colors.black45,
              ),
            ),
            Align(
              child: Container(
                width: double.maxFinite,
                height: 1,
                color: Colors.black45,
              ),
            ),

            // background
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Touch the background to open the menu '
                'at the coordinates you touched',
                textAlign: TextAlign.center,
              ),
            ),

            // center menu with default [StarMenuParameters] parameters
            Align(
              child: StarMenu(
                controller: centerStarMenuController,
                items: otherEntries,
                child: const FloatingActionButton(
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
                  ArcType.semiLeft,
                  radiusX: 100,
                  radiusY: 180,
                ),
                items: otherEntries,
                child: const FloatingActionButton(
                  onPressed: null,
                  child: Icon(Icons.home_work_outlined),
                ),
              ),
            ),

            // bottom right panel menu
            Align(
              alignment: Alignment.bottomRight,
              child: StarMenu(
                params: StarMenuParameters.panel(
                  context,
                  columns: 3,
                ).copyWith(centerOffset: const Offset(-150, -150)),
                items: [
                  const IconMenu(icon: Icons.skip_previous, text: 'previous'),
                  const IconMenu(icon: Icons.play_arrow, text: 'play'),
                  const IconMenu(icon: Icons.skip_next, text: 'next'),
                  const IconMenu(icon: Icons.album, text: 'album'),
                  const IconMenu(icon: Icons.alarm, text: 'alarm'),
                  const IconMenu(icon: Icons.info_outline, text: 'info'),
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
                          },
                        );
                      },
                    ),
                  ),
                ],
                child: const FloatingActionButton(
                  onPressed: null,
                  child: Icon(Icons.grid_view),
                ),
              ),
            ),

            // bottom left linear menu
            Align(
              alignment: Alignment.bottomLeft,
              child: StarMenu(
                params: const StarMenuParameters(
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
                child: const FloatingActionButton(
                  onPressed: null,
                  child: Icon(Icons.view_stream_rounded),
                ),
              ),
            ),

            // a generic Widget with its key defined.
            // This key will be used to show the menu with an event
            // like pressing a button
            Align(
              alignment: const Alignment(0, -0.4),
              child: Container(
                key: containerKey,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: const BorderRadius.all(
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
                    child: const Text(
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
                          items: otherEntries,
                          parentContext: containerKey.currentContext,
                        ),
                      );
                    },
                    child: const Text(
                      'Open menu\nprogrammatically\nwith a Widget key',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconMenu extends StatelessWidget {
  const IconMenu({
    required this.icon,
    required this.text,
    super.key,
  });

  final IconData icon;
  final String text;

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
