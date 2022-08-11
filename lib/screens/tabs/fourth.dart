import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/accounts/profile_details.dart';
import 'package:HFM/screens/giving.dart';
import 'package:HFM/screens/help_support.dart';
import 'package:HFM/screens/messages.dart';
import 'package:HFM/screens/search_screen.dart';
import 'package:HFM/screens/settings.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:shared_preferences/shared_preferences.dart';

late String name, profileImage;

class Fourth extends StatefulWidget {
  const Fourth({Key? key}) : super(key: key);

  @override
  State<Fourth> createState() => _FourthState();
}

class _FourthState extends State<Fourth> {
  final _repository = Repository();
  late User _user;

  @override
  void initState() {
    retrieveUserDetails();
    super.initState();
  }

  retrieveUserDetails() async {
    auth.User currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;
      name = _user.name!;
      profileImage = _user.profileImage!;
    });
    //_future = _repository.retrieveUserPosts(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    String packageName = '';
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      packageName = packageInfo.packageName;
    });
    //_retrieveLocalData();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              //height: 120,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
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
                        image: NetworkImage(profileImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Text(
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
              color: colorTheme.primaryColorDark,
            ),
            title: const Text('Profile'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ProfileDetails())),
          ),
          ListTile(
            leading: Icon(
              Icons.message,
              color: colorTheme.primaryColorDark,
            ),
            title: const Text('Chats'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const Messages())),
          ),
          ListTile(
            leading: Icon(
              Icons.share,
              color: colorTheme.primaryColorDark,
            ),
            title: const Text('Invite a friend'),
            onTap: () => Share.share(
                'Join me $name on the HARVESTFIELDS APP and let\'s talk about Jesus. \nGet the app on playstore using this link: https://play.google.com/store/apps/details?id=$packageName'),
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: colorTheme.primaryColorDark,
            ),
            title: const Text('Search'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const SearchScreen())),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.moneyBill,
              color: colorTheme.primaryColorDark,
            ),
            title: const Text('Giving'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const Giving())),
          ),
          ListTile(
            leading: Icon(
              Icons.help,
              color: colorTheme.primaryColorDark,
            ),
            title: const Text('Help & Support'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const HelpSupport())),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: colorTheme.primaryColorDark,
            ),
            title: const Text('Settings'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const Settings())),
          ),
        ],
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
