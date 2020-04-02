import 'package:HFM/screens/giving.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes/colors.dart';

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/adinkra_pattern.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text(
                    'HarvestFields Ministries',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'CALL US',
                    style: TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
                onTap: () => launch('tel://+233-205-589220'),
              ),
              GestureDetector(
               child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'FIND US',
                    style: TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
                onTap: () => _launchMapsUrl(),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'CHECK IN',
                    style: TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
              ),
              GestureDetector(
               child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'DONATE',
                    style: TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Giving()
                )),
              ),
            ],
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "HFM hasn't posted anything yet"
            ),
          ),
        ],
      ),
    );
  }

  void _launchMapsUrl() async {
    final url =
        'https://www.google.com/maps/search/Dansoman+Market,+Accra,+Greater+Accra/@5.541406,-0.265491,19.4z';
    final appleUrl = 'https://maps.apple.com/?sll=${5.5413251},${-0.2658069}';
    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(appleUrl)) {
      await launch(appleUrl);
    } else {
      throw 'Could not launch $url';
    }
  }
}
