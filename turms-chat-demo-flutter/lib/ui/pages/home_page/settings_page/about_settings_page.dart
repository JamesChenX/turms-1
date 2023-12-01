import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../components/components.dart';

class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('Version'),
              SizedBox(
                width: 32,
              ),
              Column(children: [
                Text('0.0.1'),
                TTextButton(text: 'Update', onPressed: () {})
              ]),
            ],
          ),
          Row(
            children: [
              Text('GitHub'),
              SizedBox(
                width: 32,
              ),
              TTextButton(
                  text: 'github.com/turms-im/turms',
                  backgroundColor: Colors.transparent,
                  backgroundHoverColor: Colors.transparent,
                  textStyle: TextStyle(color: Colors.blue),
                  onPressed: () {
                    launchUrlString('https://github.com/turms-im/turms');
                  })
            ],
          )
        ],
      ),
    );
  }
}