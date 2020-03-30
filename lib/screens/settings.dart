import 'package:HFM/screens/accounts/login_options.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colortheme.primaryColor,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Sign out',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ),
                onTap: () {
                  _signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _signOut() async {
    await _auth.signOut().then((onValue) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginOptions()),
          ModalRoute.withName(''));
    });
  }
}
