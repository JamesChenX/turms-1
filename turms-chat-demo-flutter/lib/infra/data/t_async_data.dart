class TAsyncData<T> {
  T? lastValue;
  bool isLoading = false;
  Exception? lastException;

  bool get isInitialized => lastValue != null;
}
