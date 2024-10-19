import 'package:flutter/material.dart';

import 'colors.dart';
import 'fonts.dart';
import 'sizes.dart';
import 'styles.dart';

// TODO: we need to provide different font styles for different fonts
// as even using the same font properties, the text will display quite different.
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.themeMode,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.infoColor,
    required this.dangerColor,
    required this.dangerTextStyle,
    required this.highlightTextStyle,
    required this.maskColor,
    required this.avatarIconColor,
    required this.avatarBackgroundColor,
    required this.checkboxColor,
    required this.checkboxTextStyle,
    required this.menuDecoration,
    required this.menuItemColor,
    required this.menuItemHoveredColor,
    required this.menuItemTextStyle,
    required this.popupDecoration,
    required this.tabTextStyle,
    required this.toastDecoration,
    required this.homePageBackgroundColor,
    required this.subNavigationRailSearchBarBackgroundColor,
    required this.subNavigationRailLoadingIndicatorBackgroundColor,
    required this.subNavigationRailDividerColor,
    required this.chatSessionPaneDividerColor,
    required this.chatSessionDetailsDrawerBackgroundColor,
    required this.chatSessionMessageTextStyle,
    required this.chatSessionMessageEmojiTextStyle,
    required this.conversationBackgroundColor,
    required this.conversationBackgroundHighlightedColor,
    required this.conversationBackgroundHoveredColor,
    required this.conversationBackgroundFocusedColor,
    required this.conversationTileMessageTextStyle,
    required this.conversationTileTimestampTextStyle,
    required this.messageAttachmentColor,
    required this.messageAttachmentHoveredColor,
    required this.messageBubbleErrorIconBackgroundColor,
    required this.messageBubbleErrorIconColor,
    required this.fileTableTitleTextStyle,
    required this.fileTableCellTextStyle,
    required this.settingPageSubNavigationRailDividerColor,
    required this.settingsPageSubNavigationRailTitleTextStyle,
    required this.descriptionTextStyle,
    required this.linkTextStyle,
    required this.linkHoveredTextStyle,
  });

  static final light = AppThemeExtension(
      themeMode: ThemeMode.light,
      successColor: AppColors.green6,
      warningColor: AppColors.gold6,
      errorColor: Colors.red,
      infoColor: AppColors.blue6,
      dangerColor: Colors.red,
      dangerTextStyle: const TextStyle(color: Colors.red),
      highlightTextStyle: const TextStyle(color: Colors.red),
      maskColor: Colors.black54,
      avatarIconColor: Colors.white,
      avatarBackgroundColor: const Color.fromARGB(255, 117, 117, 117),
      checkboxColor: AppColors.gray6,
      checkboxTextStyle:
          const TextStyle(color: Color(0xA6000000), fontSize: 16),
      menuDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Sizes.borderRadiusCircular2,
        border: Border.all(color: Colors.grey.shade400),
        // border: Border.all(color: AppColors.gray5),
        boxShadow: Styles.boxShadow,
      ),
      menuItemTextStyle: const TextStyle(
        fontSize: 12,
      ),
      menuItemColor: Colors.white,
      menuItemHoveredColor: Colors.grey.shade300,
      popupDecoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: Sizes.borderRadiusCircular4,
          boxShadow: Styles.boxShadow),
      tabTextStyle: const TextStyle(color: Color.fromARGB(255, 89, 89, 89)),
      toastDecoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: Sizes.borderRadiusCircular8,
        boxShadow: Styles.boxShadow,
      ),
      homePageBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
      subNavigationRailSearchBarBackgroundColor:
          const Color.fromARGB(255, 247, 247, 247),
      subNavigationRailLoadingIndicatorBackgroundColor:
          const Color.fromARGB(255, 237, 237, 237),
      subNavigationRailDividerColor: const Color.fromARGB(255, 213, 213, 213),
      chatSessionPaneDividerColor: const Color.fromARGB(255, 231, 231, 231),
      chatSessionDetailsDrawerBackgroundColor: Colors.white,
      chatSessionMessageTextStyle: const TextStyle(
        fontSize: 14,
      ),
      chatSessionMessageEmojiTextStyle: TextStyle(
          fontSize: 20,
          fontFamily: Fonts.emojiFontFamily,
          fontFamilyFallback: Fonts.emojiFontFamilyFallback),
      conversationBackgroundColor: const Color.fromARGB(255, 233, 233, 233),
      conversationBackgroundHighlightedColor:
          const Color.fromARGB(255, 210, 210, 210),
      conversationBackgroundHoveredColor:
          const Color.fromARGB(255, 218, 218, 218),
      conversationBackgroundFocusedColor:
          const Color.fromARGB(255, 200, 200, 200),
      conversationTileMessageTextStyle: const TextStyle(
        color: AppColors.gray7,
        fontSize: 12,
      ),
      conversationTileTimestampTextStyle:
          const TextStyle(color: AppColors.gray7, fontSize: 12),
      messageAttachmentColor: const Color.fromARGB(255, 250, 250, 250),
      messageAttachmentHoveredColor: Colors.white,
      messageBubbleErrorIconBackgroundColor:
          const Color.fromARGB(255, 250, 81, 81),
      messageBubbleErrorIconColor: Colors.white,
      fileTableTitleTextStyle:
          const TextStyle(color: Color.fromARGB(255, 51, 51, 51)),
      fileTableCellTextStyle:
          const TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
      settingPageSubNavigationRailDividerColor:
          const Color.fromARGB(255, 240, 240, 240),
      settingsPageSubNavigationRailTitleTextStyle:
          const TextStyle(fontSize: 16, color: Colors.grey),
      descriptionTextStyle: const TextStyle(
        // TODO: Or Color(0xA6000000)?
        color: Colors.grey,
      ),
      linkTextStyle: const TextStyle(
        color: AppColors.blue5,
      ),
      linkHoveredTextStyle: const TextStyle(
        color: AppColors.blue6,
      ));

  static final dark = AppThemeExtension(
      themeMode: ThemeMode.dark,
      successColor: AppColors.green6,
      warningColor: AppColors.gold6,
      errorColor: Colors.red,
      infoColor: AppColors.blue6,
      dangerColor: Colors.red,
      dangerTextStyle: const TextStyle(color: Colors.red),
      highlightTextStyle: const TextStyle(color: Colors.red),
      maskColor: Colors.white70,
      avatarIconColor: Colors.black,
      avatarBackgroundColor: const Color.fromARGB(255, 117, 117, 117),
      checkboxColor: AppColors.gray6,
      checkboxTextStyle:
          const TextStyle(color: Color(0xA6000000), fontSize: 16),
      menuDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Sizes.borderRadiusCircular2,
        border: Border.all(color: Colors.grey.shade400),
        boxShadow: Styles.boxShadow,
      ),
      menuItemColor: Colors.white,
      menuItemHoveredColor: Colors.grey.shade300,
      menuItemTextStyle: const TextStyle(
        fontSize: 12,
      ),
      popupDecoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: Sizes.borderRadiusCircular4,
          boxShadow: Styles.boxShadow),
      tabTextStyle: const TextStyle(color: Color.fromARGB(255, 89, 89, 89)),
      toastDecoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: Sizes.borderRadiusCircular8,
        boxShadow: Styles.boxShadow,
      ),
      homePageBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
      subNavigationRailSearchBarBackgroundColor:
          const Color.fromARGB(255, 247, 247, 247),
      subNavigationRailLoadingIndicatorBackgroundColor:
          const Color.fromARGB(255, 237, 237, 237),
      subNavigationRailDividerColor: const Color.fromARGB(255, 213, 213, 213),
      chatSessionPaneDividerColor: const Color.fromARGB(255, 231, 231, 231),
      chatSessionDetailsDrawerBackgroundColor: Colors.black87,
      chatSessionMessageTextStyle: const TextStyle(
        fontSize: 14,
      ),
      chatSessionMessageEmojiTextStyle: TextStyle(
          fontSize: 20,
          fontFamily: Fonts.emojiFontFamily,
          fontFamilyFallback: Fonts.emojiFontFamilyFallback),
      conversationBackgroundColor: const Color.fromARGB(255, 233, 233, 233),
      conversationBackgroundHighlightedColor:
          const Color.fromARGB(255, 210, 210, 210),
      conversationBackgroundHoveredColor:
          const Color.fromARGB(255, 218, 218, 218),
      conversationBackgroundFocusedColor:
          const Color.fromARGB(255, 200, 200, 200),
      conversationTileMessageTextStyle: const TextStyle(
        color: AppColors.gray7,
        fontSize: 12,
      ),
      conversationTileTimestampTextStyle:
          const TextStyle(color: AppColors.gray7, fontSize: 12),
      messageAttachmentColor: const Color.fromARGB(255, 250, 250, 250),
      messageAttachmentHoveredColor: Colors.white,
      messageBubbleErrorIconBackgroundColor:
          const Color.fromARGB(255, 250, 81, 81),
      messageBubbleErrorIconColor: Colors.white,
      fileTableTitleTextStyle:
          const TextStyle(color: Color.fromARGB(255, 51, 51, 51)),
      fileTableCellTextStyle:
          const TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
      settingPageSubNavigationRailDividerColor:
          const Color.fromARGB(255, 240, 240, 240),
      settingsPageSubNavigationRailTitleTextStyle:
          const TextStyle(fontSize: 16, color: Colors.grey),
      descriptionTextStyle: const TextStyle(
        color: Colors.grey,
      ),
      linkTextStyle: const TextStyle(
        color: AppColors.blue5,
      ),
      linkHoveredTextStyle: const TextStyle(
        color: AppColors.blue6,
      ));

  final ThemeMode themeMode;

  // Semantic colors/styles
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final Color infoColor;

  final Color dangerColor;
  final TextStyle dangerTextStyle;
  final TextStyle highlightTextStyle;

  // Background colors
  final Color maskColor;

  // Component colors/styles
  final Color avatarIconColor;
  final Color avatarBackgroundColor;

  final Color checkboxColor;
  final TextStyle checkboxTextStyle;

  final BoxDecoration menuDecoration;
  final Color menuItemColor;
  final Color menuItemHoveredColor;
  final TextStyle menuItemTextStyle;

  final BoxDecoration popupDecoration;

  final TextStyle tabTextStyle;

  final BoxDecoration toastDecoration;

  // Page colors/styles
  final Color homePageBackgroundColor;
  final Color subNavigationRailSearchBarBackgroundColor;
  final Color subNavigationRailLoadingIndicatorBackgroundColor;
  final Color subNavigationRailDividerColor;

  final Color chatSessionPaneDividerColor;
  final Color chatSessionDetailsDrawerBackgroundColor;
  final TextStyle chatSessionMessageTextStyle;
  final TextStyle chatSessionMessageEmojiTextStyle;

  final Color conversationBackgroundColor;
  final Color conversationBackgroundHighlightedColor;
  final Color conversationBackgroundHoveredColor;
  final Color conversationBackgroundFocusedColor;

  final TextStyle conversationTileMessageTextStyle;
  final TextStyle conversationTileTimestampTextStyle;

  final Color messageAttachmentColor;
  final Color messageAttachmentHoveredColor;
  final Color messageBubbleErrorIconBackgroundColor;
  final Color messageBubbleErrorIconColor;

  final TextStyle fileTableTitleTextStyle;
  final TextStyle fileTableCellTextStyle;

  final Color settingPageSubNavigationRailDividerColor;
  final TextStyle settingsPageSubNavigationRailTitleTextStyle;

  // Text styles
  final TextStyle descriptionTextStyle;
  final TextStyle linkTextStyle;
  final TextStyle linkHoveredTextStyle;

  @override
  AppThemeExtension copyWith({
    ThemeMode? themeMode,
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
    Color? infoColor,
    Color? dangerColor,
    TextStyle? dangerTextStyle,
    TextStyle? highlightTextStyle,
    Color? maskColor,
    Color? avatarIconColor,
    Color? avatarBackgroundColor,
    Color? checkboxColor,
    TextStyle? checkboxTextStyle,
    BoxDecoration? menuDecoration,
    Color? menuItemColor,
    Color? menuItemHoveredColor,
    TextStyle? menuItemTextStyle,
    BoxDecoration? popupDecoration,
    TextStyle? tabTextStyle,
    BoxDecoration? toastDecoration,
    Color? homePageBackgroundColor,
    Color? subNavigationRailSearchBarBackgroundColor,
    Color? subNavigationRailLoadingIndicatorBackgroundColor,
    Color? subNavigationRailDividerColor,
    Color? chatSessionPaneDividerColor,
    Color? chatSessionDetailsDrawerBackgroundColor,
    TextStyle? chatSessionMessageEditorTextStyle,
    TextStyle? chatSessionMessageEditorEmojiTextStyle,
    Color? conversationBackgroundColor,
    Color? conversationBackgroundHighlightedColor,
    Color? conversationBackgroundHoveredColor,
    Color? conversationBackgroundFocusedColor,
    TextStyle? conversationTileMessageTextStyle,
    TextStyle? conversationTileTimestampTextStyle,
    Color? messageAttachmentColor,
    Color? messageAttachmentHoveredColor,
    Color? messageBubbleErrorIconBackgroundColor,
    Color? messageBubbleErrorIconColor,
    TextStyle? fileTableTitleTextStyle,
    TextStyle? fileTableCellTextStyle,
    Color? settingPageSubNavigationRailDividerColor,
    TextStyle? settingsPageSubNavigationRailTitleTextStyle,
    TextStyle? descriptionTextStyle,
    TextStyle? linkTextStyle,
    TextStyle? linkHoveredTextStyle,
  }) =>
      AppThemeExtension(
        themeMode: themeMode ?? this.themeMode,
        successColor: successColor ?? this.successColor,
        warningColor: warningColor ?? this.warningColor,
        errorColor: errorColor ?? this.errorColor,
        infoColor: infoColor ?? this.infoColor,
        dangerColor: dangerColor ?? this.dangerColor,
        dangerTextStyle: dangerTextStyle ?? this.dangerTextStyle,
        highlightTextStyle: highlightTextStyle ?? this.highlightTextStyle,
        maskColor: maskColor ?? this.maskColor,
        avatarIconColor: avatarIconColor ?? this.avatarIconColor,
        avatarBackgroundColor:
            avatarBackgroundColor ?? this.avatarBackgroundColor,
        checkboxColor: checkboxColor ?? this.checkboxColor,
        checkboxTextStyle: checkboxTextStyle ?? this.checkboxTextStyle,
        menuDecoration: menuDecoration ?? this.menuDecoration,
        menuItemColor: menuItemColor ?? this.menuItemColor,
        menuItemHoveredColor: menuItemHoveredColor ?? this.menuItemHoveredColor,
        menuItemTextStyle: menuItemTextStyle ?? this.menuItemTextStyle,
        popupDecoration: popupDecoration ?? this.popupDecoration,
        tabTextStyle: tabTextStyle ?? this.tabTextStyle,
        toastDecoration: toastDecoration ?? this.toastDecoration,
        homePageBackgroundColor:
            homePageBackgroundColor ?? this.homePageBackgroundColor,
        subNavigationRailSearchBarBackgroundColor:
            subNavigationRailSearchBarBackgroundColor ??
                this.subNavigationRailSearchBarBackgroundColor,
        subNavigationRailLoadingIndicatorBackgroundColor:
            subNavigationRailLoadingIndicatorBackgroundColor ??
                this.subNavigationRailLoadingIndicatorBackgroundColor,
        subNavigationRailDividerColor:
            subNavigationRailDividerColor ?? this.subNavigationRailDividerColor,
        chatSessionPaneDividerColor:
            chatSessionPaneDividerColor ?? this.chatSessionPaneDividerColor,
        chatSessionDetailsDrawerBackgroundColor:
            chatSessionDetailsDrawerBackgroundColor ??
                this.chatSessionDetailsDrawerBackgroundColor,
        chatSessionMessageTextStyle:
            chatSessionMessageEditorTextStyle ?? chatSessionMessageTextStyle,
        chatSessionMessageEmojiTextStyle:
            chatSessionMessageEditorEmojiTextStyle ??
                chatSessionMessageEmojiTextStyle,
        conversationBackgroundColor:
            conversationBackgroundColor ?? this.conversationBackgroundColor,
        conversationBackgroundHighlightedColor:
            conversationBackgroundHighlightedColor ??
                this.conversationBackgroundHighlightedColor,
        conversationBackgroundHoveredColor:
            conversationBackgroundHoveredColor ??
                this.conversationBackgroundHoveredColor,
        conversationBackgroundFocusedColor:
            conversationBackgroundFocusedColor ??
                this.conversationBackgroundFocusedColor,
        conversationTileMessageTextStyle: conversationTileMessageTextStyle ??
            this.conversationTileMessageTextStyle,
        conversationTileTimestampTextStyle:
            conversationTileTimestampTextStyle ??
                this.conversationTileTimestampTextStyle,
        messageAttachmentColor:
            messageAttachmentColor ?? this.messageAttachmentColor,
        messageAttachmentHoveredColor:
            messageAttachmentHoveredColor ?? this.messageAttachmentHoveredColor,
        messageBubbleErrorIconBackgroundColor:
            messageBubbleErrorIconBackgroundColor ??
                this.messageBubbleErrorIconBackgroundColor,
        messageBubbleErrorIconColor:
            messageBubbleErrorIconColor ?? this.messageBubbleErrorIconColor,
        fileTableTitleTextStyle:
            fileTableTitleTextStyle ?? this.fileTableTitleTextStyle,
        fileTableCellTextStyle:
            fileTableCellTextStyle ?? this.fileTableCellTextStyle,
        settingPageSubNavigationRailDividerColor:
            settingPageSubNavigationRailDividerColor ??
                this.settingPageSubNavigationRailDividerColor,
        settingsPageSubNavigationRailTitleTextStyle:
            settingsPageSubNavigationRailTitleTextStyle ??
                this.settingsPageSubNavigationRailTitleTextStyle,
        descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
        linkTextStyle: linkTextStyle ?? this.linkTextStyle,
        linkHoveredTextStyle: linkHoveredTextStyle ?? this.linkHoveredTextStyle,
      );

  @override
  AppThemeExtension lerp(covariant AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      themeMode: t < 0.5 ? themeMode : other.themeMode,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      infoColor: Color.lerp(infoColor, other.infoColor, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      dangerTextStyle:
          TextStyle.lerp(dangerTextStyle, other.dangerTextStyle, t)!,
      highlightTextStyle:
          TextStyle.lerp(highlightTextStyle, other.highlightTextStyle, t)!,
      maskColor: Color.lerp(maskColor, other.maskColor, t)!,
      avatarIconColor: Color.lerp(avatarIconColor, other.avatarIconColor, t)!,
      avatarBackgroundColor:
          Color.lerp(avatarBackgroundColor, other.avatarBackgroundColor, t)!,
      checkboxColor: Color.lerp(checkboxColor, other.checkboxColor, t)!,
      checkboxTextStyle:
          TextStyle.lerp(checkboxTextStyle, other.checkboxTextStyle, t)!,
      menuDecoration:
          BoxDecoration.lerp(menuDecoration, other.menuDecoration, t)!,
      menuItemColor: Color.lerp(menuItemColor, other.menuItemColor, t)!,
      menuItemHoveredColor:
          Color.lerp(menuItemHoveredColor, other.menuItemHoveredColor, t)!,
      menuItemTextStyle:
          TextStyle.lerp(menuItemTextStyle, other.menuItemTextStyle, t)!,
      popupDecoration:
          BoxDecoration.lerp(popupDecoration, other.popupDecoration, t)!,
      tabTextStyle: TextStyle.lerp(tabTextStyle, other.tabTextStyle, t)!,
      toastDecoration:
          BoxDecoration.lerp(toastDecoration, other.toastDecoration, t)!,
      homePageBackgroundColor: Color.lerp(
          homePageBackgroundColor, other.homePageBackgroundColor, t)!,
      subNavigationRailSearchBarBackgroundColor: Color.lerp(
          subNavigationRailSearchBarBackgroundColor,
          other.subNavigationRailSearchBarBackgroundColor,
          t)!,
      subNavigationRailLoadingIndicatorBackgroundColor: Color.lerp(
          subNavigationRailLoadingIndicatorBackgroundColor,
          other.subNavigationRailLoadingIndicatorBackgroundColor,
          t)!,
      subNavigationRailDividerColor: Color.lerp(subNavigationRailDividerColor,
          other.subNavigationRailDividerColor, t)!,
      chatSessionPaneDividerColor: Color.lerp(
          chatSessionPaneDividerColor, other.chatSessionPaneDividerColor, t)!,
      chatSessionDetailsDrawerBackgroundColor: Color.lerp(
          chatSessionDetailsDrawerBackgroundColor,
          other.chatSessionDetailsDrawerBackgroundColor,
          t)!,
      chatSessionMessageTextStyle: TextStyle.lerp(
          chatSessionMessageTextStyle, other.chatSessionMessageTextStyle, t)!,
      chatSessionMessageEmojiTextStyle: TextStyle.lerp(
          chatSessionMessageEmojiTextStyle,
          other.chatSessionMessageEmojiTextStyle,
          t)!,
      conversationBackgroundColor: Color.lerp(
          conversationBackgroundColor, other.conversationBackgroundColor, t)!,
      conversationBackgroundHighlightedColor: Color.lerp(
          conversationBackgroundHighlightedColor,
          other.conversationBackgroundHighlightedColor,
          t)!,
      conversationBackgroundHoveredColor: Color.lerp(
          conversationBackgroundHoveredColor,
          other.conversationBackgroundHoveredColor,
          t)!,
      conversationBackgroundFocusedColor: Color.lerp(
          conversationBackgroundFocusedColor,
          other.conversationBackgroundFocusedColor,
          t)!,
      conversationTileMessageTextStyle: TextStyle.lerp(
          conversationTileMessageTextStyle,
          other.conversationTileMessageTextStyle,
          t)!,
      conversationTileTimestampTextStyle: TextStyle.lerp(
          conversationTileTimestampTextStyle,
          other.conversationTileTimestampTextStyle,
          t)!,
      messageAttachmentColor:
          Color.lerp(messageAttachmentColor, other.messageAttachmentColor, t)!,
      messageAttachmentHoveredColor: Color.lerp(messageAttachmentHoveredColor,
          other.messageAttachmentHoveredColor, t)!,
      messageBubbleErrorIconBackgroundColor: Color.lerp(
          messageBubbleErrorIconBackgroundColor,
          other.messageBubbleErrorIconBackgroundColor,
          t)!,
      messageBubbleErrorIconColor: Color.lerp(
          messageBubbleErrorIconColor, other.messageBubbleErrorIconColor, t)!,
      fileTableTitleTextStyle: TextStyle.lerp(
          fileTableTitleTextStyle, other.fileTableTitleTextStyle, t)!,
      fileTableCellTextStyle: TextStyle.lerp(
          fileTableCellTextStyle, other.fileTableCellTextStyle, t)!,
      settingPageSubNavigationRailDividerColor: Color.lerp(
          settingPageSubNavigationRailDividerColor,
          other.settingPageSubNavigationRailDividerColor,
          t)!,
      settingsPageSubNavigationRailTitleTextStyle: TextStyle.lerp(
          settingsPageSubNavigationRailTitleTextStyle,
          other.settingsPageSubNavigationRailTitleTextStyle,
          t)!,
      descriptionTextStyle:
          TextStyle.lerp(descriptionTextStyle, other.descriptionTextStyle, t)!,
      linkTextStyle: TextStyle.lerp(linkTextStyle, other.linkTextStyle, t)!,
      linkHoveredTextStyle:
          TextStyle.lerp(linkHoveredTextStyle, other.linkHoveredTextStyle, t)!,
    );
  }
}

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  AppThemeExtension get appThemeExtension =>
      Theme.of(this).extension<AppThemeExtension>()!;
}

extension ThemeDataExtension on ThemeData {
  AppThemeExtension get appThemeExtension => extension<AppThemeExtension>()!;
}
