import 'package:fashion_app/models/message.dart';
import 'package:fashion_app/screens/MyFeed.dart';
import 'package:flutter/material.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              color: Color.fromARGB(223, 255, 255, 255),
              fontSize: 16,
            ),
          )
        : type == MessageEnum.gif
            ? CachedNetworkImage(
                imageUrl: message,
              )
            : CachedNetworkImage(
                imageUrl: message,
              );
  }
}
