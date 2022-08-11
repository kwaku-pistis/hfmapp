import 'package:HFM/screens/tabs/first.dart';
import 'package:HFM/screens/tabs/fourth.dart';
import 'package:HFM/screens/tabs/second.dart';
import 'package:HFM/screens/tabs/third.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';

class Home extends StatefulWidget {
  final User? user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController controller;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      setState(() {
        isLoggedIn = true;
      });
    }

    _requestIOSPermissions();

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

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: const <Tab>[
        Tab(
          // set icon to the tab
          icon: Icon(
            FontAwesomeIcons.iCursor,
            color: Colors.white,
          ),
        ),
        Tab(
          icon: Icon(
            FontAwesomeIcons.house,
            color: Colors.white,
          ),
        ),
        Tab(
          icon: Icon(
            FontAwesomeIcons.gift,
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
      indicatorColor: colorTheme.primaryColorDark,
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
        title: const Text(
          'HarvestFields',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 4,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colorTheme.primaryColor,
        bottom: getTabBar(),
      ),
      body: getTabBarView(<Widget>[
        const FeedScreen(),
        const Second(),
        const Third(),
        const Fourth()
      ]),
    );
  }
}
