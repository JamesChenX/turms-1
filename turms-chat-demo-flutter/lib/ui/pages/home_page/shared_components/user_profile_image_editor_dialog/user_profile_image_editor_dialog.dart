import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../domain/user/models/index.dart';
import '../../../../../infra/io/file_utils.dart';
import '../../../../../infra/io/io_extensions.dart';
import '../../../../../infra/units/math_extensions.dart';
import '../../../../components/index.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';

const _allowedExtensions = ['png', 'jpg', 'jpeg'];
const _imageSize = 300.0;

class UserProfileImageEditorDialog extends ConsumerStatefulWidget {
  const UserProfileImageEditorDialog({super.key, required this.user});

  final User user;

  @override
  ConsumerState<UserProfileImageEditorDialog> createState() =>
      _UserProfileImageEditorDialogState();
}

class _UserProfileImageEditorDialogState
    extends ConsumerState<UserProfileImageEditorDialog> {
  ImageProvider? _selectedImage;
  bool flipX = false;
  bool flipY = false;
  double angle = 0;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.user.image;
  }

  @override
  void dispose() {
    _selectedImage?.evict(cache: PaintingBinding.instance.imageCache);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final selectedImage = _selectedImage;
    final enableOperations = selectedImage != null;

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
              ClipRRect(
                borderRadius: ThemeConfig.borderRadius4,
                child: SizedBox(
                    width: _imageSize,
                    height: _imageSize,
                    child: selectedImage == null
                        ? TAvatar(
                            name: widget.user.name,
                            textSize: 125,
                          )
                        : DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Colors.black26,
                            ),
                            child: Stack(
                              children: [
                                Transform.flip(
                                  flipX: flipX,
                                  flipY: flipY,
                                  child: Transform.rotate(
                                    angle: angle,
                                    child: Image(
                                      image: selectedImage,
                                      width: _imageSize,
                                      height: _imageSize,
                                      fit: BoxFit.contain,
                                      // If false, the image widget will blink
                                      // as the image loads,
                                      // while the image is loaded from the memory or filesystem,
                                      // it should be loaded very quickly.
                                      // so we set it to true to avoiding blinking.
                                      gaplessPlayback: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(appLocalizations.brightness),
                        const Text('50%'),
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
                        TIconButton.outlined(
                          iconData: Symbols.rotate_left_rounded,
                          containerSize: const Size.square(32),
                          tooltip: appLocalizations.rotateLeft,
                          disabled: !enableOperations,
                          onTap: () {
                            angle -= 90.degreesToRadians();
                            setState(() {});
                          },
                        ),
                        TIconButton.outlined(
                          iconData: Symbols.rotate_right_rounded,
                          containerSize: const Size.square(32),
                          tooltip: appLocalizations.rotateRight,
                          disabled: !enableOperations,
                          onTap: () {
                            angle += 90.degreesToRadians();
                            setState(() {});
                          },
                        ),
                        TIconButton.outlined(
                          iconData: Symbols.flip_rounded,
                          containerSize: const Size.square(32),
                          tooltip: appLocalizations.flipHorizontally,
                          disabled: !enableOperations,
                          onTap: () {
                            flipX = !flipX;
                            setState(() {});
                          },
                        ),
                        TIconButton.outlined(
                          iconData: Symbols.flip_rounded,
                          containerSize: const Size.square(32),
                          iconRotate: 90.degreesToRadians(),
                          tooltip: appLocalizations.flipVertically,
                          disabled: !enableOperations,
                          onTap: () {
                            flipY = !flipY;
                            setState(() {});
                          },
                        ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TTextButton(
              containerPadding: ThemeConfig.paddingV4H8,
              text: appLocalizations.selectProfileImage,
              onTap: () async {
                final result = await FileUtils.pickFile(
                    allowedExtensions: _allowedExtensions,
                    withReadStream: true);
                if (result?.isSinglePick ?? false) {
                  final file = result!.files[0];
                  final bytes = await file.readStream?.toFuture();
                  if ((bytes?.length ?? 0) > 0 &&
                      _allowedExtensions.contains(file.extension)) {
                    unawaited(_selectedImage?.evict(
                        cache: PaintingBinding.instance.imageCache));
                    _selectedImage = ResizeImage(MemoryImage(bytes!),
                        width: _imageSize.toInt(),
                        height: _imageSize.toInt(),
                        policy: ResizeImagePolicy.fit);
                    setState(() {});
                  }
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TTextButton.outlined(
                text: appLocalizations.cancel,
                containerPadding: ThemeConfig.paddingV4H8,
                containerWidth: 72,
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
                containerPadding: ThemeConfig.paddingV4H8,
                containerWidth: 72,
                onTap: () {
                  // TODO
                },
                // onTap: appLocalizations.confirm,
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ],
      );
}

Future<void> showUserProfileImageEditorDialog(
        BuildContext context, User user) =>
    showSimpleTDialog(
      routeName: '/user-profile-image-dialog',
      context: context,
      width: 520,
      height: 440,
      child: UserProfileImageEditorDialog(
        user: user,
      ),
    );
