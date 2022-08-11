import 'dart:io';

import 'package:HFM/models/comment.dart';
import 'package:HFM/models/like.dart';
import 'package:HFM/models/message.dart';
import 'package:HFM/models/post.dart';
import 'package:HFM/models/user.dart' as appUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late appUser.User user;
  late Post post;
  late Like like;
  late Message _message;
  late Comment comment;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late Reference reference;

  Future<void> addDataToDb(User currentUser) async {
    print("Inside addDataToDb Method");

    firestore
        .collection("display_names")
        .doc(currentUser.displayName)
        .set({'displayName': currentUser.displayName});

    user = appUser.User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profileImage: currentUser.photoURL,
        followers: '0',
        following: '0',
        bio: '',
        posts: '0',
        username: '');

    Map<String, dynamic> mapData = <String, dynamic>{};

    mapData = user.toMap(user);

    return firestore.collection("User Info").doc(currentUser.uid).set(mapData);
  }

  Future<bool> authenticateUser(User user) async {
    print("Inside authenticateUser");
    final QuerySnapshot result = await firestore
        .collection("User Info")
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    if (docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser!;
    print("EMAIL ID : ${currentUser.email}");
    return currentUser;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<User> signIn() async {
    GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication signInAuthentication =
        await signInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: signInAuthentication.accessToken,
      idToken: signInAuthentication.idToken,
    );

    final User user = (await _auth.signInWithCredential(credential)) as User;
    return user;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    reference = FirebaseStorage.instance
        .ref()
        .child('User Posts')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    UploadTask storageUploadTask = reference.putFile(imageFile);
    var url = await (await storageUploadTask).ref.getDownloadURL();
    return url;
  }

  Future<void> addPostToDb(appUser.User currentUser, String imgUrl,
      String caption, String location) {
    CollectionReference collectionRef = firestore
        .collection("User Info")
        .doc(currentUser.uid)
        .collection("posts");

    post = Post(
        currentUserUid: currentUser.uid!,
        imgUrl: imgUrl,
        caption: caption,
        location: location,
        postOwnerName: currentUser.name!,
        postOwnerPhotoUrl: currentUser.profileImage!,
        time: FieldValue.serverTimestamp(),
        postTime: DateTime.now().toString());

    return collectionRef.add(post.toMap(post));
  }

  Future<appUser.User> retrieveUserDetails(User user) async {
    var documentSnapshot =
        await firestore.collection("User Info").doc(user.uid).get();
    return appUser.User.fromMap(documentSnapshot.data()!);
  }

  Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection("User Info")
        .doc(userId)
        .collection("posts")
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchPostCommentDetails(
      DocumentReference reference) async {
    QuerySnapshot snapshot = await reference.collection("comments").get();
    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchPostLikeDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection("likes").get();
    return snapshot.docs;
  }

  Future<bool> checkIfUserLikedOrNot(
      String userId, DocumentReference reference) async {
    DocumentSnapshot snapshot =
        await reference.collection("likes").doc(userId).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<List<DocumentSnapshot>> retrievePosts(User user) async {
    List<DocumentSnapshot> list = [];
    List<DocumentSnapshot> updatedList = [];
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await firestore.collection("User Info").get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i].reference.collection("posts").get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print("UPDATED LIST LENGTH : ${updatedList.length}");
    return updatedList;
  }

  Future<List<String>> fetchAllUserNames(User user) async {
    List<String> userNameList = [];
    QuerySnapshot querySnapshot = await firestore.collection("User Info").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userNameList.add(querySnapshot.docs[i]['name']);
      }
    }
    print("USERNAMES LIST : ${userNameList.length}");
    return userNameList;
  }

  Future<String> fetchUidBySearchedName(String name) async {
    late String uid;
    List<DocumentSnapshot> uidList = [];

    QuerySnapshot querySnapshot = await firestore.collection("User Info").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      uidList.add(querySnapshot.docs[i]);
    }

    print("UID LIST : ${uidList.length}");

    for (var i = 0; i < uidList.length; i++) {
      if (uidList[i]['name'] == name) {
        uid = uidList[i].id;
      }
    }
    print("UID DOC ID: $uid");
    return uid;
  }

  Future<appUser.User> fetchUserDetailsById(String uid) async {
    var documentSnapshot =
        await firestore.collection("User Info").doc(uid).get();
    return appUser.User.fromMap(documentSnapshot.data()!);
  }

  Future<void> followUser(
      {required String currentUserId, required String followingUserId}) async {
    var followingMap = <String, String>{};
    followingMap['uid'] = followingUserId;
    await firestore
        .collection("User Info")
        .doc(currentUserId)
        .collection("following")
        .doc(followingUserId)
        .set(followingMap);

    var followersMap = <String, String>{};
    followersMap['uid'] = currentUserId;

    return firestore
        .collection("User Info")
        .doc(followingUserId)
        .collection("followers")
        .doc(currentUserId)
        .set(followersMap);
  }

  Future<void> unFollowUser(
      {required String currentUserId, required String followingUserId}) async {
    await firestore
        .collection("User Info")
        .doc(currentUserId)
        .collection("following")
        .doc(followingUserId)
        .delete();

    return firestore
        .collection("User Info")
        .doc(followingUserId)
        .collection("followers")
        .doc(currentUserId)
        .delete();
  }

  Future<bool> checkIsFollowing(String name, String currentUserId) async {
    bool isFollowing = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await firestore
        .collection("User Info")
        .doc(currentUserId)
        .collection("following")
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id == uid) {
        isFollowing = true;
      }
    }
    return isFollowing;
  }

  Future<List<DocumentSnapshot>> fetchStats(
      {required String uid, required String label}) async {
    QuerySnapshot querySnapshot = await firestore
        .collection("User Info")
        .doc(uid)
        .collection(label)
        .get();
    return querySnapshot.docs;
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = {};
    map['profileImage'] = photoUrl;
    return firestore.collection("User Info").doc(uid).update(map);
  }

  Future<void> updateDetails(String uid, String name, String bio, String email,
      String username) async {
    Map<String, dynamic> map = {};
    map['name'] = name;
    map['bio'] = bio;
    map['email'] = email;
    map['username'] = username;
    return firestore.collection("User Info").doc(uid).update(map);
  }

  Future<List<String>> fetchUserNames(User user) async {
    DocumentReference documentReference =
        firestore.collection("messages").doc(user.uid);
    List<String> userNameList = [];
    List<String> chatUsersList = [];
    QuerySnapshot querySnapshot = await firestore.collection("User Info").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        print("USERNAMES : ${querySnapshot.docs[i].id}");
        userNameList.add(querySnapshot.docs[i].id);
        //querySnapshot.documents[i].reference.collection("collectionPath");
        //userNameList.add(querySnapshot.documents[i].data['displayName']);
      }
    }

    for (var i = 0; i < userNameList.length; i++) {
      print("CHAT USERS : ${userNameList[i]}");
      chatUsersList.add(userNameList[i]);
    }

    print("CHAT USERS LIST : ${chatUsersList.length}");

    return chatUsersList;

    // print("USERNAMES LIST : ${userNameList.length}");
    // return userNameList;
  }

  Future<List<appUser.User>> fetchAllUsers(User user) async {
    List<appUser.User> userList = [];
    var querySnapshot = await firestore.collection("User Info").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userList.add(appUser.User.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.documents[i].data[User.fromMap(mapData)]);
      }
    }
    print("USERS LIST : ${userList.length}");
    return userList;
  }

  void uploadImageMsgToDb(String url, String receiverUid, String senderUid) {
    _message = Message.withoutMessage(
        receiverUid: receiverUid,
        senderUid: senderUid,
        photoUrl: url,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = <String, dynamic>{};
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['profileImage'] = _message.photoUrl;

    print("Map : $map");
    firestore
        .collection("messages")
        .doc(_message.senderUid)
        .collection(receiverUid)
        .add(map)
        .whenComplete(() {
      print("Messages added to db");
    });

    firestore
        .collection("messages")
        .doc(receiverUid)
        .collection(_message.senderUid)
        .add(map)
        .whenComplete(() {
      print("Messages added to db");
    });
  }

  Future<Future<DocumentReference>> addMessageToDb(
      Message message, String receiverUid) async {
    print("Message : ${message.message}");
    var map = message.toMap();

    print("Map : $map");
    await firestore
        .collection("messages")
        .doc(message.senderUid)
        .collection(receiverUid)
        .add(map);

    return firestore
        .collection("messages")
        .doc(receiverUid)
        .collection(message.senderUid)
        .add(map);
  }

  Future<List<DocumentSnapshot>> fetchFeed(User user) async {
    List<String> followingUIDs = [];
    List<DocumentSnapshot> list = [];

    QuerySnapshot querySnapshot = await firestore
        .collection("User Info")
        // .document(user.uid)
        // .collection("following")
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      followingUIDs.add(querySnapshot.docs[i].id);
    }

    print("FOLLOWING UIDS : ${followingUIDs.length}");

    for (var i = 0; i < followingUIDs.length; i++) {
      print("SDDSSD : ${followingUIDs[i]}");

      //retrievePostByUID(followingUIDs[i]);
      // fetchUserDetailsById(followingUIDs[i]);

      QuerySnapshot postSnapshot = await firestore
          .collection("User Info")
          .doc(followingUIDs[i])
          .collection("posts")
          .orderBy('postTime', descending: true)
          .get();
      // postSnapshot.documents;
      for (var i = 0; i < postSnapshot.docs.length; i++) {
        print("dad : ${postSnapshot.docs[i].id}");
        list.add(postSnapshot.docs[i]);
        print("ads : ${list.length}");
      }
    }

    return list;
  }

  Future<List<DocumentSnapshot>> fetchMessaging(User user) async {
    List<String> followingUIDs = [];
    List<DocumentSnapshot> list = [];

    QuerySnapshot querySnapshot = await firestore
        .collection("messages")
        .doc(user.uid)
        .collection("following")
        .get();

    // QuerySnapshot querySnapshot =
    //     await _firestore.collection("messages").document(user.uid).collection().getDocuments();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      followingUIDs.add(querySnapshot.docs[i].id);
    }

    print("FOLLOWING UIDS : ${followingUIDs.length}");

    for (var i = 0; i < followingUIDs.length; i++) {
      print("SDDSSD : ${followingUIDs[i]}");

      //retrievePostByUID(followingUIDs[i]);
      // fetchUserDetailsById(followingUIDs[i]);

      QuerySnapshot postSnapshot = await firestore
          .collection("User Info")
          .doc(followingUIDs[i])
          .collection("posts")
          .get();
      // postSnapshot.documents;
      for (var i = 0; i < postSnapshot.docs.length; i++) {
        print("dad : ${postSnapshot.docs[i].id}");
        list.add(postSnapshot.docs[i]);
        print("ads : ${list.length}");
      }
    }

    return list;
  }

  Future<List<String>> fetchFollowingUids(User user) async {
    List<String> followingUIDs = [];

    QuerySnapshot querySnapshot = await firestore
        .collection("User Info")
        .doc(user.uid)
        .collection("following")
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      followingUIDs.add(querySnapshot.docs[i].id);
    }

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DDDD : ${followingUIDs[i]}");
    }
    return followingUIDs;
  }
}
