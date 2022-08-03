import 'dart:async';

import 'package:HFM/models/like.dart';
import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/comments_screen.dart';
import 'package:HFM/screens/friend_profile_screen.dart';
import 'package:HFM/screens/likes_screen.dart';
import 'package:HFM/screens/messages.dart';
import 'package:HFM/screens/photo_view.dart';
import 'package:HFM/screens/search_screen.dart';
import 'package:HFM/screens/upload_photo_screen.dart';
import 'package:HFM/themes/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

var timeDiff;
String packageName = '';

class _FeedScreenState extends State<FeedScreen> {
  var _repository = Repository();
  late User currentUser, user, followingUser;
  late IconData icon;
  late Color color;
  List<User> usersList = [];
  late Future<List<DocumentSnapshot>> _future, _userPosts;
  // bool _isLiked = false;
  List<String> followingUIDs = [];

  List<int> _indexes = [];

  @override
  void initState() {
    super.initState();
    fetchFeed();
  }

  void fetchFeed() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

    setState(() {
      _userPosts = _repository.retrieveUserPosts(currentUser.uid);
    });
    followingUIDs = await _repository.fetchFollowingUids(currentUser);

    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DSDASDASD : ${followingUIDs[i]}");
      // _future = _repository.retrievePostByUID(followingUIDs[i]);
      this.user = await _repository.fetchUserDetailsById(followingUIDs[i]);
      print("user : ${this.user.uid}");
      usersList.add(this.user);
      print("USERSLIST : ${usersList.length}");

