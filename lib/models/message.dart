import 'package:messaging/common/enums/message_enum.dart';

class Message {
  final String senderUid;
  final String recieverUid;
  final String text;
  final MessageEnum messageEnum;
  final DateTime dateTime;
  final String messageId;
  final bool isSeen;
  final String fileName;

  Message(
      {required this.fileName,
      required this.senderUid,
      required this.recieverUid,
      required this.text,
      required this.messageEnum,
      required this.dateTime,
      required this.messageId,
      required this.isSeen});

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'recieverUid': recieverUid,
      'text': text,
      'dateTime': dateTime,
      'messageId': messageId,
      'messageEnum': messageEnum.type,
      'isSeen': isSeen,
      'fileName': fileName
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] ?? '',
      dateTime: map['dateTime'].toDate(),
      messageId: map['messageId'] ?? '',
      senderUid: map['senderUid'],
      recieverUid: map['recieverUid'],
      messageEnum: (map['messageEnum'] as String).toEnum(),
      isSeen: map['isSeen'],
      fileName: map['fileName'],
    );
  }
}
