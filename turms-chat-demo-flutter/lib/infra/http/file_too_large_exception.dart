class FileTooLargeException implements Exception {
  FileTooLargeException(this.path, this.allowedBytes, this.actualBytes);

  final String path;
  final int allowedBytes;
  final int actualBytes;
}
