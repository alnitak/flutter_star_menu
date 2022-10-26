import 'package:flutter/material.dart';

import 'star_menu.dart';

class StarMenuOverlay {
  // Build the StarMenu on an overlay
  static displayStarMenu(BuildContext context, StarMenu starMenu) {
    // Retrieve the parent Overlay
    OverlayState? _overlayState = Overlay.of(context);

    // Generate the Stack containing all StarItems that will
    // be displayed onto the Overlay
    OverlayEntry _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            starMenu,
          ],
        );
      },
    );
    
    
    // Add it to the Overlay
    _overlayState!.insert(_overlayEntry);

  }
}
