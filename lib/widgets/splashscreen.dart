import 'dart:async';

import 'package:HFM/screens/home.dart';
import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    // _requestIOSPermissions();
    // _configureDidReceiveLocalNotificationSubject();
    // _configureSelectNotificationSubject();

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => Home(
                user: null,
              )));
    });
  }

  // void _requestIOSPermissions() {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );
  // }

  // void _configureDidReceiveLocalNotificationSubject() {
  //   didReceiveLocalNotificationSubject.stream
  //       .listen((ReceivedNotification receivedNotification) async {
  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: receivedNotification.title != null
  //             ? Text(receivedNotification.title)
  //             : null,
  //         content: receivedNotification.body != null
  //             ? Text(receivedNotification.body)
  //             : null,
  //         actions: [
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: Text('Ok'),
  //             onPressed: () async {
  //               Navigator.of(context, rootNavigator: true).pop();
  //               // await Navigator.push(
  //               //   context,
  //               //   MaterialPageRoute(
  //               //     builder: (context) =>
  //               //         SecondScreen(receivedNotification.payload),
  //               //   ),
  //               // );
  //             },
  //           )
  //         ],
  //       ),
  //     );
  //   });
  // }

  // void _configureSelectNotificationSubject() {
  //   selectNotificationSubject.stream.listen((String payload) async {
  //     // await Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => SecondScreen(payload)),
  //     // );
  //   });
  // }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: MediaQuery.of(context).size.width,
    //   height: MediaQuery.of(context).size.height,
    //   child: SplashScreen(
    //     imageBackground: AssetImage('assets/images/adinkra_pattern.png'),
    //     seconds: 5,
    //     navigateAfterSeconds: Home(user: null),
    //     image: Image.asset(
    //       'assets/images/hfm_splash.png',
    //       width: MediaQuery.of(context).size.width,
    //       height: 300,
    //       fit: BoxFit.cover,
    //     ),
    //     backgroundColor: Colors.white,
    //     styleTextUnderTheLoader:
    //         TextStyle(color: colortheme.accentColor, fontSize: 20),
    //     photoSize: 50.0,
    //     // onClick: ()=>print("Flutter Egypt"),
    //     loaderColor: colortheme.primaryColor,
    //     loadingText: Text(
    //       'Eternal Life and Essential Living',
    //       style: TextStyle(color: colortheme.accentColor, fontSize: 20),
    //     ),
    //   ),
    // );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/adinkra_pattern.png'),
          fit: BoxFit.cover,
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // CustomSplash(
          //   imagePath: 'assets/images/hfm_splash.png',
          //   backGroundColor: Colors.white,
          //   animationEffect: 'zoom-in',
          //   logoSize: 500,
          //   home: Home(
          //     user: null,
          //   ),
          //   // customFunction: duringSplash,
          //   duration: 5000,
          //   type: CustomSplashType.StaticDuration,
          //   // outputAndHome: op,
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hfm.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Image(
              image: AssetImage('assets/images/hfm.png'),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Eternal Life and Essential Living',
              style: TextStyle(
                color: colorTheme.primaryColorDark,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
