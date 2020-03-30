import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/themes/colors.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:instagram_clone/resources/repository.dart';
import 'package:path_provider/path_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final String photoUrl, email, bio, name, username;

  EditProfileScreen(
      {this.photoUrl, this.email, this.bio, this.name, this.username});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

String _name, _bio, _username, _emailorPhone;

class _EditProfileScreenState extends State<EditProfileScreen> {
  var _repository = Repository();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _bioController.text = widget.bio;
    _emailController.text = widget.email;
    _usernameController.text = widget.username;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
        //imageFile = widget.photoUrl;
      });
    });
  }

  File imageFile;

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colortheme.primaryColor,
        elevation: 1,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          child: Icon(Icons.close, color: Colors.white),
          onTap: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.done, color: colortheme.accentColor),
            ),
            onTap: () {
              _repository
                  .updateDetails(
                      currentUser.uid,
                      _nameController.text,
                      _bioController.text,
                      _emailController.text,
                      _usernameController.text)
                  .then((v) {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(
                //   builder: ((context) => InstaHomeScreen())
                // ));
              });
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                        width: 110.0,
                        height: 110.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          image: DecorationImage(
                              image: widget.photoUrl.isEmpty
                                  ? AssetImage('assets/no_image.png')
                                  : NetworkImage(widget.photoUrl),
                              fit: BoxFit.cover),
                        )),
                  ),
                  onTap: _showImageDialog),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text('Change Photo',
                      style: TextStyle(
                          color: colortheme.accentColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),
                onTap: _showImageDialog,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                  ),
                  onChanged: ((value) {
                    setState(() {
                      _name = value;
                    });
                  }),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: TextField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Bio',
                    labelText: 'Bio',
                  ),
                  onChanged: ((value) {
                    setState(() {
                      _bio = value;
                    });
                  }),
                  textDirection: TextDirection.ltr,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      hintText: 'Username', labelText: 'Username'),
                  onChanged: ((value) {
                    setState(() {
                      _username = value;
                    });
                  }),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Private Information',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'Email address or phone number', labelText: 'Email / Phone'),
                  onChanged: ((value) {
                    setState(() {
                      _emailorPhone = value;
                    });
                  }),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    _repository.uploadImageToStorage(imageFile).then((url) {
                      _repository.updatePhoto(url, currentUser.uid).then((v) {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    _repository.uploadImageToStorage(imageFile).then((url) {
                      _repository.updatePhoto(url, currentUser.uid).then((v) {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }
}
