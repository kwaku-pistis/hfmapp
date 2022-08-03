import 'package:HFM/models/like.dart';
import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/comments_screen.dart';
import 'package:HFM/screens/likes_screen.dart';
import 'package:HFM/themes/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';

class PostDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentUser;

  PostDetailScreen({required this.documentSnapshot, required this.user, required this.currentUser});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  var _repository = Repository();
  bool _isLiked = false;
  var timeDiff;

  @override
  Widget build(BuildContext context) {

    var temp = widget.documentSnapshot.data['postTime'];
    var diff = DateTime.parse(temp);
    timeDiff =  Jiffy(diff).fromNow();

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: colortheme.primaryColor,
          title: Text(
            'Post Detail',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: ((context) => FriendProfileScreen(
                          //               name: list[index].data['postOwnerName'],
                          //             ))));
                        },
                        child: new Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(widget.documentSnapshot
                                    .data['postOwnerPhotoUrl'])),
                          ),
                        ),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: ((context) => FriendProfileScreen(
                              //               name: list[index].data['postOwnerName'],
                              //             ))));
                            },
                            child: new Text(
                              widget.documentSnapshot.data['postOwnerName'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          widget.documentSnapshot.data['location'] != null
                              ? new Text(
                                  widget.documentSnapshot.data['location'],
                                  style: TextStyle(color: Colors.grey),
                                )
                              : Container(),
                        ],
                      )
                    ],
                  ),
                  new IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: null,
                  )
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: widget.documentSnapshot.data['caption'] != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              // Text(widget.documentSnapshot.data['postOwnerName'],
                              //     style: TextStyle(fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Text(
                                    widget.documentSnapshot.data['caption']),
                              )
                            ],
                          ),
                        ],
                      )
                    : commentWidget(widget.documentSnapshot.reference)),
            CachedNetworkImage(
              imageUrl: widget.documentSnapshot.data['imgUrl'],
              placeholder: ((context, s) => Center(
                    child: widget.documentSnapshot.data['imgUrl'] == null
                        ? CircularProgressIndicator()
                        : Container(),
                  )),
              width: 125.0,
              height: 250.0,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50.0, top: 16, right: 50, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      child: _isLiked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              FontAwesomeIcons.heart,
                              color: null,
                            ),
                      onTap: () {
                        if (!_isLiked) {
                          setState(() {
                            _isLiked = true;
                          });
                          // saveLikeValue(_isLiked);
                          postLike(widget.documentSnapshot.reference);
                        } else {
                          setState(() {
                            _isLiked = false;
                          });
                          //saveLikeValue(_isLiked);
                          postUnlike(widget.documentSnapshot.reference);
                        }

                        // _repository.checkIfUserLikedOrNot(_user.uid, snapshot.data[index].reference).then((isLiked) {
                        //   print("reef : ${snapshot.data[index].reference.path}");
                        //   if (!isLiked) {
                        //     setState(() {
                        //       icon = Icons.favorite;
                        //       color = Colors.red;
                        //     });
                        //     postLike(snapshot.data[index].reference);
                        //   } else {

                        //     setState(() {
                        //       icon =FontAwesomeIcons.heart;
                        //       color = null;
                        //     });
                        //     postUnlike(snapshot.data[index].reference);
                        //   }
                        // });
                        // updateValues(
                        //     snapshot.data[index].reference);
                      }),
                  new SizedBox(
                    width: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => CommentsScreen(
                                    documentReference:
                                        widget.documentSnapshot.reference,
                                    user: widget.currentUser,
                                  ))));
                    },
                    child: new Icon(
                      FontAwesomeIcons.comment,
                    ),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Icon(FontAwesomeIcons.shareSquare),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[

                  //   ],
                  // ),
                  // new Icon(FontAwesomeIcons.bookmark)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FutureBuilder(
                  future: _repository
                      .fetchPostLikes(widget.documentSnapshot.reference),
                  builder: ((context,
                      AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                    if (likesSnapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => LikesScreen(
                                        user: widget.currentUser,
                                        documentReference:
                                            widget.documentSnapshot.reference,
                                      ))));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: likesSnapshot.data!.length > 1
                              ? Text(
                                  "Liked by ${likesSnapshot.data![0].data['ownerName']} and ${(likesSnapshot.data!.length - 1).toString()} others",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Text(likesSnapshot.data!.length == 1
                                  ? "Liked by ${likesSnapshot.data![0].data['ownerName']}"
                                  : "0 Likes"),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
                  child: commentWidget(widget.documentSnapshot.reference),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("$timeDiff", style: TextStyle(color: Colors.grey)),
            )
          ],
        ));
  }

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data!.length} comments',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: widget.currentUser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.currentUser.name!,
        ownerPhotoUrl: widget.currentUser.profileImage!,
        ownerUid: widget.currentUser.uid!,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(widget.currentUser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .document(widget.currentUser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}
