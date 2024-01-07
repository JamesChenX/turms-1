import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../themes/theme_config.dart';

part 't_avatar_size.dart';

// The colors are copied from "Colors.primaries" but excluding gray colors.
const List<Color> _colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  // Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
];

final _colorCount = _colors.length;

class TAvatar extends StatelessWidget {
  TAvatar(
      {super.key,
      required this.name,
      this.image,
      this.size = TAvatarSize.medium,
      this.onPressed})
      : firstChar = name.isEmpty ? '' : name.substring(0, 1);

  final String name;
  final String firstChar;
  final ImageProvider? image;
  final TAvatarSize size;
  final GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final img = image;
    final containerSize = size.containerSize;
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: ThemeConfig.borderRadius4,
        child: null == img
            ? name.isEmpty
                ? Container(
                    height: containerSize,
                    width: containerSize,
                    color: const Color.fromARGB(255, 117, 117, 117),
                    alignment: Alignment.center,
                    child: Icon(Symbols.person_rounded,
                        fill: 1, color: Colors.white, size: size.iconSize),
                  )
                : Container(
                    height: containerSize,
                    width: containerSize,
                    // color: const Color(0xffFF0E58),
                    color: _pickColor(name),
                    alignment: Alignment.center,
                    child: Text(
                      firstChar,
                      style: TextStyle(
                          fontSize: size.textSize, color: Colors.white),
                    ),
                  )
            : SizedBox(
                height: containerSize,
                width: containerSize,
                child: // FittedBox is used as a fallback in case the image is not fitted.
                    FittedBox(child: Image(image: img)),
              ),
      ),
    );
  }

  Color _pickColor(String name) {
    var result = 0;
    for (final value in name.codeUnits) {
      result += value;
    }
    return _colors[result % _colorCount];
  }
}