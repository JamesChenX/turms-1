import '../../../../../infra/http/file_too_large_exception.dart';

sealed class MediaFetchingStatus {}

class Downloading extends MediaFetchingStatus {
  Downloading();
}

class NotFound extends MediaFetchingStatus {
  NotFound();
}

class NetworkError extends MediaFetchingStatus {
  NetworkError(this.exception);

  Exception exception;
}

class HttpClientError extends MediaFetchingStatus {
  HttpClientError(this.exception);

  Exception exception;
}

class HttpServerError extends MediaFetchingStatus {
  HttpServerError(this.exception);

  Exception exception;
}

class MediaTooLargeError extends MediaFetchingStatus {
  MediaTooLargeError(this.exception);

  FileTooLargeException exception;
}

class DecodeError extends MediaFetchingStatus {
  DecodeError(this.exception);

  Exception exception;
}
