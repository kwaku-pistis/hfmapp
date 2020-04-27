import 'dart:async';

import 'package:HFM/screens/home.dart';
import 'package:HFM/themes/colors.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => Home(
                user: null,
              )));
    });
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
      decoration: BoxDecoration(
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hfm.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Image(
              image: AssetImage('assets/images/hfm.png'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Eternal Life and Essential Living',
              style: TextStyle(
                color: colortheme.accentColor,
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
