import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/user/models/contact.dart';
import '../../../components/t_avatar/t_avatar.dart';
import '../../../components/t_button/t_text_button.dart';
import '../../../components/t_list_tile/t_list_tile.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../themes/theme_config.dart';
import 'new_relationship_page_view.dart';

class RelationshipInfoTile extends ConsumerWidget {
  const RelationshipInfoTile(
      {super.key,
      required this.isGroup,
      required this.contact,
      required this.onTap});

  final bool isGroup;
  final Contact contact;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);

    return TListTile(
        backgroundColor: ThemeConfig.conversationBackgroundColor,
        hoveredBackgroundColor: ThemeConfig.conversationHoveredBackgroundColor,
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: safeAreaPaddingHorizontal),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          TAvatar(name: contact.name, image: contact.image),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: Text(
            contact.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          )),
          const SizedBox(
            width: 12,
          ),
          TTextButton(
              text: isGroup
                  ? appLocalizations.joinGroup
                  : appLocalizations.addContact,
              containerPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              onTap: onTap),
        ]));
  }
}
