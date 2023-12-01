extension BoolExtensions on bool {
  String toIntString() => this ? '1' : '0';
}

extension StringExtensions on String {
  bool? toBool() => switch (this) {
        '1' => true,
        '0' => false,
        _ => null,
      };

  (String, String) splitFirst(String separator) {
    final separatorPosition = indexOf(separator);
    if (separatorPosition == -1) {
      return (this, '');
    }
    return (
      substring(0, separatorPosition),
      substring(separatorPosition + separator.length)
    );
  }

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;
}