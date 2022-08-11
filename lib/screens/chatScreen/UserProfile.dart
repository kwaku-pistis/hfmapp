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

  const UserProfile(
      {Key? key,
      required this.imageUrl,
      required this.username,
      required this.about,
      required this.id})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  var height = 0.0;
  var width = 0.0;
  var myId = '';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      myId = sp.getString(SHARED_PREFERENCES_USER_ID)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('profile')),
      body: Card(
        margin: const EdgeInsets.all(8.0),
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
                imageUrl: widget.imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
              ),
            ),
            Card(
                elevation: 4.0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: width,
                  child: Text(
                    widget.username,
                    style: const TextStyle(fontSize: 22.0),
                  ),
                )),
            Card(
                elevation: 4.0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: width,
                  child: Text(
                    widget.about,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: const Icon(
            Icons.delete,
          ),
          onPressed: () => _deleteFriend()),
    );
  }

  _deleteFriend() {
    //deleteUser
    deleteUser(widget.id, myId).then((v) {
      //redirect to MainScreen
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }
}
