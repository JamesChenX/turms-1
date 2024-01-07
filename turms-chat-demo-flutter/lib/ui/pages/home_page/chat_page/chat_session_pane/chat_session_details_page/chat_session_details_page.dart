import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../components/t_horizontal_divider.dart';
import '../../../../../components/t_search_bar.dart';
import '../../../../../themes/theme_config.dart';

class ChatSessionDetailsPage extends ConsumerWidget {
  const ChatSessionDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const divider = THorizontalDivider();
    return SizedBox(
      width: 250,
      height: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(width: 1, color: ThemeConfig.borderDefaultColor),
            )),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text('name'),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                child: Text(
                  'intro'.padRight(200, '123test'),
                  softWrap: true,
                  maxLines: 4,
                  style: ThemeConfig.textStyleSecondary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              divider,
              const SizedBox(
                height: 8,
              ),
              CupertinoSwitch(
                value: false,
                onChanged: (value) {},
              ),
              divider,
              TSearchBar(hintText: 'search'),
              Row(
                children: [
                  Text('add new memember'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}