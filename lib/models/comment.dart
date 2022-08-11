import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  late String ownerName;
  late String ownerPhotoUrl;
  late String comment;
  late FieldValue timeStamp;
  late String ownerUid;

  Comment(
      {required this.ownerName,
      required this.ownerPhotoUrl,
      required this.comment,
      required this.timeStamp,
      required this.ownerUid});

  Map<String, dynamic> toMap(Comment comment) {
    var data = <String, dynamic>{};
    data['ownerName'] = comment.ownerName;
    data['ownerPhotoUrl'] = comment.ownerPhotoUrl;
    data['comment'] = comment.comment;
    data['timestamp'] = comment.timeStamp;
    data['ownerUid'] = comment.ownerUid;
    return data;
  }

  Comment.fromMap(Map<String, dynamic> mapData) {
    ownerName = mapData['ownerName'];
    ownerPhotoUrl = mapData['ownerPhotoUrl'];
    comment = mapData['comment'];
    timeStamp = mapData['timestamp'];
    ownerUid = mapData['ownerUid'];
  }
}
