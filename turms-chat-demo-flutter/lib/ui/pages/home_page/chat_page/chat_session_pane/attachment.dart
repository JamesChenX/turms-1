import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../components/t_button/t_icon_button.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';

class Attachment extends ConsumerStatefulWidget {
  const Attachment(
      {super.key,
      required this.fileName,
      required this.onRemoveAttachmentTapped});

  final String fileName;
  final void Function() onRemoveAttachmentTapped;

  @override
  ConsumerState<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends ConsumerState<Attachment> {
  bool isContainerHovered = false;
  bool isCloseHovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isContainerHovered = true),
        onExit: (_) => setState(() => isContainerHovered = false),
        child: GestureDetector(
          onTap: () {},
          child: AnimatedContainer(
            width: 300,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: isContainerHovered
                  ? ThemeConfig.messageAttachmentColorHovered
                  : ThemeConfig.messageAttachmentColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(1, 1),
                    blurRadius: 2)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Symbols.file_present_rounded, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.fileName,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(width: 8),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => isCloseHovered = true),
                  onExit: (_) => setState(() => isCloseHovered = false),
                  child: TIconButton(
                      iconData: Symbols.close_rounded,
                      iconWeight: isCloseHovered ? 700 : 400,
                      tooltip:
                          ref.watch(appLocalizationsViewModel).removeAttachment,
                      onTap: widget.onRemoveAttachmentTapped),
                )
              ],
            ),
          ),
        ),
      );
}
