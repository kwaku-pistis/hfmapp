import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/chatExtra/Friends.dart';
import 'package:HFM/screens/chatScreen/Chat.dart';
import 'package:flutter/material.dart';

import 'package:HFM/Consts.dart';
import 'package:HFM/themes/colors.dart';
import 'package:HFM/utils/Communication.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

Firestore _firestore = Firestore.instance;
var _repository = Repository();

class _MessagesState extends State<Messages> {
  String id;
  @override
  void initState() {
    super.initState();
    //get id
    SharedPreferences.getInstance().then((sp) {
      setState(() {
        id = sp.get(SHARED_PREFERENCES_USER_ID);
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
        backgroundColor: colortheme.primaryColor,
        title: Text(
          'Chats',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () => Navigator.of(context).push(
        //     MaterialPageRoute(builder: (BuildContext context) => ChatScreen())),
        onPressed: () {
          _showFriends();
        },
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        backgroundColor: colortheme.accentColor,
      ),
      body: _mainScreenBody(),
    );
  }

  Widget _mainScreenBody() {
    return StreamBuilder(
      stream: _firestore
          .collection(USERS_COLLECTION)
          .document(id)
          .collection(FRIENDS_COLLECTION)
          .orderBy(FRIEND_TIME_ADDED)
          .snapshots(),
      // stream: _firestore
      //     .collection(MESSAGES_COLLECTION)
      //     .document(id).,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error),
          );
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data.documents.isEmpty)
          return Center(
              child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.message,
                  color: colortheme.accentColor,
                  size: 50,
                ),
                Text('No chats yet. Click here to start a chat')
              ],
            ),
            onTap: () {
              _showFriends();
            },
          ));
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                _friendTileBuilder(snapshot.data.documents[index]));
      },
    );
  }

  Widget _friendTileBuilder(DocumentSnapshot document) {
    return StreamBuilder(
      stream: Stream.fromFuture(getFriendById(document[FRIEND_ID])),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return Center(child: Text(snapshot.error));
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        return ListTile(
          title: Text(snapshot.data.data[USER_DISPLAY_NAME]),
          // subtitle: Text(document[FRIEND_LATEST_MESSAGE] == null
          //     ? '...'
          //     : document[FRIEND_LATEST_MESSAGE]),
          subtitle: Text(
            'A conversation with ${snapshot.data.data[USER_DISPLAY_NAME]}',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          leading: Container(
            margin: EdgeInsets.all(MAINSCREEN_FRIEND_PHOTO_MARGIN),
            child: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
                imageUrl: snapshot.data.data[USER_PHOTO_URI] != null
                    ? snapshot.data.data[USER_PHOTO_URI]
                    : USER_IMAGE_PLACE_HOLDER,
                width: MAINSCREEN_FRIEND_PHOTO_WIDTH,
                height: MAINSCREEN_FRIEND_PHOTO_HEIGHT,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(MAINSCREEN_FRIEND_PHOTO_RADIUS)),
              clipBehavior: Clip.antiAlias,
            ),
          ),
          //navigate to chatScreen
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  Chat(friendId: snapshot.data.data[USER_ID], id: id,))),
          onLongPress: () => _longPressAlertDialog(
              snapshot.data.data[USER_DISPLAY_NAME],
              snapshot.data.data[USER_ID]),
        );
      },
    );
  }

  _longPressAlertDialog(String displayName, String userId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Align(
                alignment: Alignment.centerLeft, child: Icon(Icons.delete)),
            content: Text('Do you want to delete chat with $displayName?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Delete', style: TextStyle(color: colortheme.accentColor),),
                onPressed: () {
                  Navigator.pop(context);
                  deleteUser(userId, id).then((value) {
                    setState(() {});
                  });
                },
              ),
              FlatButton(
                child: Text('Cancel', style: TextStyle(color: colortheme.accentColor),),
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
