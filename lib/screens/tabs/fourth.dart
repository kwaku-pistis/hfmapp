import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/accounts/profile_details.dart';
import 'package:HFM/screens/chat_screen.dart';
import 'package:HFM/screens/giving.dart';
import 'package:HFM/screens/help_support.dart';
import 'package:HFM/screens/search_screen.dart';
import 'package:HFM/screens/settings.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
//import 'package:shared_preferences/shared_preferences.dart';

String name, profileImage;

class Fourth extends StatefulWidget {
  @override
  _FourthState createState() => _FourthState();
}

class _FourthState extends State<Fourth> {
  var _repository = Repository();
  User _user;

  @override
  void initState() {
    retrieveUserDetails();
    super.initState();
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;
      name = _user.name;
      profileImage = _user.profileImage;
    });
    //_future = _repository.retrieveUserPosts(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    String packageName;
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      packageName = packageInfo.packageName;
    });
    //_retrieveLocalData();
    return SingleChildScrollView(
      child: Container(
        //color: colortheme.primaryColor,
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width,
                //height: 120,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/adinkra_pattern.png'),
                  fit: BoxFit.cover,
                )),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: profileImage == null
                              ? AssetImage('assets/images/profile.png')
                              : NetworkImage(profileImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                name != null ? name : 'name',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'member',
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
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfileDetails())),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: colortheme.accentColor,
              ),
              title: Text('Profile'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfileDetails())),
            ),
            ListTile(
              leading: Icon(
                Icons.message,
                color: colortheme.accentColor,
              ),
              title: Text('Messages'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ChatScreen())),
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: colortheme.accentColor,
              ),
              title: Text('Invite a friend'),
              onTap: () => Share.share('Join me $name on the HARVESTFIELDS APP and let\'s talk about Jesus. \nGet the app on playstore using this link: https://play.google.com/store/apps/details?id=$packageName'),
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                color: colortheme.accentColor,
              ),
              title: Text('Search'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SearchScreen())),
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.moneyBill,
                color: colortheme.accentColor,
              ),
              title: Text('Giving'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Giving())),
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: colortheme.accentColor,
              ),
              title: Text('Help & Support'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HelpSupport())),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: colortheme.accentColor,
              ),
              title: Text('Settings'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Settings())),
            ),
          ],
        ),
      ),
    );
  }

  // _retrieveLocalData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     name = (preferences.getString('name') ?? null);
  //   });
  // }
}
