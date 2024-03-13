import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class TAudioPlayer extends StatefulWidget {
  const TAudioPlayer({Key? key}) : super(key: key);

  @override
  _TAudioPlayerState createState() => _TAudioPlayerState();
}

class _TAudioPlayerState extends State<TAudioPlayer> {
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 64,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Symbols.play_arrow_rounded),
                onPressed: () {},
              ),
              // Slider(value: value, onChanged: onChanged),
              const Text('00:10/00:21')
            ],
          ),
        ),
      );
}
