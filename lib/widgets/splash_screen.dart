import 'dart:async';

import 'package:HFM/screens/accounts/login_options.dart';
import 'package:HFM/screens/home.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

final _auth = FirebaseAuth.instance;

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      var user = _auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              user: user,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginOptions(),
          ),
        );
      }
    });

    // Timer(const Duration(seconds: 5), () {
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (BuildContext context) => const Home(
    //             user: null,
    //           )));
    // });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/adinkra_pattern.png'),
          fit: BoxFit.cover,
        ),
        color: Colors.white,
      ),
      child: Center(
        child: Container(
            // width: MediaQuery.of(context).size.width,
            width: 150,
            height: 150,
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
          // const SizedBox(
          //   height: 40,
          // ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   child: Text(
          //     'Eternal Life and Essential Living',
          //     style: TextStyle(
          //       color: colorTheme.primaryColorDark,
          //       fontSize: 20,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
      ),
    );
  }
}
