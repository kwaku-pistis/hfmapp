import 'package:cloud_firestore/cloud_firestore.dart';

class Like {
  late String ownerName;
  late String ownerPhotoUrl;
  late String ownerUid;
  late FieldValue timeStamp;

  Like(
      {required this.ownerName,
      required this.ownerPhotoUrl,
      required this.ownerUid,
      required this.timeStamp});

  Map<String, dynamic> toMap(Like like) {
    var data = <String, dynamic>{};
    data['ownerName'] = like.ownerName;
    data['ownerPhotoUrl'] = like.ownerPhotoUrl;
    data['ownerUid'] = like.ownerUid;
    data['timestamp'] = like.timeStamp.toString();
    return data;
  }

  Like.fromMap(Map<String, dynamic> mapData) {
    ownerName = mapData['ownerName'];
    ownerPhotoUrl = mapData['ownerPhotoUrl'];
    ownerUid = mapData['ownerUid'];
    timeStamp = mapData['timestamp'];
  }
}
