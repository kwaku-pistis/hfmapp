import 'package:HFM/screens/accounts/login_options.dart';
import 'package:HFM/screens/tabs/first.dart';
import 'package:HFM/screens/tabs/fourth.dart';
import 'package:HFM/screens/tabs/second.dart';
import 'package:HFM/screens/tabs/third.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState(user: this.user);

  final FirebaseUser user;

  Home({@required this.user});
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  FirebaseUser user;

  _HomeState({@required this.user});

  TabController controller;
  //GoogleSignIn _googleSignIn;
  bool isLoggedIn;

  @override
  void initState() {
    isLoggedIn = false;
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
            isLoggedIn = true;
          })
        : Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginOptions())));

    super.initState();

    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    //   if (_currentUser != null) {
    //     _handleGetContact();
    //   }
    // });
    // _googleSignIn.signInSilently();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (user == null) {
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
    //         builder: (BuildContext context) => LoginOptions()));
    //   }
    // });

    // Initialize the Tab Controller
    controller = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          // set icon to the tab
          icon: Icon(
            FontAwesomeIcons.home,
            color: Colors.white,
          ),
        ),
        Tab(
          icon: Icon(
            FontAwesomeIcons.church,
            color: Colors.white,
          ),
        ),
        Tab(
          icon: Icon(
            FontAwesomeIcons.donate,
            color: Colors.white,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.line_weight,
            color: Colors.white,
          ),
        ),
      ],
      // setup the controller
      controller: controller,
      indicatorColor: colortheme.accentColor,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HarvestFields',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 4,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colortheme.primaryColor,
        bottom: getTabBar(),
      ),
      body: getTabBarView(<Widget>[FeedScreen(), Second(), Third(), Fourth()]),
    );
  }

  // _saveUserDetails() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.setString('name', value)
  // }
}
