import 'package:HFM/models/like.dart';
import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/accounts/edit_profile_screen.dart';
import 'package:HFM/screens/comments_screen.dart';
import 'package:HFM/screens/likes_screen.dart';
import 'package:HFM/screens/post_detail_screen.dart';
import 'package:HFM/themes/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

String name = '', username = '', profileImage = '', uuid = '';
late User _user;
bool _isGridActive = true;
Color _gridColor = colorTheme.primaryColorDark;
Color _listColor = Colors.grey;
var timeDiff;

class _ProfileDetailsState extends State<ProfileDetails> {
  final _repository = Repository();
  late Future<List<DocumentSnapshot>> _future;

  @override
  void initState() {
    super.initState();

    //_retrieveLocalData();
    retrieveUserDetails();
  }

  retrieveUserDetails() async {
    auth.User currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;
      name = _user.name!;
      username = _user.username!;
      profileImage = _user.profileImage!;
      uuid = _user.uid!;
    });
    _future = _repository.retrieveUserPosts(uuid);
  }

  @override
  Widget build(BuildContext context) {
    //final _width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colorTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/adinkra_pattern.png'),
                  fit: BoxFit.cover,
                )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: profileImage == null
                                ? const AssetImage('assets/images/profile.png')
                                : NetworkImage(profileImage) as ImageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          username != null ? '@$username' : '@username',
                          style: const TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, left: 20.0, right: 20.0),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            margin: const EdgeInsets.only(top: 40),
                            width: 210.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: colorTheme.primaryColorDark,
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(color: Colors.grey)),
                            child: const Center(
                              child: Text('Edit Profile',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => EditProfileScreen(
                                      photoUrl: _user.profileImage!,
                                      email: _user.email!,
                                      bio: _user.bio!,
                                      name: _user.name!,
                                      username: _user.username!))
                                  //builder: ((context) => null)
                                  ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: height / 30,
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  StreamBuilder(
                    stream: _repository
                        .fetchStats(uid: uuid, label: 'posts')
                        .asStream(),
                    builder: ((context,
                        AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                      if (snapshot.hasData) {
                        return detailsWidget(
                            snapshot.data!.length.toString(), 'posts');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  ),
                  StreamBuilder(
                    stream: _repository
                        .fetchStats(uid: uuid, label: 'followers')
                        .asStream(),
                    builder: ((context,
                        AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: detailsWidget(
                              snapshot.data!.length.toString(), 'followers'),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  ),
                  StreamBuilder(
                    stream: _repository
                        .fetchStats(uid: uuid, label: 'following')
                        .asStream(),
                    builder: ((context,
                        AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: detailsWidget(
                              snapshot.data!.length.toString(), 'following'),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  ),
                ],
              ),
              Divider(height: height / 30, color: Colors.black),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.grid_on,
                        color: colorTheme.primaryColorDark,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: postImagesWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowCell(int count, String type) => Expanded(
          child: Column(
        children: <Widget>[
          Text(
            '$count',
            style: const TextStyle(color: Colors.black),
          ),
          Text(type,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal))
        ],
      ));

  // _retrieveLocalData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     name = (preferences.getString('name') ?? null);
  //     username = (preferences.getString('username') ?? null);
  //   });
  // }

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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                    itemBuilder: ((context, index) {
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

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          )
        : FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                      height: 600.0,
                      child: ListView.builder(
                          //shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) => ListItem(
                              list: snapshot.data!,
                              index: index,
                              user: _user))));
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
          child: Text(label,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
        )
      ],
    );
  }
}

class ListItem extends StatefulWidget {
  final List<DocumentSnapshot> list;
  final User user;
  final int index;

  const ListItem(
      {Key? key, required this.list, required this.user, required this.index})
      : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _repository = Repository();
  bool _isLiked = false;
  //Future<List<DocumentSnapshot>> _future;

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
                            user: widget.user,
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
    //_future =_repository.fetchPostLikes(widget.list[widget.index].reference);
  }

  @override
  Widget build(BuildContext context) {
    var temp = widget.list[widget.index]['postTime'];
    var diff = DateTime.parse(temp);
    timeDiff = Jiffy(diff).fromNow();

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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: ((context) => FriendProfileScreen(
                      //               name: list[index].data['postOwnerName'],
                      //             ))));
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(widget.user.profileImage!)),
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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: ((context) => FriendProfileScreen(
                          //               name: list[index].data['postOwnerName'],
                          //             ))));
                        },
                        child: Text(
                          widget.user.name!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: widget.list[widget.index]['caption'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          // Text(list[index].data['postOwnerName'],
                          //     style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text(widget.list[widget.index]['caption']),
                          )
                        ],
                      ),
                    ],
                  )
                : commentWidget(widget.list[widget.index].reference)),
        CachedNetworkImage(
          imageUrl: widget.list[widget.index]['imgUrl'],
          placeholder: ((context, s) => Center(
                child: widget.list[widget.index]['imgUrl'] == null
                    ? const CircularProgressIndicator()
                    : Container(),
              )),
          width: 125.0,
          height: 250.0,
          fit: BoxFit.cover,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 50.0, top: 16, right: 50, bottom: 16),
          child: Row(
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
                      // saveLikeValue(_isLiked);
                      postLike(widget.list[widget.index].reference);
                    } else {
                      setState(() {
                        _isLiked = false;
                      });
                      //saveLikeValue(_isLiked);
                      postUnlike(widget.list[widget.index].reference);
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
                                user: widget.user,
                              ))));
                },
                child: const Icon(
                  FontAwesomeIcons.comment,
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              const Icon(FontAwesomeIcons.shareFromSquare),
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
                  .fetchPostLikes(widget.list[widget.index].reference),
              builder: ((context,
                  AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
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
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
              child: commentWidget(widget.list[widget.index].reference),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("$timeDiff", style: const TextStyle(color: Colors.grey)),
        )
      ],
    );
  }

  void postLike(DocumentReference reference) {
    var like = Like(
        ownerName: widget.user.name!,
        ownerPhotoUrl: widget.user.name!,
        ownerUid: widget.user.uid!,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .doc(widget.user.uid)
        .set(like.toMap(like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference.collection("likes").doc(widget.user.uid).delete().then((value) {
      print("Post Unliked");
    });
  }
}
