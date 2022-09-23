import 'package:flutter/widgets.dart';

/// Center child widget using [center] position
class CenteredWidget extends StatelessWidget {
  final Widget child;

  CenteredWidget({
    key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: child,
    );
  }
}
