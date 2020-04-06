import 'package:HFM/screens/giving.dart';
import 'package:HFM/webview.dart';
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
                    style:
                        TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
                onTap: () => _showCallDialog(),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'FIND US',
                    style:
                        TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
                onTap: () => _launchMapsUrl(),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'BLOG POSTS',
                    style:
                        TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyWebView('Blog Posts', 'https://harvestfieldsministries.wordpress.com/')
                )),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'DONATE',
                    style:
                        TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Giving())),
              ),
            ],
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text("HFM hasn't posted anything yet"),
          ),
        ],
      ),
    );
  }

  _showCallDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Call us with your Local Network',
              style: TextStyle(
                  fontSize: 20,
                  color: colortheme.accentColor,
                  fontWeight: FontWeight.bold),
            ),
            content: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      child: RaisedButton(
                        child: Text(
                          'MTN',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        color: colortheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          launch('tel://+233-241-335434');
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      child: RaisedButton(
                        child: Text(
                          'VODAFONE',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        color: colortheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          launch('tel://+233-205-589220');
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      child: RaisedButton(
                        child: Text(
                          'AIRTELTIGO',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        color: colortheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          launch('tel://+233-577-296916');
                        },
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  void _launchMapsUrl() async {
    final url =
        'https://www.google.com/maps/place/Harvestfields+Ministries/@5.5417936,-0.2670196,17z/data=!4m12!1m6!3m5!1s0xfdf973b82720ed3:0x2d05252fea92d3a6!2sHarvestfields+Ministries!8m2!3d5.5417936!4d-0.2648309!3m4!1s0xfdf973b82720ed3:0x2d05252fea92d3a6!8m2!3d5.5417936!4d-0.2648309';
    final appleUrl = 'https://maps.apple.com/?sll=${5.5417936},${-0.2670196}';
    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(appleUrl)) {
      await launch(appleUrl);
    } else {
      throw 'Could not launch $url';
    }
  }
}
