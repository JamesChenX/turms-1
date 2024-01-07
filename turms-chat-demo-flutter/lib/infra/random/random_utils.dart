import 'dart:math';

// dart web (2^32)
const int _intMaxValue = 4294967296;
const _chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
const _charCount = _chars.length;

class RandomUtils {
  RandomUtils._();

  static final _random = Random();

  static bool nextBool() => _random.nextBool();

  static int nextInt() => _random.nextInt(_intMaxValue);

  static String nextString(int length) {
    final stringBuffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      final randomIndex = _random.nextInt(_charCount);
      stringBuffer.write(_chars[randomIndex]);
    }
    return stringBuffer.toString();
  }

  static String generateRandomString(int minLength, int maxLength) {
    final length = _random.nextInt(maxLength - minLength + 1) + minLength;
    final stringBuffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      final randomIndex = _random.nextInt(_charCount);
      stringBuffer.write(_chars[randomIndex]);
    }
    return stringBuffer.toString();
  }
}