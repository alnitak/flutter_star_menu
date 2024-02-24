import 'package:flutter/widgets.dart';

class CenteredWidget extends StatelessWidget {
  const CenteredWidget({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: child,
    );
  }
}
