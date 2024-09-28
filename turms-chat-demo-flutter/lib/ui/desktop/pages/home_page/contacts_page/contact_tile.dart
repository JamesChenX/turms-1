import 'package:flutter/widgets.dart';

import '../../../../../domain/user/models/contact.dart';
import '../../../components/t_avatar/t_avatar.dart';
import '../../../components/t_list_tile/t_list_tile.dart';

class ContactTile extends StatefulWidget {
  const ContactTile(
      {super.key,
      required this.contact,
      required this.nameTextSpans,
      required this.isSearchMode,
      required this.selected,
      required this.onTap});

  final Contact contact;
  final List<TextSpan> nameTextSpans;
  final bool isSearchMode;
  final bool selected;
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
        focused: widget.selected,
        padding:
            // use more right padding to reserve space for scrollbar
            const EdgeInsets.only(left: 10, right: 14, top: 12, bottom: 12),
        child: Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: [
          TAvatar(
            name: contact.name,
            image: contact.image,
            icon: contact.icon,
          ),
          Expanded(
              child: Text.rich(
            TextSpan(
                children: widget.isSearchMode
                    ? widget.nameTextSpans
                    : [
                        TextSpan(
                          text: contact.name,
                        )
                      ]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ))
        ]));
  }
}