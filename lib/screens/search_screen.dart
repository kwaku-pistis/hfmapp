import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/friend_profile_screen.dart';
import 'package:HFM/screens/post_detail_screen.dart';
import 'package:HFM/themes/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repository = Repository();
  List<DocumentSnapshot> list = [];
  final User _user = User();
  late User currentUser;
  List<User> usersList = [];

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.name = user.displayName;
      _user.profileImage = user.photoURL;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        setState(() {
          currentUser = user;
        });
      });
      print("USER : ${user.displayName}");
      _repository.retrievePosts(user).then((updatedList) {
        setState(() {
          list = updatedList;
        });
      });
      _repository.fetchAllUsers(user).then((list) {
        setState(() {
          usersList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("INSIDE BUILD");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme.primaryColor,
        title: const Text(
          'Search Posts or Users',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: DataSearch(userList: usersList));
            },
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
          //  shrinkWrap: true,
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: ((context, index) {
            print("LIST : ${list.length}");
            // return GestureDetector(
            //   child: CachedNetworkImage(
            //     imageUrl: list[index].data['imgUrl'],
            //     placeholder: ((context, s) => Center(
            //           child: CircularProgressIndicator(),
            //         )),
            //     width: 125.0,
            //     height: 125.0,
            //     fit: BoxFit.cover,
            //   ),
            //   onTap: () {
            //     print("SNAPSHOT : ${list[index].reference.path}");
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: ((context) => PostDetailScreen(
            //                   user: _user,
            //                   currentuser: currentUser,
            //                   documentSnapshot: list[index],
            //                 ))));
            //   },
            // );

            var img = list[index]['imgUrl'];
            return GestureDetector(
              child: img != ""
                  ? CachedNetworkImage(
                      imageUrl: list[index]['imgUrl'],
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
                        list[index]['caption'],
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
              onTap: () {
                print("SNAPSHOT : ${list[index].reference.path}");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => PostDetailScreen(
                              user: _user,
                              currentUser: _user,
                              documentSnapshot: list[index],
                            ))));
              },
            );
          })),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<User> userList;
  DataSearch({required this.userList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //return null;
    return Center(
        child: Container(
      width: 50.0,
      height: 50.0,
      color: Colors.red,
      child: Text(query),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? userList
        : userList.where((p) => p.name!.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => ListTile(
            onTap: () {
              //   showResults(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => FriendProfileScreen(
                          name: suggestionsList[index].name!))));
            },
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(suggestionsList[index].profileImage!),
              //backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text(suggestionsList[index].name!),
          )),
    );
  }
}
