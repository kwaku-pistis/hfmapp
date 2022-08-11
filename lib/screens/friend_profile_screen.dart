import 'dart:async';

import 'package:HFM/models/like.dart';
import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/comments_screen.dart';
import 'package:HFM/screens/likes_screen.dart';
import 'package:HFM/screens/post_detail_screen.dart';
import 'package:HFM/themes/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FriendProfileScreen extends StatefulWidget {
  final String name;
  const FriendProfileScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}
class _FriendProfileScreenState extends State<FriendProfileScreen> {
  late String currentUserId, followingUserId;
  final _repository = Repository();
  Color _gridColor = colorTheme.primaryColorDark;
  Color _listColor = Colors.grey;
  bool _isGridActive = true;
  late User _user, currentUser;
  late IconData icon;
  late Color color;
  late Future<List<DocumentSnapshot>> _future;
  //bool _isLiked = false;
  bool isFollowing = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _repository.fetchUidBySearchedName(name);
    setState(() {
      followingUserId = uid;
    });
    fetchUserDetailsById(uid);
    _future = _repository.retrieveUserPosts(uid);
  }

  fetchUserDetailsById(String userId) async {
    User user = await _repository.fetchUserDetailsById(userId);
    setState(() {
      _user = user;
      print("USER : ${_user.name}");
    });
  }

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _repository.fetchUserDetailsById(user.uid).then((currentUser) {
        setState(() {
          currentUser = currentUser;
        });
      });
      _repository.checkIsFollowing(widget.name, user.uid).then((value) {
        print("VALUE : $value");
        setState(() {
          isFollowing = value;
        });
      });
      setState(() {
        currentUserId = user.uid;
      });
    });
    fetchUidBySearchedName(widget.name);
  }

  followUser() {
    print('following user');
    _repository.followUser(
        currentUserId: currentUserId, followingUserId: followingUserId);
    setState(() {
      isFollowing = true;
      followButtonClicked = true;
    });
  }

  unFollowUser() {
    _repository.unFollowUser(
        currentUserId: currentUserId, followingUserId: followingUserId);
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
  }

  Widget buildButton(
      {required String text,
      required Color backgroundColor,
      required Color textColor,
      required Color borderColor,
      required Function()? function}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 210.0,
        height: 30.0,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: borderColor)),
        child: Center(
          child: Text(text, style: TextStyle(color: textColor)),
        ),
      ),
    );
  }

  Widget buildProfileButton() {
    // already following user - should show unfollow button
    if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey,
        function: unFollowUser,
      );
    }

    // does not follow user - should show follow button
    if (!isFollowing) {
      return buildButton(
        text: "Follow",
        backgroundColor: colorTheme.primaryColorDark,
        textColor: Colors.white,
        borderColor: colorTheme.primaryColorDark,
        function: followUser,
      );
    }

    return buildButton(
        text: "loading...",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey,
        function: () {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorTheme.primaryColor,
          elevation: 1,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _user != null
            ? ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                              AssetImage('assets/images/adinkra_pattern.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 0.0),
                              child: Container(
                                  width: 110.0,
                                  height: 110.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80.0),
                                    image: DecorationImage(
                                        image: _user.profileImage!.isEmpty
                                            ? const AssetImage(
                                                'assets/images/profile.png')
                                            : NetworkImage(_user.profileImage!)
                                                as ImageProvider,
                                        fit: BoxFit.cover),
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, top: 10.0),
                              child: Text(_user.name!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20.0, top: 10.0),
                              child: Text(
                                  _user.username!.isEmpty
                                      ? '@username'
                                      : _user.username!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      StreamBuilder(
                                        stream: _repository
                                            .fetchStats(
                                                uid: followingUserId,
                                                label: 'posts')
                                            .asStream(),
                                        builder: ((context,
                                            AsyncSnapshot<
                                                    List<DocumentSnapshot>>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return detailsWidget(
                                                snapshot.data!.length
                                                    .toString(),
                                                'posts');
                                          } else {
                                            return const Center(
                                              child:
                                                 CircularProgressIndicator(),
                                            );
                                          }
                                        }),
                                      ),

                                      StreamBuilder(
                                        stream: _repository
                                            .fetchStats(
                                                uid: followingUserId,
                                                label: 'followers')
                                            .asStream(),
                                        builder: ((context,
                                            AsyncSnapshot<
                                                    List<DocumentSnapshot>>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 24.0),
                                              child: detailsWidget(
                                                  snapshot.data!.length
                                                      .toString(),
                                                  'followers'),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                 CircularProgressIndicator(),
                                            );
                                          }
                                        }),
                                      ),

                                      StreamBuilder(
                                        stream: _repository
                                            .fetchStats(
                                                uid: followingUserId,
                                                label: 'following')
                                            .asStream(),
                                        builder: ((context,
                                            AsyncSnapshot<
                                                    List<DocumentSnapshot>>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: detailsWidget(
                                                  snapshot.data!.length
                                                      .toString(),
                                                  'following'),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        }),
                                      ),

                                      //   detailsWidget(_user.posts, 'posts'),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0,
                                        left: 20.0,
                                        right: 20.0,
                                        bottom: 0),
                                    child: buildProfileButton(),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 0.0),
                    child:
                        _user.bio!.isNotEmpty ? Text(_user.bio!) : Container(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            Icons.grid_on,
                            color: _gridColor,
                          ),
                          onTap: () {
                            setState(() {
                              _isGridActive = true;
                              _gridColor = colorTheme.primaryColorDark;
                              _listColor = Colors.grey;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.stay_current_portrait,
                            color: _listColor,
                          ),
                          onTap: () {
                            setState(() {
                              _isGridActive = false;
                              _listColor = colorTheme.primaryColorDark;
                              _gridColor = Colors.grey;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: postImagesWidget(),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget postImagesWidget() {
    return _isGridActive == true
        ? FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0),
                    itemBuilder: ((context, index) {
                      // return GestureDetector(
                      //   child: CachedNetworkImage(
                      //     imageUrl: snapshot.data[index].data['imgUrl'],
                      //     placeholder: ((context, s) => Center(
                      //           child: CircularProgressIndicator(),
                      //         )),
                      //     width: 125.0,
                      //     height: 125.0,
                      //     fit: BoxFit.cover,
                      //   ),
                      //   onTap: () {
                      //     print(
                      //         "SNAPSHOT : ${snapshot.data[index].reference.path}");
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: ((context) => PostDetailScreen(
                      //                   user: _user,
                      //                   currentUser: currentUser,
                      //                   documentSnapshot: snapshot.data[index],
                      //                 ))));
                      //   },
                      // );
                      var img = snapshot.data![index]['imgUrl'];
                      return GestureDetector(
                        child: img != ""
                            ? CachedNetworkImage(
                                imageUrl: snapshot.data![index]['imgUrl'],
                                placeholder: ((context, s) => Center(
                                      child: img != ""
                                          ? const CircularProgressIndicator()
                                          : Container(),
                                    )),
                                width: 125.0,
                                height: 125.0,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 125.0,
                                height: 125.0,
                                padding: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                child: Text(
                                  snapshot.data![index]['caption'],
                                  style: const TextStyle(color: Colors.black),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                        onTap: () {
                          print(
                              "SNAPSHOT : ${snapshot.data![index].reference.path}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => PostDetailScreen(
                                        user: _user,
                                        currentUser: _user,
                                        documentSnapshot: snapshot.data![index],
                                      ))));
                        },
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('No Posts Found'),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: CircularProgressIndicator());
            }),
          )
        : FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    child: SizedBox(
                        height: 600.0,
                        child: ListView.builder(
                            //shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: ((context, index) => ListItem(
                                list: snapshot.data!,
                                index: index,
                                user: _user,
                                currentUser: currentUser)))),
                  );
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

  Widget detailsWidget(String count, String label) {
    return Column(
      children: <Widget>[
        Text(count,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black)),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child:
              Text(label, style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
        )
      ],
    );
  }
}

