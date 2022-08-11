import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String senderUid;
  late String receiverUid;
  late String type;
  late String message;
  late FieldValue? timestamp;
  late String photoUrl;

  Message(
      {required this.senderUid,
      required this.receiverUid,
      required this.type,
      required this.message,
      required this.timestamp});
  Message.withoutMessage(
      {required this.senderUid,
      required this.receiverUid,
      required this.type,
      required this.timestamp,
      required this.photoUrl});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['senderUid'] = senderUid;
    map['receiverUid'] = receiverUid;
    map['type'] = type;
    map['message'] = message;
    map['timestamp'] = timestamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    Message message = Message(
        message: '', receiverUid: '', senderUid: '', timestamp: null, type: '');
    message.senderUid = map['senderUid'];
    message.receiverUid = map['receiverUid'];
    message.type = map['type'];
    message.message = map['message'];
    message.timestamp = map['timestamp'];
    return message;
  }
}
