import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:HFM/Consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<DocumentSnapshot> getFriendById(String id) async {
  var documents = await _firestore
      .collection(USERS_COLLECTION)
      .where(USER_ID, isEqualTo: id)
      .limit(1)
      .get();
  return documents.docs[0];
}

sendMessage(ChatMessage msg, String groupId, String id, String friendId,
    BuildContext context) {
  //save time to avoid deleting issues
  var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  var date = DateTime.now();
  var fDate = DateFormat.yMd().format(date);
  print("Chat sent on: $fDate");

  var documentReference = FirebaseFirestore.instance
      .collection(MESSAGES_COLLECTION)
      .doc(groupId)
      .collection(groupId)
      .doc(timestamp);

  // var documentRef = Firestore.instance
  //     .collection("User Info")
  //     .document(id)
  //     .collection(FRIENDS_COLLECTION)
  //     .document(FRIEND_ID);

  FirebaseFirestore.instance.runTransaction((transaction) async {
    // registerNotification(id, context);
    transaction.set(documentReference, {
      MESSAGE_ID_FROM: id,
      MESSAGE_ID_TO: friendId,
      MESSAGE_TIMESTAMP: timestamp,
      MESSAGE_CONTENT: msg.toJson(),
      MESSAGE_TYPE: MESSAGE_TYPE_TEXT,
    });
    // .then((onValue) {
    //   registerNotification(id, context);
    // });
    registerNotification(id, context);
  });
  // .then((onValue) {
  //   registerNotification(id);
  // });
  // Firestore.instance.runTransaction((transaction) async {
  //   await transaction.update(documentRef, {
  //     FRIEND_LATEST_MESSAGE : msg,
  //   });
  // });
}

_deleteMessage(String timestamp, String groupId) async {
  // path : /media/images/$groupId/$idFrom+timestamp
  var imageName = '${groupId.split('-')[0]}+$timestamp';

  //delete image reference
  await _firestore
      .collection(MESSAGES_COLLECTION)
      .doc(groupId)
      .collection(groupId)
      .doc(timestamp)
      .delete();

  // delete image file
  await FirebaseStorage.instance
      .ref()
      .child('/media/images/$groupId/$imageName')
      .delete();
}

