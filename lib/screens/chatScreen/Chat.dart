import 'package:HFM/Consts.dart';
import 'package:HFM/screens/chatScreen/ChatAppBar.dart';
import 'package:HFM/screens/chatScreen/ChatSegment.dart';
import 'package:HFM/screens/chatScreen/InputSegment.dart';
import 'package:HFM/utils/Communication.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Chat extends StatefulWidget{

  final String friendId;
  Chat({@required this.friendId});

  @override
  State<StatefulWidget> createState() => ChatState(friendId: friendId);
}

class ChatState extends State<Chat>{

  final String friendId;
  String friendDisplayName;
  String friendPhotoUri;
  String groupId;
  String id;
  String about;
  ChatState({@required this.friendId});

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CHAT_SCREEN_BACKGROUND,
      body: (friendPhotoUri == null || friendDisplayName == null) ? Center(child:CircularProgressIndicator()) : _chatScreenBody(),
      appBar: AppBar(
        title: (friendPhotoUri == null || friendDisplayName == null) ? null : ChatAppBar(
            photoUri: friendPhotoUri,
            displayName: friendDisplayName,
            id:friendId,
            about:about
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: _appBarActions(),
      ),
    );
  }

  List<Widget> _appBarActions(){
    return null;
  }

  Widget _chatScreenBody(){
    return Column(
      children: <Widget>[
        ChatSegment(groupId:groupId,id: id),
        InputSegment(groupId: groupId,id: id,friendId: friendId,)
      ],
    );
  }

  _init(){
    _getFriendInfo();
    _setGroupChatId();
  }

  _setGroupChatId()async{
    var sp = await SharedPreferences.getInstance();
    id = sp.get(SHARED_PREFERENCES_USER_ID);
    if(id.hashCode < friendId.hashCode){
      groupId = '$friendId-$id';
    }else{
      groupId = '$id-$friendId';
    }
  }

  _getFriendInfo()async{
    var document = await getFriendById(friendId);
    about = document[USER_ABOUT_FIELD] != null ? document[USER_ABOUT_FIELD]:'...';
    friendDisplayName = document[USER_DISPLAY_NAME];
    friendPhotoUri = document[USER_PHOTO_URI] != null ?  document[USER_PHOTO_URI] : USER_IMAGE_PLACE_HOLDER;
    setState(() {
    });
  }

}
