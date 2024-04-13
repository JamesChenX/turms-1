class MessageMediaFile {
  MessageMediaFile(
      {required this.originalMediaUrl,
      required this.originalMediaPath,
      required this.originalMediaBytes,
      required this.thumbnailImageUrl,
      required this.thumbnailImagePath,
      required this.thumbnailBytes});

  /// A media message must specify the original media URL.
  /// So this is non-nullable.
  final String originalMediaUrl;

  /// If the user hasn't viewed the original media,
  /// we don't need to download the original media,
  /// so this is non-nullable.
  final String? originalMediaPath;

  /// If the user hasn't viewed the original media,
  /// we don't need to download the original media,
  /// so this is non-nullable.
  final List<int>? originalMediaBytes;

  /// A media message can not specify the thumbnail image URL.
  /// So this is nullable.
  final String? thumbnailImageUrl;

  /// A media message always display the thumbnail.
  /// So this is non-nullable.
  final String thumbnailImagePath;

  /// A media message always display the thumbnail.
  /// So this is non-nullable.
  final List<int> thumbnailBytes;
}
