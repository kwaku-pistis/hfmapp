import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/chat_detail_screen.dart';
import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _repository = Repository();
  User _user = User();
  List<User> usersList = [];

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      print("USER : ${user.displayName}");

      _repository.fetchAllUsers(user).then((updatedList) {
        setState(() {
          usersList = updatedList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colortheme.primaryColor,
          title: Text(
            'Select user to start chat with',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: ChatSearch(usersList: usersList));
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: usersList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => ChatDetailScreen(
                                photoUrl: usersList[index].profileImage!,
                                name: usersList[index].name!,
                                receiverUid: usersList[index].uid!,
                              ))));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(usersList[index].profileImage!),
                  ),
                  title: Text(usersList[index].name!),
                ),
              ),
            );
          }),
        ));
  }
}

class ChatSearch extends SearchDelegate<String> {
  List<User> usersList;
  ChatSearch({required this.usersList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<User> suggestionsList = query.isEmpty
        ? usersList
        : usersList.where((p) => p.name!.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => ListTile(
            onTap: () {
              //   showResults(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ChatDetailScreen(
                            photoUrl: suggestionsList[index].profileImage!,
                            name: suggestionsList[index].name!,
                            receiverUid: suggestionsList[index].uid!,
                          ))));
            },
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(suggestionsList[index].profileImage!),
            ),
            title: Text(suggestionsList[index].name!),
          )),
    );
  }
}
