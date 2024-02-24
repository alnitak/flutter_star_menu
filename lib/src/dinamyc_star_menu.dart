import 'package:flutter/material.dart';

import 'package:star_menu/src/star_menu.dart';

// Creates an overlay to display the StarMenu and open it
class StarMenuOverlay {
  static StarMenu? _sm;
  static OverlayState? _overlayState;
  static OverlayEntry? _overlayEntry;

  // Build the StarMenu on an overlay
  static void displayStarMenu(BuildContext context, StarMenu starMenu) {
    _sm = starMenu;
    // Retrieve the parent Overlay
    _overlayState = Overlay.of(context);

    // Generate the Stack containing all StarItems that will
    // be displayed onto the Overlay
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            starMenu,
          ],
        );
      },
    );

    // Add it to the Overlay
    if (_overlayEntry != null) {
      _overlayState!.insert(_overlayEntry!);
    }
  }

  static void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _sm = null;
  }

  static bool isMounted(State<StarMenu> state) {
    // Is it correct to use the hashCode??
    return _overlayEntry != null && state.widget.hashCode == _sm.hashCode;
  }
}
