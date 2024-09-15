class FileTooLargeException implements Exception {
  FileTooLargeException(this.allowedBytes, this.actualBytes);

  final int allowedBytes;
  final int actualBytes;
}