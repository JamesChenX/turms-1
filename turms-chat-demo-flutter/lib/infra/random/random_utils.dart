import 'dart:math';

class RandomUtils {
  RandomUtils._();

  static final _random = Random();
  static const _chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  static bool nextBool() => _random.nextBool();

  static String generateRandomString(int minLength, int maxLength) {
    final length = _random.nextInt(maxLength - minLength + 1) + minLength;
    final stringBuffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      final randomIndex = _random.nextInt(_chars.length);
      stringBuffer.write(_chars[randomIndex]);
    }
    return stringBuffer.toString();
  }
}