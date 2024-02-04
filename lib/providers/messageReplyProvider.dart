import 'package:fashion_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageReplyProvider with ChangeNotifier {
  MessageReply? _messageReply;

  MessageReply? get messageReply => _messageReply;

  void setMessageReply(MessageReply? messageReply) {
    _messageReply = messageReply;
    notifyListeners();
  }
}

void updateMessageReply(
    BuildContext context, String message, bool isMe, MessageEnum messageEnum) {
  final messageReplyProvider =
      Provider.of<MessageReplyProvider>(context, listen: false);
  messageReplyProvider
      .setMessageReply(MessageReply(message, isMe, messageEnum));
}

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(this.message, this.isMe, this.messageEnum);
}
