import 'package:fashion_app/models/message.dart';
import 'package:fashion_app/providers/messageReplyProvider.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:fashion_app/widgets/displayTextImageGIF.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageReplyPreview extends StatefulWidget {
  final String recieverName;
  MessageReplyPreview({required this.recieverName, Key? key}) : super(key: key);

  @override
  _MessageReplyPreviewState createState() => _MessageReplyPreviewState();
}

class _MessageReplyPreviewState extends State<MessageReplyPreview> {
  void cancelReply(context) {
    Provider.of<MessageReplyProvider>(context, listen: false)
        .setMessageReply(null);
  }

  @override
  Widget build(BuildContext context) {
    final messageReply =
        Provider.of<MessageReplyProvider>(context).messageReply;
    //  = ref.watch(messageReplyProvider);

    return Row(
      children: [
        Container(
          width: 310,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppTheme.dismissibleBackground,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        messageReply!.isMe ? 'Me' : widget.recieverName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                      onTap: () => cancelReply(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 350,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: messageReply.isMe
                      ? const Color(0xFF128C7E)
                      : const Color.fromARGB(255, 21, 107, 198),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: DisplayTextImageGIF(
                  message: messageReply.message,
                  type: messageReply.messageEnum,
                ),
              )
            ],
          ),
        ),
        SizedBox()
      ],
    );
  }
}
