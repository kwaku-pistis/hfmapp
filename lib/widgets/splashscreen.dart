import 'package:HFM/screens/home.dart';
import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SplashScreen(
        imageBackground: AssetImage('assets/images/adinkra_pattern.png'),
        seconds: 5,
        navigateAfterSeconds: Home(user: null),
        image: Image.asset(
          'assets/images/hfm.png',
          width: MediaQuery.of(context).size.width,
          height: 300,
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader:
            TextStyle(color: colortheme.accentColor, fontSize: 20),
        photoSize: 50.0,
        // onClick: ()=>print("Flutter Egypt"),
        loaderColor: colortheme.primaryColor,
        loadingText: Text(
          'Eternal Life and Essential Living',
        ),
      ),
    );
  }
}
