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

  String constCaseToCamelCase() {
    final parts = toLowerCase().split('_');
    final camelCase = StringBuffer(parts[0]);
    final partCount = parts.length;
    for (var i = 1; i < partCount; i++) {
      final part = parts[i];
      camelCase
        ..write(part[0].toUpperCase())
        ..write(part.substring(1));
    }
    return camelCase.toString();
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension ListExtensions<T> on List<T> {
  void swap(int index1, int index2) {
    if (index1 != index2) {
      final tmp1 = this[index1];
      this[index1] = this[index2];
      this[index2] = tmp1;
    }
  }

  void replace(T oldElement, T newElement) {
    final index = indexWhere((element) => element == oldElement);
    if (index != -1) {
      this[index] = newElement;
    }
  }
}