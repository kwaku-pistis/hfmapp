import 'dart:async';

import 'package:HFM/Consts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

///appBar
class ChatAppBar extends StatefulWidget {
  final String photoUri;
  final String displayName;
  final String id;
  final String about;

  const ChatAppBar(
      {Key? key,
      required this.photoUri,
      required this.displayName,
      required this.id,
      required this.about})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatAppBarState();
}

class ChatAppBarState extends State<ChatAppBar> {
  String userStatus = '';

  late StreamSubscription<DatabaseEvent> stateListener;

  @override
  void initState() {
    super.initState();
    stateListener = FirebaseDatabase.instance
        .ref()
        .child('/status/${widget.id}')
        .onValue
        .listen((event) {
      setState(() {
        userStatus = event.snapshot.children.first.value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          //user image
          Material(
            borderRadius:
                const BorderRadius.all(Radius.circular(APP_BAR_IMAGE_RADIUS)),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              placeholder: (context, url) => const CircularProgressIndicator(),
              imageUrl: widget.photoUri,
              width: APP_BAR_IMAGE_WIDTH,
              height: APP_BAR_IMAGE_HEIGHT,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 8.0, left: 10),
                  child: Text(
                    widget.displayName,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Text(userStatus,
                    style: const TextStyle(fontSize: 10.0, color: Colors.white))
              ],
            ),
          )
        ],
      ),
      onTap: () {},
    );
  }

  @override
  void dispose() {
    stateListener.cancel();
    super.dispose();
  }
}