class ListItem extends StatefulWidget {
  final List<DocumentSnapshot> list;
  final User user, currentUser;
  final int index;

  const ListItem(
      {Key? key, required this.list,
      required this.user,
      required this.index,
      required this.currentUser}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _repository = Repository();
  bool _isLiked = false;
  // late Future<List<DocumentSnapshot>> _future;

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
                            user: widget.currentUser,
                          ))));
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    print("INDEX : ${widget.index}");
  }

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(widget.user.profileImage!)),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.user.name!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      widget.list[widget.index]['location'] != null
                          ? Text(
                              widget.list[widget.index]['location'],
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
        CachedNetworkImage(
          imageUrl: widget.list[widget.index]['imgUrl'],
          placeholder: ((context, s) => const Center(
                child: CircularProgressIndicator(),
              )),
          width: 125.0,
          height: 250.0,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      child: _isLiked
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              FontAwesomeIcons.heart,
                              color: null,
                            ),
                      onTap: () {
                        if (!_isLiked) {
                          setState(() {
                            _isLiked = true;
                          });

                          postLike(widget.list[widget.index].reference);
                        } else {
                          setState(() {
                            _isLiked = false;
                          });

                          postUnlike(widget.list[widget.index].reference);
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
                                    documentReference:
                                        widget.list[widget.index].reference,
                                    user: widget.currentUser,
                                  ))));
                    },
                    child: const Icon(
                      FontAwesomeIcons.comment,
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  const Icon(FontAwesomeIcons.paperPlane),
                ],
              ),
              const Icon(FontAwesomeIcons.bookmark)
            ],
          ),
        ),
        FutureBuilder(
          future:
              _repository.fetchPostLikes(widget.list[widget.index].reference),
          builder:
              ((context, AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
            if (likesSnapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => LikesScreen(
                                user: widget.user,
                                documentReference:
                                    widget.list[widget.index].reference,
                              ))));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: likesSnapshot.data!.length > 1
                      ? Text(
                          "Liked by ${likesSnapshot.data![0]['ownerName']} and ${(likesSnapshot.data!.length - 1).toString()} others",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(likesSnapshot.data!.length == 1
                          ? "Liked by ${likesSnapshot.data![0]['ownerName']}"
                          : "0 Likes"),
                ),
              );
            } else {
              return const Center(child: const CircularProgressIndicator());
            }
          }),
        ),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: widget.list[widget.index]['caption'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Text(widget.user.name!,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child:
                                Text(widget.list[widget.index]['caption']),
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: commentWidget(
                              widget.list[widget.index].reference))
                    ],
                  )
                : commentWidget(widget.list[widget.index].reference)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
        )
      ],
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
        .doc(widget.currentUser.uid)
        .set(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .doc(widget.currentUser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}
