import 'package:flutter/material.dart';

class TAvatar extends StatelessWidget {
  final bool useLargeSize;
  final GestureTapCallback? onPressed;

  const TAvatar({super.key, this.useLargeSize = false, this.onPressed});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: useLargeSize ? 60 : 40,
            width: useLargeSize ? 60 : 40,
            color: const Color(0xffFF0E58),
            alignment: Alignment.center,
            child: Text(
              '帅',
              style: TextStyle(
                  fontSize: useLargeSize ? 26 : 20, color: Colors.white),
            ),
            // child: const Icon(Icons.volume_up, color: Colors.white, size: 50.0),
          ),
        ),
      );
}