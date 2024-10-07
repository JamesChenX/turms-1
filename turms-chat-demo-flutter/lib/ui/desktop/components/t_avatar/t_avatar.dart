import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../themes/index.dart';

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
      this.icon,
      this.size = TAvatarSize.medium,
      this.textSize})
      : firstChar = name.isEmpty ? '' : name.substring(0, 1);

  final String name;
  final String firstChar;
  final ImageProvider? image;
  final IconData? icon;
  final TAvatarSize size;
  final double? textSize;

  /// Use oval instead of rounded rect so that
  /// the user presence indicator can display nicely with the avatar.
  @override
  Widget build(BuildContext context) => ClipOval(
        child: _buildAvatar(context.theme),
      );

  Widget _buildAvatar(ThemeData theme) {
    final appThemeExtension = theme.appThemeExtension;
    final img = image;
    final containerSize = size.containerSize;
    if (null != img) {
      return SizedBox(
        height: containerSize,
        width: containerSize,
        child: // FittedBox is used as a fallback in case the image is not fitted.
            FittedBox(child: Image(image: img)),
      );
    } else if (null != icon) {
      return SizedBox(
        height: containerSize,
        width: containerSize,
        child: ColoredBox(
            color: theme.primaryColor,
            child: Icon(
              icon,
              fill: 1,
              color: Colors.white,
              size: size.iconSize,
            )),
      );
    } else if (name.isEmpty) {
      return SizedBox(
        height: containerSize,
        width: containerSize,
        child: ColoredBox(
          color: appThemeExtension.avatarBackgroundColor,
          child: Icon(Symbols.person_rounded,
              fill: 1,
              color: appThemeExtension.avatarIconColor,
              // The "person" icon seems smaller than other icons,
              // so we need to enlarge it.
              size: size.iconSize * 1.25),
        ),
      );
    } else {
      return SizedBox(
        height: containerSize,
        width: containerSize,
        child: ColoredBox(
          color: _pickColor(name),
          child: Center(
            child: Text(
              firstChar,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                  fontSize: textSize ?? size.textSize, color: Colors.white),
            ),
          ),
        ),
      );
    }
  }

  Color _pickColor(String name) {
    var result = 0;
    for (final value in name.codeUnits) {
      result += value;
    }
    return _colors[result % _colorCount];
  }
}
