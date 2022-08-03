import 'dart:convert';
import 'dart:io';

import 'package:HFM/screens/accounts/login_options.dart';
import 'package:HFM/screens/tabs/first.dart';
import 'package:HFM/screens/tabs/fourth.dart';
import 'package:HFM/screens/tabs/second.dart';
import 'package:HFM/screens/tabs/third.dart';
import 'package:HFM/themes/colors.dart';
import 'package:HFM/utils/Communication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState(user: this.user);

  final FirebaseUser? user;

  Home({required this.user});
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late FirebaseUser? user;

  _HomeState({required this.user});

  late TabController controller;
  //GoogleSignIn _googleSignIn;
  late bool isLoggedIn;

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

    _requestIOSPermissions();

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

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // void showNotification(message) async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //     Platform.isAndroid ? 'com.ministry.hfmapp' : 'com.ministry.hfmapp',
  //     'HFM',
  //     'HarvestFields Ministry App',
  //     playSound: true,
  //     enableVibration: true,
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //   );
  //   var json = JsonCodec();
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
  //       message['body'].toString(), platformChannelSpecifics,
  //       payload: json.encode(message));
  // }

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

  // FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  // void registerNotification(String currentUserId, BuildContext context) {
  //   firebaseMessaging.requestNotificationPermissions();

  //   firebaseMessaging.configure(
  //       onMessage: (Map<String, dynamic> message) {
  //         print('onMessage: $message');
  //         Platform.isAndroid
  //             ? showNotification(message['notification'])
  //             : showNotification(message['aps']['alert']);
  //         Navigator.of((context)).pushNamed(message['screen']);
  //         return;
  //       },
  //       onBackgroundMessage: myBackgroundMessageHandler,
  //       onResume: (Map<String, dynamic> message) {
  //         print('onResume: $message');
  //         Navigator.of((context)).pushNamed(message['screen']);
  //         return;
  //       },
  //       onLaunch: (Map<String, dynamic> message) {
  //         print('onLaunch: $message');
  //         return;
  //       });

  //   firebaseMessaging.getToken().then((token) {
  //     print('token: $token');
  //     Firestore.instance
  //         .collection('User Info')
  //         .document(currentUserId)
  //         .updateData({'pushToken': token});
  //   }).catchError((err) {
  //     // Fluttertoast.showToast(msg: err.message.toString());
  //     // Toast.show('${err.message.toString()}', context, )
  //     print('${err.message.toString()}');
  //   });
  // }
}
