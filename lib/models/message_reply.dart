import 'package:messaging/models/message.dart';

class MessageReply {
  final Message message;
  final bool isReplyMyMessage;


  MessageReply(
      {required this.message,
      required this.isReplyMyMessage,
    });
}
