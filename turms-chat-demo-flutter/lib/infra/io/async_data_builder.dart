import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

typedef AsyncWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncValue<T> snapshot);

class TAsyncDataBuilder<T> extends StatelessWidget {
  const TAsyncDataBuilder(
      {super.key, required this.future, required this.builder});

  final Future<T?> future;
  final AsyncWidgetBuilder<T?> builder;

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return builder(
                  context,
                  AsyncValue.error(snapshot.error!,
                      snapshot.stackTrace ?? StackTrace.current));
            } else {
              return builder(context, AsyncValue.data(snapshot.data));
            }
          }
          return builder(context, const AsyncValue.loading());
        },
      );
}
