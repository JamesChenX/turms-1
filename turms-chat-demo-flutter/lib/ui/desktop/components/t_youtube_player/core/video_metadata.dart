class VideoMetadata {
  factory VideoMetadata.fromRawData(dynamic rawData) {
    final data = rawData as Map<String, dynamic>;
    return VideoMetadata(
      videoId: data['videoId'] as String,
      title: data['title'] as String,
      author: data['author'] as String,
      duration: Duration(
          milliseconds:
              ((data['duration'] as double? ?? 0).toDouble() * 1000).floor()),
    );
  }

  const VideoMetadata({
    this.videoId = '',
    this.title = '',
    this.author = '',
    this.duration = Duration.zero,
  });

  final String videoId;
  final String title;
  final String author;
  final Duration duration;
}
