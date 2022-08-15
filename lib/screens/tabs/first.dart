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
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

var timeDiff;
String packageName = '';

class _FeedScreenState extends State<FeedScreen> {
  final _repository = Repository();
  User? currentUser = User();
  User? user = User();
  User? followingUser = User();
  late IconData icon;
  late Color color;
  List<User> usersList = [];
  Future<List<DocumentSnapshot>> _future = Future.value([]);
  Future<List<DocumentSnapshot>> _userPosts = Future.value([]);
  // bool _isLiked = false;
  List<String> followingUIDs = [];

  final List<int> _indexes = [];

  @override
  void initState() {
    super.initState();
    fetchFeed();
  }

  void fetchFeed() async {
    auth.User currentUser = await _repository.getCurrentUser();

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
      print("user : ${this.user!.uid}");
      usersList.add(this.user!);
      print("USERS_LIST : ${usersList.length}");

      for (var i = 0; i < usersList.length; i++) {
        setState(() {
          followingUser = usersList[i];
          print("FOLLOWING USER : ${followingUser!.uid}");
        });
      }
    }
    _future = _repository.fetchFeed(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff8faf8),
        centerTitle: false,
        elevation: 1.0,
        leading: const Icon(
          Icons.people,
          color: Colors.red,
        ),
        title: const Text(
          'Share a post or image from here...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: colorTheme.primaryColorDark,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const UploadPhotoScreen())));
              },
            ),
          )
        ],
      ),
      // floatingActionButton: UnicornDialer(
      //   parentButtonBackground: colorTheme.primaryColorDark,
      //   orientation: UnicornOrientation.VERTICAL,
      //   parentButton: const Icon(Icons.search),
      //   childButtons: _getProfileMenu(),
      // ),
      floatingActionButton: AnimatedFloatingActionButton(
        fabButtons: _getProfileMenu(),
        animatedIconData: AnimatedIcons.menu_close,
      ),
      body: currentUser != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: followingUIDs.isNotEmpty || _userPosts != null
                  ? postImagesWidget()
                  : const Center(
                      child: Text(
                          'No posts yet. Start a post or follow others to see their posts.'),
                    ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  List<Widget> _getProfileMenu() {
    List<Widget> children = [];

    // Add Children here
    children.add(_profileOption(
        iconData: Icons.people,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const SearchScreen()));
        },
        heroTag: 'btn1'));
    children.add(_profileOption(
        iconData: Icons.message,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const Messages()));
        },
        heroTag: 'btn2'));

    return children;
  }

  Widget _profileOption(
      {IconData? iconData, Function()? onPressed, String? heroTag}) {
    return SizedBox(
        child: FloatingActionButton(
      backgroundColor: Colors.grey[500],
      mini: true,
      onPressed: onPressed,
      heroTag: heroTag,
      child: Icon(iconData),
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
          print("Followers Ids : ${followingUser!.uid}");
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget listItem(
      {List<DocumentSnapshot>? list,
      User? user,
      User? currentUser,
      int? index}) {
    print("dadadadad : ${user!.uid}");
    print("dateTime: ${DateTime.now()}");
    var temp = list![index!]['postTime'];
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
                                    name: list[index]['postOwnerName'],
                                  ))));
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image:
                                NetworkImage(list[index]['postOwnerPhotoUrl'])),
                      ),
                    ),
                  ),
                  const SizedBox(
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
                                        name: list[index]['postOwnerName'],
                                      ))));
                        },
                        child: Text(
                          list[index]['postOwnerName'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      list[index]['location'] != null
                          ? Text(
                              list[index]['location'],
                              style: const TextStyle(color: Colors.grey),
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
              const IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: null,
              )
            ],
          ),
        ),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: list[index]['caption'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          SelectableLinkify(
                            text: list[index]['caption'],
                            onOpen: (link) async {
                              if (await canLaunchUrlString(link.url)) {
                                await launchUrlString(link.url);
                              } else {
                                throw 'Could not launch $link';
                              }
                            },
                            linkStyle:
                                const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  )
                : commentWidget(list[index].reference)),
        GestureDetector(
          child: CachedNetworkImage(
            imageUrl: list[index]['imgUrl'],
            placeholder: ((context, s) => Center(
                  child: list[index]['imgUrl'] == null
                      ? const CircularProgressIndicator()
                      : Container(),
                )),
            width: 125.0,
            height: 250.0,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ImageView(imageUrl: list[index]['imgUrl'])));

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
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(
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
              const SizedBox(
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
                child: const Icon(
                  FontAwesomeIcons.comment,
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              GestureDetector(
                child: const Icon(FontAwesomeIcons.shareFromSquare),
                onTap: () {
                  Share.share(
                      '${list[index]['caption']} \n\nShared via the HarvestFields app. Get the app from https://play.google.com/store/apps/details?id=$packageName');
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
                              "Liked by ${likesSnapshot.data![0]['ownerName']} and ${(likesSnapshot.data!.length - 1).toString()} others",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(likesSnapshot.data!.length == 1
                              ? "Liked by ${likesSnapshot.data![0]['ownerName']}"
                              : "0 Likes"),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
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
          child: Text("$timeDiff", style: const TextStyle(color: Colors.grey)),
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
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: currentUser!,
                          ))));
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
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
        .doc(currentUser.uid)
        .set(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference, User currentUser) {
    reference.collection("likes").doc(currentUser.uid).delete().then((value) {
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