addFriend(String friendId, String id) async {
  var time = DateTime.now().millisecondsSinceEpoch.toString();

  bool isNewFriend = false;

  await _firestore
      .collection(USERS_COLLECTION)
      .doc(id)
      .collection(FRIENDS_COLLECTION)
      .where(FRIEND_ID, isEqualTo: friendId)
      .get()
      .then((value) {
    if (value.docs.isEmpty) {
      isNewFriend = true;
    }
  });

  if (isNewFriend) {
    await _firestore
        .collection(USERS_COLLECTION)
        .doc(id)
        .collection(FRIENDS_COLLECTION)
        .doc(friendId)
        .set({
      FRIEND_ID: friendId,
      FRIEND_TIME_ADDED: time,
      FRIEND_LATEST_MESSAGE: ''
    });
  }
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

///creates a new users in the cloud with its firebase' userInfo
Future<void> createUserProfile(User firebase) async {
  var id = firebase.uid;

// Firestore  //get user's document
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection(USERS_COLLECTION)
      .where(USER_ID, isEqualTo: firebase.uid)
      .get();
  final List<DocumentSnapshot> documents = result.docs;

  //create a new user if the user doesn't exists
  if (documents.isEmpty) {
    await _firestore
        .collection(USERS_COLLECTION) //users
        .doc(firebase.uid)
        .set({
      USER_DISPLAY_NAME: firebase.displayName, //name
      USER_ABOUT_FIELD: null, //about
      USER_ID: firebase.uid, //id
      USER_PHOTO_URI: USER_IMAGE_PLACE_HOLDER, //userProfile
      USER_EMAIL: firebase.email,
      USER_TOKEN: await FirebaseMessaging.instance.getToken(),
    });
  }

  //permission for ios
  FirebaseMessaging.instance.requestPermission();

  //update user status
  var userFirestoreRef = _firestore.collection(USERS_COLLECTION).doc(id);

  var firebaseDatabaseRef =
      FirebaseDatabase.instance.ref().child('.info/connected');
  var userFirebaseDatabaseRef =
      FirebaseDatabase.instance.ref().child('/status/$id');
  var isOfflineForFirestore = {
    'state': 'offline',
    'last_changed': DateTime.now().toIso8601String(),
  };

  var isOnlineForFirestore = {
    'state': 'online',
    'last_changed': DateTime.now().toIso8601String(),
  };

  firebaseDatabaseRef.onValue.listen((data) {
    print('data : ${data.snapshot.value}');
    if (data.snapshot.value == false) {
      userFirestoreRef.update({USER_STATUS: STATUS_OFFLINE});
      return;
    }
    userFirebaseDatabaseRef.onDisconnect().set(isOfflineForFirestore).then((v) {
      userFirebaseDatabaseRef.set(isOnlineForFirestore);
      userFirestoreRef.update({USER_STATUS: STATUS_ONLINE});
    });
  });

  //update or add with every login
  //add user id and profile image
  await SharedPreferences.getInstance().then((sp) {
    var id = firebase.uid.toString();
    var photoUri = documents[0][USER_PHOTO_URI];
    var name = documents[0][USER_DISPLAY_NAME];
    var about = documents[0][USER_ABOUT_FIELD];

    sp.setString(SHARED_PREFERENCES_USER_ID, id);
    sp.setString(
        SHARED_PREFERENCES_USER_PHOTO, photoUri ?? USER_IMAGE_PLACE_HOLDER);
    sp.setString(SHARED_PREFERENCES_USER_DISPLAY_NAME, name);
    sp.setString(SHARED_PREFERENCES_USER_ABOUT, about);
  });
}

Future deleteUser(String userId, String id) async {
  await _firestore
      .collection(USERS_COLLECTION) //users
      .doc(id) //me
      .collection(FRIENDS_COLLECTION) //my friends
      .doc(userId) //this friend
      .delete(); //delete
}

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

void registerNotification(String currentUserId, BuildContext context) {
  firebaseMessaging.requestPermission();

  FirebaseMessaging.onMessage.listen((event) {
    RemoteNotification? notification = event.notification;
    // AndroidNotification? androidNotification = event.notification!.android;

    if (notification != null) {
      print('Notification: ${notification.body}');
      showNotification(notification);
    }
  });

  // firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) {
  //       print('onMessage: $message');
  //       Platform.isAndroid
  //           ? showNotification(message['notification'])
  //           : showNotification(message['aps']['alert']);
  //       Navigator.of((context)).pushNamed(message['screen']);
  //       return;
  //     },
  //     onBackgroundMessage: myBackgroundMessageHandler,
  //     onResume: (Map<String, dynamic> message) {
  //       print('onResume: $message');
  //       Navigator.of((context)).pushNamed(message['screen']);
  //       return;
  //     },
  //     onLaunch: (Map<String, dynamic> message) {
  //       print('onLaunch: $message');
  //       return;
  //     });

  firebaseMessaging.getToken().then((token) {
    print('token: $token');
    FirebaseFirestore.instance
        .collection('User Info')
        .doc(currentUserId)
        .update({'pushToken': token});
  }).catchError((err) {
    // Fluttertoast.showToast(msg: err.message.toString());
    // Toast.show('${err.message.toString()}', context, )
    print(err.message.toString());
  });
}

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// void configLocalNotification() {
//   var initializationSettingsAndroid =
//       new AndroidInitializationSettings('notification_icon');
//   var initializationSettingsIOS = new IOSInitializationSettings();
//   var initializationSettings = new InitializationSettings(
//       initializationSettingsAndroid, initializationSettingsIOS);
//   flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }

void showNotification(notification) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    Platform.isAndroid ? 'com.ministry.hfmapp' : 'com.ministry.hfmapp',
    'HFM',
    playSound: true,
    enableVibration: true,
    importance: Importance.max,
    priority: Priority.high,
  );
  var json = const JsonCodec();
  // var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
  var platformChannelSpecifics = const NotificationDetails();
  await flutterLocalNotificationsPlugin.show(0, notification.title,
      notification.body.toString(), platformChannelSpecifics,
      payload: json.encode(notification));
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    return data;
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    // Platform.isAndroid
    //     ? showNotification(notification)
    //     : showNotification(message['aps']['alert']);
    // Navigator.of((context)).pushNamed(message['screen']);
    return notification;
  }

  // Or do other work.
  return Future<void>.value();
}

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    .._matchteam = data['matchteam']
    .._score = data['score'];
  return item;
}

class Item {
  final String itemId;

  Item({required this.itemId});

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  late String _matchteam;
  String get matchteam => _matchteam;
  set matchteam(String value) {
    _matchteam = value;
    _controller.add(this);
  }

  late String _score;
  String get score => _score;
  set score(String value) {
    _score = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => Container(), // DetailPage(itemId),
      ),
    );
  }
}
