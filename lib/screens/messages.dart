import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/chatExtra/Friends.dart';
import 'package:HFM/screens/chatScreen/Chat.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:HFM/Consts.dart';
import 'package:HFM/themes/colors.dart';
import 'package:HFM/utils/Communication.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;
var _repository = Repository();
// String SHARED_PREFERENCES_USER_ID = "shared_preferences_user_id";

class _MessagesState extends State<Messages> {
  late String id;
  @override
  void initState() {
    super.initState();
    //get id
    SharedPreferences.getInstance().then((sp) {
      setState(() {
        id = sp.get(SHARED_PREFERENCES_USER_ID).toString();
      });
    });

    _repository.getCurrentUser().then((user) {
      print("USER : ${user.displayName}");
      setState(() {
        id = user.uid;
      });
    });

    //check connection
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile) {
        print('USER IS ONLINE NOW(MOBILE)');
      } else if (result == ConnectivityResult.wifi) {
        print('USER IS ONLINE NOW(WIFI)');
      } else {
        print('USER IS OFFLINE NOW');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme.primaryColor,
        title: const Text(
          'Chats',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () => Navigator.of(context).push(
        //     MaterialPageRoute(builder: (BuildContext context) => ChatScreen())),
        onPressed: () {
          _showFriends();
        },
        backgroundColor: colorTheme.primaryColorDark,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: _mainScreenBody(),
    );
  }

  Widget _mainScreenBody() {
    return StreamBuilder(
      stream: _firestore
          .collection(USERS_COLLECTION)
          .doc(id)
          .collection(FRIENDS_COLLECTION)
          .orderBy(FRIEND_TIME_ADDED)
          .snapshots(),
      // stream: _firestore
      //     .collection(MESSAGES_COLLECTION)
      //     .document(id).,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
              child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.message,
                  color: colorTheme.primaryColorDark,
                  size: 50,
                ),
                const Text('No chats yet. Click here to start a chat')
              ],
            ),
            onTap: () {
              _showFriends();
            },
          ));
        }
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                _friendTileBuilder(snapshot.data!.docs[index]));
      },
    );
  }

  Widget _friendTileBuilder(DocumentSnapshot document) {
    return StreamBuilder(
      stream: Stream.fromFuture(getFriendById(document[FRIEND_ID])),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListTile(
          title: Text(snapshot.data![USER_DISPLAY_NAME]),
          // subtitle: Text(document[FRIEND_LATEST_MESSAGE] == null
          //     ? '...'
          //     : document[FRIEND_LATEST_MESSAGE]),
          subtitle: Text(
            'A conversation with ${snapshot.data![USER_DISPLAY_NAME]}',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          leading: Container(
            margin: const EdgeInsets.all(MAINSCREEN_FRIEND_PHOTO_MARGIN),
            child: Material(
              borderRadius: const BorderRadius.all(
                  Radius.circular(MAINSCREEN_FRIEND_PHOTO_RADIUS)),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                placeholder: (context, url) => const SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
                imageUrl:
                    snapshot.data![USER_PHOTO_URI] ?? USER_IMAGE_PLACE_HOLDER,
                width: MAINSCREEN_FRIEND_PHOTO_WIDTH,
                height: MAINSCREEN_FRIEND_PHOTO_HEIGHT,
              ),
            ),
          ),
          //navigate to chatScreen
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Chat(
                    friendId: snapshot.data![USER_ID],
                    id: id,
                  ))),
          onLongPress: () => _longPressAlertDialog(
              snapshot.data![USER_DISPLAY_NAME], snapshot.data![USER_ID]),
        );
      },
    );
  }

  _longPressAlertDialog(String displayName, String userId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Align(
                alignment: Alignment.centerLeft, child: Icon(Icons.delete)),
            content: Text('Do you want to delete chat with $displayName?'),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'Delete',
                  style: TextStyle(color: colorTheme.primaryColorDark),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  deleteUser(userId, id).then((value) {
                    setState(() {});
                  });
                },
              ),
              ElevatedButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: colorTheme.primaryColorDark),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void _showFriends() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => FriendsScreen()));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
