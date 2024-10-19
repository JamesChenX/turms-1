part of 't_drawer.dart';

class _TDrawerRoute<T> extends PopupRoute<T> {
  _TDrawerRoute(this.child);

  final Widget child;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      RepaintBoundary(
        child: Material(
          color: Colors.transparent,
          child: _TDrawerView(
            animation: animation,
            child: child,
          ),
        ),
      );
}
