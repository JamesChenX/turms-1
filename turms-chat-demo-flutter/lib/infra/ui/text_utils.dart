import 'package:flutter/material.dart';

import '../built_in_types/built_in_type_helpers.dart';

class TextUtils {
  TextUtils._();

  static List<TextSpan> splitText({
    required String text,
    TextStyle? textStyle,
    required String searchText,
    TextStyle? searchTextStyle,
  }) {
    if (searchText.isBlank) {
      return [TextSpan(text: text, style: textStyle)];
    }
    final textSpans = <TextSpan>[];
    final textToMatch = text.toLowerCase();
    searchText = searchText.toLowerCase();
    var index = 0;
    while (true) {
      final searchTextIndex = textToMatch.indexOf(searchText, index);
      if (searchTextIndex == -1) {
        if (index == 0) {
          return [TextSpan(text: text, style: textStyle)];
        }
        textSpans.add(TextSpan(text: text.substring(index), style: textStyle));
        break;
      }
      if (index != searchTextIndex) {
        textSpans.add(TextSpan(
            text: text.substring(index, searchTextIndex), style: textStyle));
      }
      textSpans.add(TextSpan(
          text: text.substring(
              searchTextIndex, searchTextIndex + searchText.length),
          style: searchTextStyle));
      index = searchTextIndex + searchText.length;
    }
    return textSpans;
  }
}