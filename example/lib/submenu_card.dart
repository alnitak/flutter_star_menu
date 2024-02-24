import 'package:flutter/material.dart';

class SubMenuCard extends StatelessWidget {
  const SubMenuCard({
    required this.width,
    super.key,
    this.text = '',
  });
  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: width,
          child: Text(text, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
