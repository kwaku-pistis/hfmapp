import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  late String currentUserUid;
  late String imgUrl;
  late String caption;
  late String location;
  late FieldValue time;
  late String postOwnerName;
  late String postOwnerPhotoUrl;
  late String postTime;

  Post(
    {
      required this.currentUserUid,
      required this.imgUrl,
      required this.caption,
      required this.location,
      required this.time,
      required this.postOwnerName,
      required this.postOwnerPhotoUrl,
      required this.postTime});

  Map<String, dynamic> toMap(Post post) {
    var data = <String, dynamic>{};
    data['ownerUid'] = post.currentUserUid;
    data['imgUrl'] = post.imgUrl;
    data['caption'] = post.caption;
    data['location'] = post.location;
    data['time'] = post.time;
    data['postOwnerName'] = post.postOwnerName;
    data['postOwnerPhotoUrl'] = post.postOwnerPhotoUrl;
    data['postTime'] = post.postTime;
    return data;
  }

  Post.fromMap(Map<String, dynamic> mapData) {
    currentUserUid = mapData['ownerUid'];
    imgUrl = mapData['imgUrl'];
    caption = mapData['caption'];
    location = mapData['location'];
    time = mapData['time'];
    postOwnerName = mapData['postOwnerName'];
    postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
    postTime = mapData['postTime'];
  }
}
