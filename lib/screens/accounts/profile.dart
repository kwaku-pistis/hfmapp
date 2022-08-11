import 'dart:io';

import 'package:HFM/screens/home.dart';
import 'package:HFM/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:HFM/models/user.dart';

class Profile extends StatefulWidget {
  final String data;
  final auth.User user;

  const Profile({Key? key, required this.data, required this.user})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

const Pattern emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
const Pattern phonePattern = r'(^(?:[+0]+)?[0-9]{10,12}$)';

String dropdownValue = '--Select Gender--';
List<String> options = <String>['--Select Gender--', 'Male', 'Female'];

final _formKey = GlobalKey<FormState>();
TextEditingController firstNameController = TextEditingController();
bool fnameValidate = false;
bool lnameValidate = false;
bool usernameValidate = false;
bool genderValidate = false;
bool peValidate = false;

File? _image;
var image;
int _state = 0;

String? fname, lname, username, phoneOrEmail, gender;

Reference _storage = FirebaseStorage.instance.ref().child('User Profile Image');

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
User? _user;

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Back',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/adinkra_pattern.png'),
            fit: BoxFit.cover,
          )),
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  'First, Complete your Profile',
                  style:
                      TextStyle(color: colorTheme.primaryColor, fontSize: 26),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: 150,
                  height: 150,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      color: Colors.white,
                      image: DecorationImage(
                        image: _image == null
                            ? const AssetImage('assets/images/profile.png')
                            : FileImage(_image!) as ImageProvider,
                        fit: BoxFit.cover,
                      )),
                ),
                onTap: () => getImage(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: const Text(
                  'Click to set Profile picture',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextFormField(
                              controller: firstNameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: Color(0xff326b40),
                                ),
                                hintText: 'enter your first name',
                                hintStyle: TextStyle(color: Colors.grey),
                                labelText: 'First Name *',
                                labelStyle: TextStyle(color: Color(0xff326b40)),
                                contentPadding:
                                    EdgeInsets.only(bottom: 10, top: 10),
                              ),
                              onSaved: (String? value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                                setState(() {
                                  fname = value;
                                });
                              },
                              validator: (String? value) {
                                // RegExp emailRegex = new RegExp(emailPattern);
                                // RegExp phoneRegex = new RegExp(phonePattern);

                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                                if (value.contains('@')) {
                                  return 'Name must be only letters';
                                }

                                fnameValidate = false;
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (text) {
                                setState(() {
                                  fnameValidate = true;
                                });
                              })),
                      Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                              controller: null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: Color(0xff326b40),
                                ),
                                hintText: 'enter your last name',
                                hintStyle: TextStyle(color: Colors.grey),
                                labelText: 'Last Name *',
                                labelStyle: TextStyle(color: Color(0xff326b40)),
                                contentPadding:
                                    EdgeInsets.only(bottom: 10, top: 10),
                              ),
                              onSaved: (String? value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                                setState(() {
                                  lname = value;
                                });
                              },
                              validator: (String? value) {
                                // RegExp emailRegex = new RegExp(emailPattern);
                                // RegExp phoneRegex = new RegExp(phonePattern);

                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                                if (value.contains('@')) {
                                  return 'Name must be only letters';
                                }

                                lnameValidate = false;
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (text) {
                                setState(() {
                                  lnameValidate = true;
                                });
                              })),
                      Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                              controller: null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.person_pin,
                                  color: Color(0xff326b40),
                                ),
                                hintText: 'enter a username',
                                hintStyle: TextStyle(color: Colors.grey),
                                labelText: 'Username *',
                                labelStyle: TextStyle(color: Color(0xff326b40)),
                                contentPadding:
                                    EdgeInsets.only(bottom: 10, top: 10),
                              ),
                              onSaved: (String? value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                                setState(() {
                                  username = value;
                                });
                              },
                              validator: (String? value) {
                                // RegExp emailRegex = new RegExp(emailPattern);
                                // RegExp phoneRegex = new RegExp(phonePattern);

                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }

                                usernameValidate = false;
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (text) {
                                setState(() {
                                  usernameValidate = true;
                                });
                              })),
                      Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                              controller: null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              initialValue: widget.data,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: Color(0xff326b40),
                                ),
                                hintText: 'enter your email or phone number',
                                hintStyle: TextStyle(color: Colors.grey),
                                labelText: 'Email / Phone *',
                                labelStyle: TextStyle(color: Color(0xff326b40)),
                                contentPadding:
                                    EdgeInsets.only(bottom: 10, top: 10),
                              ),
                              onSaved: (String? value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                                setState(() {
                                  phoneOrEmail = value;
                                });
                              },
                              validator: (String? value) {
                                RegExp emailRegex =
                                    RegExp(emailPattern.toString());
                                //RegExp phoneRegex = new RegExp(phonePattern);

                                if (value!.startsWith(RegExp(r'[a-z]'))) {
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Not a valid email address';
                                  }
                                }
                                // else {
                                //   if (!phoneRegex.hasMatch(value)) {
                                //     return 'Not a valid phone number';
                                //   }
                                // }

                                peValidate = false;
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (text) {
                                setState(() {
                                  peValidate = true;
                                });
                              })),
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.person_outline,
                            color: Color(0xff326b40)),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            iconSize: 30,
                            elevation: 0,
                            isDense: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            //hint: Text('-- Select your school --'),
                            selectedItemBuilder: (BuildContext context) {
                              return options.map((String value) {
                                return Text(dropdownValue,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left);
                              }).toList();
                            },
                            underline: Container(
                              margin: const EdgeInsets.only(top: 5),
                              height: 0.5,
                              color: const Color(0xff326b40),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: options
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                height: 50,
                child: RaisedButton(
                  child: _setUpButtonChild(),
                  textColor: Colors.white,
                  color: colorTheme.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    _validateForm();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //var imageName = basename(image.path)
    setState(() {
      _image = image;
    });
  }

  Widget _setUpButtonChild() {
    if (_state == 0) {
      return const Text(
        'DONE',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else if (_state == 1) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return const Icon(Icons.check, color: Colors.white);
    }
  }

  _validateForm() {
    if (_formKey.currentState!.validate() &&
        dropdownValue != '--Select Gender--') {
      setState(() {
        _state = 1;
      });
      _formKey.currentState!.save();

      if (image != null) {
        _uploadImage();
      } else {
        _saveDataToFirebaseDB(null);
      }
    } else {
      Toast.show('Please select your Gender',
          duration: Toast.lengthLong, gravity: Toast.bottom);
    }
  }

  _uploadImage() async {
    UploadTask uploadTask = _storage.child(widget.user.uid).putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    await uploadTask.whenComplete(await _saveDataToFirebaseDB(taskSnapshot));
  }

  _saveDataToFirebaseDB(TaskSnapshot? taskSnapshot) async {
    String downloadUrl =
        taskSnapshot != null ? await taskSnapshot.ref.getDownloadURL() : '';
    // DocumentReference storeReference =
    //     Firestore.instance.collection('User Info').document(user.uid);
    // await storeReference.setData({
    //   'Name': '$fname $lname',
    //   'Email / Phone': data,
    //   'Username': username,
    //   'Gender': dropdownValue,
    //   'Profile Image': downloadUrl,
    // }).whenComplete(await moveToHome(downloadUrl));

    _firestore
        .collection("display_names")
        .doc('$fname $lname')
        .set({'displayName': '$fname $lname'});

    _user = User(
        uid: widget.user.uid,
        email: widget.data,
        name: '$fname $lname',
        profileImage: downloadUrl,
        followers: '0',
        following: '0',
        bio: '',
        posts: '0',
        username: username);

    //  Map<String, String> mapdata = Map<String, dynamic>();

    //  mapdata = user.toMap(user);

    _firestore
        .collection("User Info")
        .doc(widget.user.uid)
        .set(_user!.toMap(_user!))
        .then(moveToHome(downloadUrl));
  }

  moveToHome(String downloadUrl) async {
    _saveUserDetails(downloadUrl);
    setState(() {
      _state = 2;
    });

    // Timer(Duration(milliseconds: 3300), () {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => Home(
                  user: widget.user,
                )),
        ModalRoute.withName(''));
    //});
  }

  _saveUserDetails(String downloadUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('name', '$fname $lname');
    await preferences.setString('emailOrPhone', widget.data);
    await preferences.setString('username', username!);
    await preferences.setString('profileImage', downloadUrl);
    await preferences.setString('gender', gender!);
  }
}
