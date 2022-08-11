import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikesScreen extends StatefulWidget {
  final DocumentReference documentReference;
  final User user;
  const LikesScreen(
      {Key? key, required this.documentReference, required this.user})
      : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  final _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: colorTheme.primaryColor,
        title: const Text(
          'Likes',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: _repository.fetchPostLikes(widget.documentReference),
        builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 16.0),
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        // snapshot.data[index].data['ownerName'] == widget.user.displayName ?
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: ((context) => InstaProfileScreen())
                        // )) : Navigator.push(context, MaterialPageRoute(
                        //   builder: ((context) => InstaFriendProfileScreen(name: snapshot.data[index].data['ownerName'],))
                        // ));
                      },
                      child: Text(
                        snapshot.data![index]['ownerName'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        //  snapshot.data[index].data['ownerName'] == widget.user.displayName ?
                        //   Navigator.push(context, MaterialPageRoute(
                        //     builder: ((context) => InstaProfileScreen())
                        //   )) : Navigator.push(context, MaterialPageRoute(
                        //     builder: ((context) => InstaFriendProfileScreen(name: snapshot.data[index].data['ownerName'],))
                        //   ));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data![index]['ownerPhotoUrl']),
                        radius: 30.0,
                      ),
                    ),
                    // trailing:
                    //     snapshot.data[index].data['ownerUid'] != widget.user.uid
                    //         ? buildProfileButton(snapshot.data[index].data['ownerName'])
                    //         : null,
                  ),
                );
              }),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('No Likes found'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
