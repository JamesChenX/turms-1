import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../domain/user/models/index.dart';
import '../../../../components/components.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';

class UserProfileImageEditorDialog extends ConsumerWidget {
  const UserProfileImageEditorDialog({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = user.image;
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
      child: Column(
        children: [
          Text(appLocalizations.editProfileImage),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: image == null
                    ? TAvatar(
                        name: user.name,
                      )
                    : Image(image: image),
              ),
              Expanded(
                child: Column(
                  children: [
                    TTextButton(
                        padding: ThemeConfig.paddingV4H8,
                        text: appLocalizations.uploadProfileImage,
                        onTap: () {}),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(appLocalizations.brightness),
                        Text('50%'),
                      ],
                    ),
                    Slider(
                      value: 0,
                      max: 100,
                      divisions: 1,
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(appLocalizations.rotateAndFlip),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // todo: outline button
                        TIconButton(
                          iconData: Symbols.rotate_left_rounded,
                          tooltip: appLocalizations.rotateLeft,
                        ),
                        TIconButton(
                            iconData: Symbols.rotate_right_rounded,
                            addContainer: false,
                            tooltip: appLocalizations.rotateRight),
                        TIconButton(
                          iconData: Symbols.flip_rounded,
                          addContainer: false,
                          tooltip: appLocalizations.flipHorizontally,
                        ),
                        TIconButton(
                            iconData: Symbols.flip_rounded,
                            iconRotate: pi / 180 * 90,
                            addContainer: false,
                            tooltip: appLocalizations.flipVertically),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: Align(
                alignment: Alignment.bottomRight,
                child: _buildActions(context, appLocalizations)),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
          BuildContext context, AppLocalizations appLocalizations) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TTextButton.outlined(
            text: appLocalizations.cancel,
            padding: ThemeConfig.paddingV4H8,
            width: 72,
            onTap: () => Navigator.of(context).pop(),
            // onTap: createGroupPageController.close,
          ),
          const SizedBox(
            width: 16,
          ),
          TTextButton(
            // isLoading: createGroupPageController.isCreating,
            // disabled:
            //     createGroupPageController.selectedUserContactIds.length <= 1,
            text: appLocalizations.confirm,
            padding: ThemeConfig.paddingV4H8,
            width: 72,
            // onTap: appLocalizations.confirm,
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      );
}

Future<void> showUserProfileImageEditorDialog(
        BuildContext context, User user) =>
    showSimpleTDialog(
      routeName: '/user-profile-image-dialog',
      context: context,
      width: 500,
      height: 400,
      child: UserProfileImageEditorDialog(
        user: user,
      ),
    );
