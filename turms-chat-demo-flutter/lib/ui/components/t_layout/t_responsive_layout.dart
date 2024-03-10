import 'package:flutter/widgets.dart';

class TResponsiveLayout extends StatelessWidget {
  final Widget portraitLayoutContent;
  final Widget landscapeLayoutContent;

  const TResponsiveLayout({
    Key? key,
    required this.portraitLayoutContent,
    required this.landscapeLayoutContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return landscapeLayoutContent;
          }
          return portraitLayoutContent;
        },
      );
}
