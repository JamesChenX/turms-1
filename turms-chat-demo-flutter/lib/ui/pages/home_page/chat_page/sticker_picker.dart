import 'package:flutter/material.dart';

import '../../../components/t_text_button.dart';

typedef EmojiCallback = void Function(String emoji);

class StickerPicker extends StatelessWidget {
  const StickerPicker({
    super.key,
    required this.emojiCallback,
  });

  final EmojiCallback emojiCallback;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: Container(
          height: 460,
          width: 460,
          padding: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(1.0, 1.0),
                  blurRadius: 6.0,
                ),
              ]),
          child: Column(
            children: [
              Flexible(
                  child: GridView.builder(
                itemCount: 30,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final text = '😊';
                  return TTextButton(
                      text: text,
                      textStyle: TextStyle(
                        fontFamily: 'NotoColorEmoji',
                        fontSize: 26,
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      backgroundHoverColor: Color.fromARGB(255, 242, 242, 242),
                      onPressed: () {
                        emojiCallback(text);
                        // _controller.document.format(
                        //     _controller.selection.start,
                        //     1,
                        //     StyleAttribute(
                        //         "mobileWidth: ${_imageSize!.width}; mobileHeight: ${_imageSize!.height}; mobileMargin: 10; mobileAlignment: center"));
                      });
                  // return Container(
                  //   // width: 80,
                  //   // height: 80,
                  //     width: 40,
                  //     height: 40,
                  //     color: Color.fromARGB(255, 242, 242, 242),
                  //     alignment: Alignment.center,
                  //     child: Text(
                  //       '😊',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontFamily: 'NotoColorEmoji',
                  //         fontSize: 26,
                  //       ),
                  //     ));
                },
              )),
              // SizedBox(
              //   height: 50,
              //   child: Row(
              //     children: [
              //       Icon(
              //         Symbols.emoji_emotions,
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      );
}