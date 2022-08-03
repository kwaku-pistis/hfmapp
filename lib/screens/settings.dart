import 'package:HFM/screens/about_hfm.dart';
import 'package:HFM/screens/accounts/login_options.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
bool _isChecked = true;
bool isPmChecked = true;
String packageName = '';
String version = '';

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        packageName = packageInfo.packageName;
        version = packageInfo.version;
      });
    });

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
          // height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Notification Settings',
                  style: TextStyle(color: colortheme.primaryColor),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 0),
                child: CheckboxListTile(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                    print('Checked State: $_isChecked');
                  },
                  title: Text('Receive notifications'),
                  activeColor: colortheme.accentColor,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                child: CheckboxListTile(
                  value: isPmChecked,
                  onChanged: (value) {
                    setState(() {
                      isPmChecked = value!;
                    });
                    print('Checked State: $isPmChecked');
                  },
                  title: Text('Get notified about private messages'),
                  activeColor: colortheme.accentColor,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Help & Support',
                  style: TextStyle(color: colortheme.primaryColor),
                ),
              ),
              GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.email,
                            color: colortheme.accentColor,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: EdgeInsets.only(left: 25, top: 10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    'Email Help Center',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    "We'd LOVE to hear from you! Tell us how we're doing, give us feedback, or just drop in to say hi!",
                                    style: TextStyle(),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _contactEmailCenter();
                  }),
              Divider(
                height: 30.0,
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.phone,
                          color: colortheme.accentColor,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: EdgeInsets.only(left: 25, top: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  'Call Us With Your Local Network',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  "Our client support staff are ready to hear from you",
                                  style: TextStyle(),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _showCallDialog();
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  'About the Church',
                  style: TextStyle(color: colortheme.primaryColor),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 0, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: 7),
                        child: Text(
                          'About HARVERTFIELDS',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Important information about the church and its activities",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AboutHfm()
                )),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  'About the Developer',
                  style: TextStyle(color: colortheme.primaryColor),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 0, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: 7),
                        child: Text(
                          'About Deemiensa',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Deemiensa is software and technology company based in Ghana. We deal in all kinds of softwares aimed at providing solutions to problems all around us. \n\nContact Deemiensa for your app",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _contactDeveloper();
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  'Privacy & Security',
                  style: TextStyle(color: colortheme.primaryColor),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 0, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: 7),
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Review our privacy policy here",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  'About this App',
                  style: TextStyle(color: colortheme.primaryColor),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 0, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "version $version-HFM-release build 100",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _launchPlayStore();
                },
              ),
              // GestureDetector(
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     child: Text(
              //       'Sign out',
              //       style:
              //           TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              //     ),
              //   ),
              //   onTap: () {
              //     _signOut();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _contactEmailCenter() async {
    final Email mail = Email(
      body: '',
      subject: 'CONTACT HARVESTFIELDS',
      recipients: ['harvesters4ever@gmail.com'],
    );

    await FlutterEmailSender.send(mail).then((onValue) {
      Navigator.of(context).pop();
    });
  }

  _contactDeveloper() async {
    final Email mail = Email(
      body: '',
      subject: 'CONTACT DEEMIENSA',
      recipients: ['danielpartey.dp@gmail.com'],
    );

    await FlutterEmailSender.send(mail).then((onValue) {
      Navigator.of(context).pop();
    });
  }

  void _launchPlayStore() async {
    final url = 'https://play.google.com/store/apps/details?id=$packageName';
    final appleUrl = '';
    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(appleUrl)) {
      await launch(appleUrl);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showCallDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Call Us',
              style: TextStyle(
                  fontSize: 20,
                  color: colortheme.accentColor,
                  fontWeight: FontWeight.bold),
            ),
            content: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      child: RaisedButton(
                        child: Text(
                          'MTN',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        color: colortheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          launch('tel://+233-241-335434');
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      child: RaisedButton(
                        child: Text(
                          'VODAFONE',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        color: colortheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          launch('tel://+233-205-589220');
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      child: RaisedButton(
                        child: Text(
                          'AIRTELTIGO',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        color: colortheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          launch('tel://+233-577-296916');
                        },
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  _signOut() async {
    await _auth.signOut().then((onValue) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginOptions()),
          ModalRoute.withName(''));
    });
  }
}