      for (var i = 0; i < usersList.length; i++) {
        setState(() {
          followingUser = usersList[i];
          print("FOLLOWING USER : ${followingUser.uid}");
        });
      }
    }
    _future = _repository.fetchFeed(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xfff8faf8),
        centerTitle: false,
        elevation: 1.0,
        leading: new Icon(
          Icons.people,
          color: Colors.red,
        ),
        title: Text(
          'Share a post or image from here...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: colortheme.accentColor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => UploadPhotoScreen())));
              },
            ),
          )
        ],
      ),
      floatingActionButton: UnicornDialer(
        parentButtonBackground: colortheme.accentColor,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.search),
        childButtons: _getProfileMenu(),
      ),
      body: currentUser != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: followingUIDs.length != 0 || _userPosts != null
                  ? postImagesWidget()
                  : Center(
                      child: Text(
                          'No posts yet. Start a post or follow others to see their posts.'),
                    ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(_profileOption(
        iconData: Icons.people,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SearchScreen()));
        },
        heroTag: 'btn1') as UnicornButton );
    children.add(_profileOption(
        iconData: Icons.message,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => Messages()));
        },
        heroTag: 'btn2') as UnicornButton );

    return children;
  }

  Widget _profileOption(
      {IconData? iconData, Function()? onPressed, String? heroTag}) {
    return UnicornButton(
        currentButton: FloatingActionButton(
      backgroundColor: Colors.grey[500],
      mini: true,
      child: Icon(iconData),
      onPressed: onPressed,
      heroTag: heroTag,
    ));
  }

  Widget postImagesWidget() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      packageName = packageInfo.packageName;
    });
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          print("FFFF : ${followingUser.uid}");
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                //shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) => listItem(
                      list: snapshot.data!,
                      index: index,
                      user: followingUser,
                      currentUser: currentUser,
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget listItem(
      {List<DocumentSnapshot>? list, User? user, User? currentUser, int? index}) {
    print("dadadadad : ${user!.uid}");
    print("datetime: ${DateTime.now()}");
    var temp = list![index!].data['postTime'];
    var diff = DateTime.parse(temp);
    timeDiff = Jiffy(diff).fromNow();

    // var sorted_list = list.sort();
    // var item = sorted_list[index]

    //if ()
    _repository
        .checkIfUserLikedOrNot(currentUser!.uid!, list[index].reference)
        .then((isLiked) {
      // print("reef : ${list[index].data[index].reference.path}");
      if (isLiked) {
        if (!_indexes.contains(index)) {
          setState(() {
            _indexes.add(index);
          });
        }
        // postLike(list[index].data[index].reference, currentUser);
      }
    });

    return Column(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => FriendProfileScreen(
                                    name: list[index].data['postOwnerName'],
                                  ))));
                    },
                    child: new Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                list[index].data['postOwnerPhotoUrl'])),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => FriendProfileScreen(
                                        name: list[index].data['postOwnerName'],
                                      ))));
                        },
                        child: new Text(
                          list[index].data['postOwnerName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      list[index].data['location'] != null
                          ? new Text(
                              list[index].data['location'],
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
            child: list[index].data['caption'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          SelectableLinkify(
                            text: list[index].data['caption'],
                            onOpen: (link) async {
                              if (await canLaunch(link.url)) {
                                await launch(link.url);
                              } else {
                                throw 'Could not launch $link';
                              }
                            },
                            linkStyle: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  )
                : commentWidget(list[index].reference)),
        GestureDetector(
          child: CachedNetworkImage(
            imageUrl: list[index].data['imgUrl'],
            placeholder: ((context, s) => Center(
                  child: list[index].data['imgUrl'] == null
                      ? CircularProgressIndicator()
                      : Container(),
                )),
            width: 125.0,
            height: 250.0,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ImageView(imageUrl: list[index].data['imgUrl'])));

            // PhotoView(imageProvider: null)
          },
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 50.0, top: 16, right: 50, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  child: _indexes.contains(index)
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(
                          FontAwesomeIcons.heart,
                          color: null,
                        ),
                  onTap: () {
                    if (!_indexes.contains(index)) {
                      setState(() {
                        // _isLiked = true;
                        _indexes.add(index);
                      });
                      // saveLikeValue(_isLiked);
                      postLike(list[index].reference, currentUser);
                    } else {
                      setState(() {
                        // _isLiked = false;
                        _indexes.remove(index);
                      });
                      //saveLikeValue(_isLiked);
                      postUnlike(list[index].reference, currentUser);
                    }
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
                                documentReference: list[index].reference,
                                user: currentUser,
                              ))));
                },
                child: new Icon(
                  FontAwesomeIcons.comment,
                ),
              ),
              new SizedBox(
                width: 16.0,
              ),
              GestureDetector(
                child: new Icon(FontAwesomeIcons.shareSquare),
                onTap: () {
                  Share.share(
                      '${list[index].data['caption']} \n\nShared via the HarvestFields app. Get the app from https://play.google.com/store/apps/details?id=$packageName');
                },
              ),
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
              future: _repository.fetchPostLikes(list[index].reference),
              builder: ((context,
                  AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                if (likesSnapshot.hasData) {
                  // if (likesSnapshot.data[0].data['ownerUid'] == currentUser.uid) {
                  //   setState(() {
                  //     _isLiked = true;
                  //   });
                  // }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LikesScreen(
                                    user: currentUser,
                                    documentReference: list[index].reference,
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
          child: commentWidget(list[index].reference),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("$timeDiff", style: TextStyle(color: Colors.grey)),
        )
      ],
    );
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
                            user: currentUser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  // _checkifUserLikedaPost() async {
  //   _repository.checkIfUserLikedOrNot(currentUser.uid, list[index].reference).then((isLiked) {
  //     // print("reef : ${list[index].data[index].reference.path}");
  //     if (isLiked) {
  //       setState(() {
  //         icon = Icons.favorite;
  //         color = Colors.red;
  //       });
  //       // postLike(list[index].data[index].reference, currentUser);
  //     } else {

  //       setState(() {
  //         icon =FontAwesomeIcons.heart;
  //         color = null;
  //       });
  //       // postUnlike(list[index].data[index].reference, currentUser);
  //     }
  //   });
  // }

  void postLike(DocumentReference reference, User currentUser) {
    var _like = Like(
        ownerName: currentUser.name!,
        ownerPhotoUrl: currentUser.profileImage!,
        ownerUid: currentUser.uid!,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(currentUser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference, User currentUser) {
    reference
        .collection("likes")
        .document(currentUser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}

// class ListItem extends StatefulWidget {
//   final List<DocumentSnapshot> list;
//   final User user;
//   final User currentUser;
//   final int index;

//   ListItem({this.list, this.user, this.index, this.currentUser});

//   @override
//   _ListItemState createState() => _ListItemState();
// }

// class _ListItemState extends State<ListItem> {
//   var _repository = Repository();
//   bool _isLiked = false;
//   Future<List<DocumentSnapshot>> _future;

//   @override
//   Widget build(BuildContext context) {
//     print("USERRR : ${widget.user.uid}");
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   new Container(
//                     height: 40.0,
//                     width: 40.0,
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: new DecorationImage(
//                           fit: BoxFit.fill,
//                           image: new NetworkImage(widget.user.photoUrl)),
//                     ),
//                   ),
//                   new SizedBox(
//                     width: 10.0,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       new Text(
//                         widget.user.displayName,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       widget.list[widget.index].data['location'] != null
//                           ? new Text(
//                               widget.list[widget.index].data['location'],
//                               style: TextStyle(color: Colors.grey),
//                             )
//                           : Container(),
//                     ],
//                   )
//                 ],
//               ),
//               new IconButton(
//                 icon: Icon(Icons.more_vert),
//                 onPressed: null,
//               )
//             ],
//           ),
//         ),
//         CachedNetworkImage(
//           imageUrl: widget.list[widget.index].data['imgUrl'],
//           placeholder: ((context, s) => Center(
//                 child: CircularProgressIndicator(),
//               )),
//           width: 125.0,
//           height: 250.0,
//           fit: BoxFit.cover,
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               new Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   GestureDetector(
//                       child: _isLiked
//                           ? Icon(
//                               Icons.favorite,
//                               color: Colors.red,
//                             )
//                           : Icon(
//                               FontAwesomeIcons.heart,
//                               color: null,
//                             ),
//                       onTap: () {
//                         if (!_isLiked) {
//                           setState(() {
//                             _isLiked = true;
//                           });
//                           // saveLikeValue(_isLiked);
//                           postLike(widget.list[widget.index].reference);
//                         } else {
//                           setState(() {
//                             _isLiked = false;
//                           });
//                           //saveLikeValue(_isLiked);
//                           postUnlike(widget.list[widget.index].reference);
//                         }

//                         // _repository.checkIfUserLikedOrNot(_user.uid, snapshot.data[index].reference).then((isLiked) {
//                         //   print("reef : ${snapshot.data[index].reference.path}");
//                         //   if (!isLiked) {
//                         //     setState(() {
//                         //       icon = Icons.favorite;
//                         //       color = Colors.red;
//                         //     });
//                         //     postLike(snapshot.data[index].reference);
//                         //   } else {

//                         //     setState(() {
//                         //       icon =FontAwesomeIcons.heart;
//                         //       color = null;
//                         //     });
//                         //     postUnlike(snapshot.data[index].reference);
//                         //   }
//                         // });
//                         // updateValues(
//                         //     snapshot.data[index].reference);
//                       }),
//                   new SizedBox(
//                     width: 16.0,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: ((context) => CommentsScreen(
//                                     documentReference:
//                                         widget.list[widget.index].reference,
//                                     user: widget.currentUser,
//                                   ))));
//                     },
//                     child: new Icon(
//                       FontAwesomeIcons.comment,
//                     ),
//                   ),
//                   new SizedBox(
//                     width: 16.0,
//                   ),
//                   new Icon(FontAwesomeIcons.paperPlane),
//                 ],
//               ),
//               new Icon(FontAwesomeIcons.bookmark)
//             ],
//           ),
//         ),
//         FutureBuilder(
//           future:
//               _repository.fetchPostLikes(widget.list[widget.index].reference),
//           builder:
//               ((context, AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
//             if (likesSnapshot.hasData) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: ((context) => LikesScreen(
//                                 user: widget.currentUser,
//                                 documentReference:
//                                     widget.list[widget.index].reference,
//                               ))));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: likesSnapshot.data.length > 1
//                       ? Text(
//                           "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )
//                       : Text(likesSnapshot.data.length == 1
//                           ? "Liked by ${likesSnapshot.data[0].data['ownerName']}"
//                           : "0 Likes"),
//                 ),
//               );
//             } else {
//               return Center(child: CircularProgressIndicator());
//             }
//           }),
//         ),
//         Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: widget.list[widget.index].data['caption'] != null
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Wrap(
//                         children: <Widget>[
//                           Text(widget.user.displayName,
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child:
//                                 Text(widget.list[widget.index].data['caption']),
//                           )
//                         ],
//                       ),
//                       Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: commentWidget(
//                               widget.list[widget.index].reference))
//                     ],
//                   )
//                 : commentWidget(widget.list[widget.index].reference)),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
//         )
//       ],
//     );
//   }

//   Widget commentWidget(DocumentReference reference) {
//     return FutureBuilder(
//       future: _repository.fetchPostComments(reference),
//       builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
//         if (snapshot.hasData) {
//           return GestureDetector(
//             child: Text(
//               'View all ${snapshot.data.length} comments',
//               style: TextStyle(color: Colors.grey),
//             ),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: ((context) => CommentsScreen(
//                             documentReference: reference,
//                             user: widget.currentUser,
//                           ))));
//             },
//           );
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       }),
//     );
//   }

//   void postLike(DocumentReference reference) {
//     var _like = Like(
//         ownerName: widget.currentUser.displayName,
//         ownerPhotoUrl: widget.currentUser.photoUrl,
//         ownerUid: widget.currentUser.uid,
//         timeStamp: FieldValue.serverTimestamp());
//     reference
//         .collection('likes')
//         .document(widget.currentUser.uid)
//         .setData(_like.toMap(_like))
//         .then((value) {
//       print("Post Liked");
//     });
//   }

//   void postUnlike(DocumentReference reference) {
//     reference
//         .collection("likes")
//         .document(widget.currentUser.uid)
//         .delete()
//         .then((value) {
//       print("Post Unliked");
//     });
//   }
// }
