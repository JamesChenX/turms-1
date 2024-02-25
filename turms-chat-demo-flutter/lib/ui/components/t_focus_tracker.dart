import 'package:flutter/material.dart';

class TFocusTracker extends StatefulWidget {
  const TFocusTracker({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<TFocusTracker> createState() => _TFocusTrackerState();
}

class _TFocusTrackerState extends State<TFocusTracker> {
  static OverlayState? _overlayState;
  static OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(onFocusChanged);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(onFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void removeOverlayEntry() {
    final overlayEntry = _overlayEntry;
    if (overlayEntry != null) {
      overlayEntry.remove();
      _overlayEntry = null;
    }
  }

  void onFocusChanged() {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null) {
      removeOverlayEntry();
      return;
    }
    final rect = focus.rect;
    removeOverlayEntry();
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      final parentFocusDebugLabel = focus.parent?.debugLabel ??
          focus.parent?.context?.widget.runtimeType.toString() ??
          '';
      final focusDebugLabel = focus.debugLabel ??
          focus.context?.widget.runtimeType.toString() ??
          '';
      return Positioned(
        left: rect.left,
        top: rect.top,
        child: IgnorePointer(
          child: UnconstrainedBox(
            child: SizedBox(
                width: rect.width,
                height: rect.height,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Center(
                      child: Text(
                          'parent: $parentFocusDebugLabel, focus: $focusDebugLabel',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700))),
                )),
          ),
        ),
      );
    });
    _overlayState!.insert(_overlayEntry!);
  }
}
