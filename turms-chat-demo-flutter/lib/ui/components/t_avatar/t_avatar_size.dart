part of 't_avatar.dart';

enum TAvatarSize {
  small(30),
  medium(40),
  large(60);

  const TAvatarSize(this.containerSize)
      : textSize = containerSize * 0.5,
        iconSize = containerSize * 0.75;

  final double containerSize;
  final double textSize;
  final double iconSize;
}