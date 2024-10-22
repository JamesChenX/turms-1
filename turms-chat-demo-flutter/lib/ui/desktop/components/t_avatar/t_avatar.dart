import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../infra/math/math_utils.dart';
import '../../../themes/index.dart';

part 't_avatar_size.dart';

/// The colors are copied from [Colors.primaries] but excluding gray colors.
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

const presenceBoxDiameter = 14.0;

class TAvatar extends StatelessWidget {
  TAvatar(
      {super.key,
      required this.name,
      this.image,
      this.icon,
      this.size = TAvatarSize.medium,
      this.textSize,
      this.presence = TAvatarUserPresence.none})
      : firstChar = name.isEmpty ? '' : name.substring(0, 1);

  final String name;
  final String firstChar;
  final ImageProvider? image;
  final IconData? icon;
  final TAvatarSize size;
  final double? textSize;
  final TAvatarUserPresence presence;

  /// Use oval instead of rounded rect so that
  /// the user presence indicator can display nicely with the avatar.
  @override
  Widget build(BuildContext context) {
    final avatar = ClipRRect(
      borderRadius: Sizes.borderRadiusCircular4,
      child: _buildAvatar(context.theme),
    );
    if (presence == TAvatarUserPresence.none) {
      return avatar;
    }
    return Stack(clipBehavior: Clip.none, children: [avatar, _buildPresence()]);
  }

  Widget _buildAvatar(ThemeData theme) {
    final containerSize = size.containerSize;
    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: _buildContent(image, theme, theme.appThemeExtension),
    );
  }

  Widget _buildContent(ImageProvider<Object>? img, ThemeData theme,
      AppThemeExtension appThemeExtension) {
    if (null != img) {
      // FittedBox is used as a fallback in case the image is not fitted.
      return FittedBox(child: Image(image: img));
    }
    if (null != icon) {
      return ColoredBox(
          color: theme.primaryColor,
          child: Icon(
            icon,
            fill: 1,
            color: Colors.white,
            size: size.iconSize,
          ));
    }
    if (name.isEmpty) {
      return ColoredBox(
        color: appThemeExtension.avatarBackgroundColor,
        child: Icon(Symbols.person_rounded,
            fill: 1,
            color: appThemeExtension.avatarIconColor,
            // The "person" icon seems smaller than other icons,
            // so we need to enlarge it.
            size: size.iconSize * 1.25),
      );
    }
    return ColoredBox(
      color: _pickColor(name),
      child: Center(
        child: Text(
          firstChar,
          textScaler: TextScaler.noScaling,
          style: TextStyle(
              fontSize: textSize ?? size.textSize, color: Colors.white),
        ),
      ),
    );
  }

  Color _pickColor(String name) {
    var result = 0;
    for (final value in name.runes) {
      result += value;
    }
    return _colors[result % _colorCount];
  }

  Positioned _buildPresence() => Positioned(
        child: SizedBox(
          width: presenceBoxDiameter,
          height: presenceBoxDiameter,
          child: CustomPaint(
            painter: TAvatarUserPresencePainter(presence),
          ),
        ),
        right: 0,
        bottom: 0,
      );
}

enum TAvatarUserPresence { none, available, away, busy, doNotDisturb, offline }

const _padding = 1.0;
const _clockPointDistanceFromEdge = 3.0;
final _clockPoint = MathUtils.calculatePoint(
    presenceBoxDiameter / 2,
    presenceBoxDiameter / 2,
    presenceBoxDiameter / 2,
    _clockPointDistanceFromEdge,
    45);

class TAvatarUserPresencePainter extends CustomPainter {
  const TAvatarUserPresencePainter(this.presence);

  final TAvatarUserPresence presence;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    canvas.drawCircle(
        Offset(centerX, centerY),
        centerX,
        paint
          ..color = Colors.white
          ..style = PaintingStyle.fill);
    switch (presence) {
      case TAvatarUserPresence.available:
        canvas.drawCircle(
            Offset(centerX, centerY),
            centerX - _padding,
            paint
              ..color = Colors.green
              ..style = PaintingStyle.fill);
        break;
      case TAvatarUserPresence.away:
        canvas
          ..drawCircle(Offset(centerX, centerY), centerX - _padding,
              paint..color = Colors.orangeAccent)
          ..drawPath(
              Path()
                ..moveTo(centerX, _clockPointDistanceFromEdge)
                ..lineTo(centerX, centerY)
                ..lineTo(_clockPoint.x, _clockPoint.y),
              paint
                ..color = Colors.white
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1);
        break;
      case TAvatarUserPresence.busy:
        canvas.drawCircle(Offset(centerX, centerY), centerX - _padding,
            paint..color = Colors.red);
        break;
      case TAvatarUserPresence.doNotDisturb:
        final padding = size.width / 3.5;
        canvas
          ..drawCircle(Offset(centerX, centerY), centerX - _padding,
              paint..color = Colors.red)
          ..drawPath(
              Path()
                ..moveTo(padding, centerY)
                ..lineTo(size.width - padding, centerY),
              paint
                ..color = Colors.white
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1);
        break;
      case TAvatarUserPresence.offline:
        final padding = size.width / 6;
        canvas
          ..drawCircle(
              Offset(centerX, centerY),
              centerX - _padding,
              paint
                ..color = Colors.grey.shade600
                ..style = PaintingStyle.fill)
          ..drawCircle(Offset(centerX, centerY), centerX - _padding * 2,
              paint..color = Colors.white)
          ..drawPath(
              Path()
                ..moveTo(centerX - padding, centerY - padding)
                ..lineTo(centerX + padding, centerY + padding)
                ..moveTo(centerX - padding, centerY + padding)
                ..lineTo(centerX + padding, centerY - padding),
              paint
                ..color = Colors.grey.shade600
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1);
        break;
      case TAvatarUserPresence.none:
        throw ArgumentError('presence must be set');
    }
  }

  @override
  bool shouldRepaint(TAvatarUserPresencePainter oldDelegate) =>
      oldDelegate.presence != presence;
}
