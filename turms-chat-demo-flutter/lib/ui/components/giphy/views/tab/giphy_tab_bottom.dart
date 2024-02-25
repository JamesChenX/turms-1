import 'package:flutter/material.dart';

class GiphyTabBottom extends StatelessWidget {
  const GiphyTabBottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: Center(
          child: _buildGiphyLogo(context),
        ),
      );

  Widget _buildGiphyLogo(BuildContext context) {
    final logoPath = Theme.of(context).brightness == Brightness.light
        ? 'assets/images/powered_by_giphy_dark.png'
        : 'assets/images/powered_by_giphy_light.png';

    return Container(
      width: double.maxFinite,
      height: 15,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(logoPath),
        ),
      ),
    );
  }
}
