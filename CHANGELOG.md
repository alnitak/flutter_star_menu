## [3.1.0+1] - 26 Oct 2022
* it's now possible to open a menu programmatically with [StarMenuController].
* it's now possible to open a menu programmatically by passing [parentContext] to [StarMenu].
* added [useTouchAsCenter] to [StarMenuParameters] to use the touch position as the menu center.

## [3.0.0+2] - 23 Sep 2022
* added a new main.dart example
* added `onHoverScale` in `StarMenuParameters` to scale items when mouse hover (desktop only)
* added `BoundaryBackground` to set a background behind all the menu items
* the opening animation now starts from the first menu item
* added `dropdown`, `arc` and `panel` menu presets 
* breaking change: [StarMenuParameters.onItemTapped] moved into [StarMenu] widget

## [2.2.0] - 23 Jul 2022
* added [useLongpress] and [longPressDuration] to open the menu with a long press

## [2.1.3] - 13 Mar 2022
* code formatted

## [2.1.2] - 12 Mar 2022
* fixed wrong menu position when using RTL

## [2.1.1] - 10 Nov 2021
* added `onStateChanged` callback which triggers `closed`, `closing`, `opening`, `open` states

## [2.1.0] - 29 Oct 2021
* added a movement threshold for touches: 
if a movement of more the 10 px occurs after touching the 
widget, it will not open
* bug fix when changing device rotation
* added `lazyItems` property which builds menu items at runtime

## [2.0.1] - 22 Aug 2021
* support for hot reload

## [2.0.0+3] - 10 Aug 2021
* removed dart:io dependency for web compatibility
* bug fix in web version when animating the blur

## [2.0.0+2] - 10 Aug 2021
* added some documentation

## [2.0.0+1] - 10 Aug 2021
* breaking change: code rewritten to remove the 'keys boilerplate' (see the doc) and performances issue

## [1.0.4] - 12 Jun 2019
* blurring background while opening

## [1.0.2] - 31 Mar 2019
* fixed some naming conventions and formats for pub


## [1.0.0] - 31 Mar 2019
* initial release.