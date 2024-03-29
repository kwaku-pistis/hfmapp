import 'package:HFM/Consts.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/chatScreen/Chat.dart';
import 'package:HFM/themes/colors.dart';
import 'package:HFM/utils/Communication.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FriendsScreenState();
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;
var _repository = Repository();

FirebaseAuth _auth = FirebaseAuth.instance;
List<String> _followingIds = [];

class FriendsScreenState extends State<FriendsScreen> {
  //currentUser
  String id = '';

  @override
  void initState() {
    _retrieveFollowingIds();
    super.initState();
    // _getPreferences();

    _repository.getCurrentUser().then((user) {
      print("USER : ${user.displayName}");
      setState(() {
        id = user.uid;
      });
      _repository.fetchFollowingUids(user).then((onValue) {
        setState(() {
          _followingIds = onValue;
        });
      });
    });
  }

  _retrieveFollowingIds() async {
    User user = _auth.currentUser!;
    _repository.fetchFollowingUids(user).then((onValue) {
      setState(() {
        _followingIds = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _friendsScreenBody(),
    );
  }

  Widget _friendsScreenBody() {
    return StreamBuilder(
      // stream: _firestore
      //     .collection(USERS_COLLECTION) //users
      //     .snapshots(),
      stream: _firestore.collection("User Info").snapshots(),
      builder:
          (BuildContext buildContext, AsyncSnapshot<QuerySnapshot> snapshots) {
        if (!snapshots.hasData) return const Text('no data');
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return _followingIds.isNotEmpty
              ? ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) =>
                      _friendTileBuilder(snapshots.data!.docs[index]),
                )
              : const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _friendTileBuilder(DocumentSnapshot document) {
    if (!_followingIds.contains(document[USER_ID])) return Container();

    return ListTile(
      title: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(FRIENDS_PHOTO_MARGIN),
            child: Material(
              borderRadius:
                  const BorderRadius.all(Radius.circular(FRIENDS_PHOTO_RADIUS)),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                placeholder: (context, url) => const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
                imageUrl: document[USER_PHOTO_URI] ?? USER_IMAGE_PLACE_HOLDER,
                width: FRIENDS_PHOTO_WIDTH,
                height: FRIENDS_PHOTO_HEIGHT,
              ),
            ),
          ),
          Text(document[USER_DISPLAY_NAME])
        ],
      ),
      onTap: () {
        // _showAddFriendDialog(document[USER_ID], document[USER_DISPLAY_NAME],
        //     document[USER_PHOTO_URI]);
        addFriend(document[USER_ID], id);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Chat(friendId: document[USER_ID], id: id)));
      },
    );
  }

  // _showAddFriendDialog(
  //     String friendId, String friendDisplayName, String friendPhotoUri) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(friendDisplayName),
  //           content: CircleAvatar(
  //             backgroundImage: CachedNetworkImageProvider(friendPhotoUri != null
  //                 ? friendPhotoUri
  //                 : USER_IMAGE_PLACE_HOLDER),
  //             radius: ADD_FRIEND_DIALOG_PHOTO_RADIUS,
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text(
  //                 'ADD',
  //                 style: TextStyle(color: colortheme.accentColor),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Toast.show('you have added $friendDisplayName', context,
  //                     duration: Toast.LENGTH_SHORT);
  //                 addFriend(friendId, id);
  //               },
  //             ),
  //             FlatButton(
  //               child: Text(
  //                 'CANCEL',
  //                 style: TextStyle(color: colortheme.accentColor),
  //               ),
  //               onPressed: () => Navigator.pop(context),
  //             )
  //           ],
  //         );
  //       });
  // }

  // _getPreferences() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   id = await prefs.get(SHARED_PREFERENCES_USER_ID);
  //   setState(() {});
  // }
}
