import 'dart:io';

import 'package:HFM/screens/home.dart';
import 'package:HFM/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() =>
      _ProfileState(data: this.data, user: this.user);

  final String data;
  final FirebaseUser user;

  Profile({@required this.data, @required this.user});
}

final Pattern emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
final Pattern phonePattern = r'(^(?:[+0]+)?[0-9]{10,12}$)';

String dropdownValue = '--Select Gender--';
List<String> options = <String>['--Select Gender--', 'Male', 'Female'];

final _formkey = GlobalKey<FormState>();
TextEditingController firstNameController = TextEditingController();
bool fnameValidate = false;
bool lnameValidate = false;
bool usernameValidate = false;
bool genderValidate = false;
bool peValidate = false;

File _image;
var image;
int _state = 0;

String fname, lname, username, phoneOrEmail, gender;

StorageReference _storage =
    FirebaseStorage.instance.ref().child('User Profile Image');

class _ProfileState extends State<Profile> {
  String data;
  FirebaseUser user;

  _ProfileState({@required this.data, @required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Back',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/adinkra_pattern.png'),
            fit: BoxFit.cover,
          )),
          padding: EdgeInsets.only(left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'First, Complete your Profile',
                  style:
                      TextStyle(color: colortheme.primaryColor, fontSize: 26),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: 150,
                  height: 150,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      color: Colors.white,
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage('assets/images/profile.png')
                            : FileImage(_image),
                        fit: BoxFit.cover,
                      )),
                ),
                onTap: () => getImage(),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  'Click to set Profile picture',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextFormField(
                              controller: firstNameController,
                              autovalidate: fnameValidate,
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
                              onSaved: (String value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                                setState(() {
                                  fname = value;
                                });
                              },
                              validator: (String value) {
                                // RegExp emailRegex = new RegExp(emailPattern);
                                // RegExp phoneRegex = new RegExp(phonePattern);

                                if (value.isEmpty) {
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
                              style: TextStyle(color: Colors.black),
                              onChanged: (text) {
                                setState(() {
                                  fnameValidate = true;
                                });
                              })),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                              controller: null,
                              autovalidate: lnameValidate,
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
                              onSaved: (String value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                                setState(() {
                                  lname = value;
                                });
                              },
                              validator: (String value) {
                                // RegExp emailRegex = new RegExp(emailPattern);
                                // RegExp phoneRegex = new RegExp(phonePattern);

                                if (value.isEmpty) {
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
                              style: TextStyle(color: Colors.black),
                              onChanged: (text) {
                                setState(() {
                                  lnameValidate = true;
                                });
                              })),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                              controller: null,
                              autovalidate: usernameValidate,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.person_pin,
                                  color: Color(0xff326b40),
                                ),
                                hintText: 'enter a username',
                                hintStyle: TextStyle(color: Colors.grey),
                                labelText: 'Userame *',
                                labelStyle: TextStyle(color: Color(0xff326b40)),
                                contentPadding:
                                    EdgeInsets.only(bottom: 10, top: 10),
                              ),
                              onSaved: (String value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                                setState(() {
                                  username = value;
                                });
                              },
                              validator: (String value) {
                                // RegExp emailRegex = new RegExp(emailPattern);
                                // RegExp phoneRegex = new RegExp(phonePattern);

                                if (value.isEmpty) {
                                  return 'This field is required';
                                }

                                usernameValidate = false;
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                              style: TextStyle(color: Colors.black),
                              onChanged: (text) {
                                setState(() {
                                  usernameValidate = true;
                                });
                              })),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                              controller: null,
                              autovalidate: peValidate,
                              initialValue: data,
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
                              onSaved: (String value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                                setState(() {
                                  phoneOrEmail = value;
                                });
                              },
                              validator: (String value) {
                                RegExp emailRegex = new RegExp(emailPattern);
                                //RegExp phoneRegex = new RegExp(phonePattern);

                                if (value.startsWith(new RegExp(r'[a-z]'))) {
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
                              style: TextStyle(color: Colors.black),
                              onChanged: (text) {
                                setState(() {
                                  peValidate = true;
                                });
                              })),
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 16),
                        child: Icon(Icons.person_outline,
                            color: Color(0xff326b40)),
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            iconSize: 30,
                            elevation: 0,
                            isDense: true,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            //hint: Text('-- Select your school --'),
                            selectedItemBuilder: (BuildContext context) {
                              return options.map((String value) {
                                return Text(dropdownValue,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left);
                              }).toList();
                            },
                            underline: Container(
                              margin: EdgeInsets.only(top: 5),
                              height: 0.5,
                              color: Color(0xff326b40),
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
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
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                height: 50,
                child: RaisedButton(
                  child: _setUpButtonChild(),
                  textColor: Colors.white,
                  color: colortheme.accentColor,
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
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //var imageName = basename(image.path)
    setState(() {
      _image = image;
    });
  }

  Widget _setUpButtonChild() {
    if (_state == 0) {
      return Text(
        'DONE',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  _validateForm() {
    if (_formkey.currentState.validate() &&
        dropdownValue != '--Select Gender--') {
      setState(() {
        _state = 1;
      });
      _formkey.currentState.save();

      if (image != null){
        _uploadImage();
      } else {
        _saveDataToFirebaseDB(null);
      }
    } else {
      Toast.show('Please select your Gender', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _uploadImage() async {
    StorageUploadTask uploadTask = _storage.child(user.uid).putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    await uploadTask.onComplete
        .whenComplete(await _saveDataToFirebaseDB(taskSnapshot)); 
  }

  _saveDataToFirebaseDB(StorageTaskSnapshot taskSnapshot) async {
    String downloadUrl = taskSnapshot != null ? await taskSnapshot.ref.getDownloadURL() : '';
    DocumentReference storeReference =
        Firestore.instance.collection('User Info').document(user.uid);
    await storeReference.setData({
      'Name': '$fname $lname',
      'Email / Phone': data,
      'Username': username,
      'Gender': dropdownValue,
      'Profile Image': downloadUrl,
    }).whenComplete(await moveToHome());
  }


  moveToHome() async {
    setState(() {
      _state = 2;
    });

    // Timer(Duration(milliseconds: 3300), () {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (BuildContext context) => Home(user: user,)
      ), ModalRoute.withName(''));
    //});
  }
}
