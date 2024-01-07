import 'package:flutter/widgets.dart';

import '../../../../domain/user/models/contact.dart';
import '../../../components/t_avatar/t_avatar.dart';
import '../../../components/t_list_tile.dart';
import '../../../themes/theme_config.dart';

class ContactTile extends StatefulWidget {
  const ContactTile(
      {super.key,
      required this.contact,
      required this.focused,
      required this.onTap});

  final Contact contact;
  final bool focused;
  final GestureTapCallback onTap;

  @override
  State<StatefulWidget> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;
    return TListTile(
        onTap: widget.onTap,
        focused: widget.focused,
        backgroundColor: ThemeConfig.conversationBackgroundColor,
        focusedBackgroundColor: ThemeConfig.conversationFocusedBackgroundColor,
        hoveredBackgroundColor: ThemeConfig.conversationHoveredBackgroundColor,
        padding:
            // use more right padding to reserve space for scrollbar
            const EdgeInsets.only(left: 10, right: 14, top: 12, bottom: 12),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          TAvatar(name: contact.name, image: contact.image),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            contact.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ))
        ]));
  }
}