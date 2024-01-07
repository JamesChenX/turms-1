part of 't_avatar.dart';

enum TAvatarSize {
  small(30, 15, 27),
  medium(40, 20, 36),
  large(60, 30, 54);

  const TAvatarSize(this.containerSize, this.textSize, this.iconSize);

  final double containerSize;
  final double textSize;
  final double iconSize;
}