import 'package:HFM/Consts.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/chatScreen/ChatAppBar.dart';
import 'package:HFM/screens/chatScreen/ChatSegment.dart';
import 'package:HFM/utils/Communication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String friendId, id;

  const Chat({Key? key, required this.friendId, required this.id})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatState();
}

class ChatState extends State<Chat> {
  late String friendDisplayName;
  late String friendPhotoUri;
  late String groupId;
  //String id;
  late String about;

  @override
  void initState() {
    // _repository.getCurrentUser().then((user) {
    //   print("USER : ${user.displayName}");
    //   setState(() {
    //     id = user.uid;
    //   });
    // });
    FirebaseFirestore.instance
        .collection('User Info')
        .doc(widget.id)
        .update({'chattingWith': widget.friendId});
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: CHAT_SCREEN_BACKGROUND,
        body: (friendDisplayName == null)
            ? const Center(child: CircularProgressIndicator())
            : _chatScreenBody(),
        appBar: AppBar(
          title: (friendDisplayName == null)
              ? null
              : ChatAppBar(
                  photoUri: friendPhotoUri,
                  displayName: friendDisplayName,
                  id: widget.friendId,
                  about: about),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('User Info')
                  .doc(widget.id)
                  .update({'chattingWith': null});
              Navigator.pop(context);
            },
          ),
          actions: _appBarActions(),
        ),
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [];
  }

  Widget _chatScreenBody() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/adinkra_pattern.png'),
        fit: BoxFit.cover,
      )),
      child: Column(
        children: <Widget>[
          ChatSegment(
              groupId: groupId, id: widget.id, friendId: widget.friendId),
          // InputSegment(
          //   groupId: groupId,
          //   id: widget.id,
          //   friendId: friendId,
          // )
        ],
      ),
    );
  }

  _init() {
    _getFriendInfo();
    _setGroupChatId();
  }

  _setGroupChatId() async {
    // var sp = await SharedPreferences.getInstance();
    // id = sp.get(SHARED_PREFERENCES_USER_ID);
    if (widget.id.hashCode < widget.friendId.hashCode) {
      groupId = '${widget.friendId}-${widget.id}';
    } else {
      groupId = '${widget.id}-${widget.friendId}';
    }
  }

  _getFriendInfo() async {
    var document = await getFriendById(widget.friendId);
    about = document[USER_ABOUT_FIELD] ?? '...';
    friendDisplayName = document[USER_DISPLAY_NAME];
    friendPhotoUri = document[USER_PHOTO_URI] ?? USER_IMAGE_PLACE_HOLDER;
    setState(() {});
  }

  Future<bool> onBackPress() {
    FirebaseFirestore.instance
        .collection('User Info')
        .doc(widget.id)
        .update({'chattingWith': null});
    Navigator.pop(context);

    return Future.value(false);
  }
}
