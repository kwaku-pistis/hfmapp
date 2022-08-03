import 'package:HFM/Consts.dart';
import 'package:HFM/utils/Communication.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  final String imageUrl;
  final String username;
  final String about;
  final String id;
  UserProfile(
      {required this.imageUrl,
      required this.username,
      required this.about,
      required this.id});

  @override
  State<StatefulWidget> createState() =>
      UserProfileState(imageUrl, username, about, id);
}

class UserProfileState extends State<UserProfile> {
  var height;
  var width;
  var myId;

  final String imageUrl;
  final String username;
  final String about;
  final String userId;

  UserProfileState(this.imageUrl, this.username, this.about, this.userId);

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      myId = sp.getString(SHARED_PREFERENCES_USER_ID);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(title: Text('profile')),
      body: Card(
        margin: EdgeInsets.all(8.0),
        elevation: 8.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 4.0,
              child: CachedNetworkImage(
                width: width,
                height: height * 0.45,
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
              ),
            ),
            Card(
                elevation: 4.0,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: width,
                  child: Text(
                    username,
                    style: TextStyle(fontSize: 22.0),
                  ),
                )),
            Card(
                elevation: 4.0,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: width,
                  child: Text(
                    about,
                    style: TextStyle(fontSize: 18.0),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Icon(
            Icons.delete,
          ),
          onPressed: () => _deleteFriend()),
    );
  }

  _deleteFriend() {
    //deleteUser
    deleteUser(userId, myId).then((v) {
      //redirect to MainScreen
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }
}
