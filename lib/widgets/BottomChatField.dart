import 'dart:io';

import 'package:fashion_app/models/user.dart';
import 'package:fashion_app/providers/messageReplyProvider.dart';
import 'package:fashion_app/providers/userProvider.dart';
import 'package:fashion_app/screens/chatting/chatController/chatController.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:fashion_app/utils/utils.dart';
import 'package:fashion_app/widgets/MessageReplyPreview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BottomChatField extends StatefulWidget {
  final String recieverUserId;
  final String recieverUserName;
  final bool isGroupChat;
  BottomChatField(
      {required this.recieverUserId,
      required this.recieverUserName,
      required this.isGroupChat,
      Key? key})
      : super(key: key);

  @override
  _BottomChatFieldState createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  void cancelReply(context) {
    Provider.of<MessageReplyProvider>(context, listen: false)
        .setMessageReply(null);
  }

  void sendTextMessage(User user, MessageReply? messageReply) async {
    ChatController().sendTextMessage(
        context: context,
        text: _messageController.text.trim(),
        recieverUserId: widget.recieverUserId,
        senderUser: user,
        isGroupChat: widget.isGroupChat,
        messageReply: messageReply);
    cancelReply(context);
    setState(() {
      _messageController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final messageReply =
        Provider.of<MessageReplyProvider>(context).messageReply;
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        isShowMessageReply
            ? MessageReplyPreview(
                recieverName: widget.recieverUserName,
              )
            : const SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppTheme.grey,
                  prefixIcon: SizedBox(
                    width: 40,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await pickImage(ImageSource.gallery);
                          },
                          icon: const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintStyle: const TextStyle(color: AppTheme.white),
                  hintTextDirection: TextDirection.ltr,
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 2,
                left: 2,
              ),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  onTap: () =>
                      sendTextMessage(userProvider.getUser, messageReply),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
