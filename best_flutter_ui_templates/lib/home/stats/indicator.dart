import 'package:best_flutter_ui_templates/home/home_theme.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String name;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.name,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape:BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          name,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor, fontFamily: HomeTheme.fontName),
        )
      ],
    );
  }
}