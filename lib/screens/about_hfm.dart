import 'package:HFM/themes/colors.dart';
import 'package:HFM/webview.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutHfm extends StatefulWidget {
  @override
  _AboutHfmState createState() => _AboutHfmState();
}

final _fbUrl = 'https://www.facebook.com/harvestfieldsministries/';
final _igUrl = 'https://www.instagram.com/harvestfieldsministries/';
final _twitterUrl = 'https://twitter.com/harvestfieldsmn';
final _scUrl = 'https://soundcloud.com/hfm-publicity';

class _AboutHfmState extends State<AboutHfm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About HARVESTFIELDS',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colortheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
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
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(
                              left: 10,
                              right: 14,
                              top: 10,
                              bottom: 10),
                          padding: EdgeInsets.all(4),
                          decoration:
                              BoxDecoration(color: Color(0xff333333)),
                          child: Icon(
                            Icons.library_books,
                            color: Colors.white,
                          )),
                      Text(
                        'Read About us Online',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => MyWebView('About the Ministry', 'https://harvestfieldsministries.wordpress.com/about-the-ministry/')
                  )),
                ),
              ),
              Container(
                width: double.infinity,
                color: Color(0xff666666),
                height: 0.5,
                margin: EdgeInsets.only(top: 0),
              ),
              Container(
                padding: EdgeInsets.all(25.0),
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0, bottom: 25),
                      child: Text(
                        'Connect with Us',
                        style: TextStyle(color: colortheme.primaryColor, fontSize: 20),
                      ),
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(
                                  left: 10,
                                  right: 14,
                                  top: 10,
                                  bottom: 10),
                              padding: EdgeInsets.all(4),
                              decoration:
                                  BoxDecoration(color: Color(0xff333333)),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              )),
                          Text(
                            'HarvestFields Ministries, \nDansoman High St, Accra, Ghana.',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      onTap: () => _launchMapsUrl(),
                    ),
                    Container(
                      width: double.infinity,
                      color: Color(0xff666666),
                      height: 0.5,
                      margin: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(
                                  left: 10,
                                  right: 14,
                                  top: 10,
                                  bottom: 10),
                              child: Image(
                                  image: AssetImage(
                                      'assets/images/ic_facebook.png'))),
                          Text(
                            'Like us on Facebook',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      onTap: () => _launchUrl(_fbUrl),
                    ),
                    Container(
                      width: double.infinity,
                      color: Color(0xff666666),
                      height: 0.5,
                      margin: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(
                                  left: 10,
                                  right: 14,
                                  top: 10,
                                  bottom: 10),
                              child: Image(
                                  image: AssetImage(
                                      'assets/images/ic_instagram.png'))),
                          Text(
                            'Follow us on Instagram',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      onTap: () => _launchUrl(_igUrl),
                    ),
                    Container(
                      width: double.infinity,
                      color: Color(0xff666666),
                      height: 0.5,
                      margin: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(
                                  left: 10,
                                  right: 14,
                                  top: 10,
                                  bottom: 10),
                              child: Image(
                                  image: AssetImage(
                                      'assets/images/ic_twitter.png'))),
                          Text(
                            'Follow us on Twitter',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      onTap: () => _launchUrl(_twitterUrl),
                    ),
                    Container(
                      width: double.infinity,
                      color: Color(0xff666666),
                      height: 0.5,
                      margin: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(
                                  left: 10,
                                  right: 14,
                                  top: 10,
                                  bottom: 10),
                              child: Image(
                                  image: AssetImage(
                                      'assets/images/ic_sc.png'))),
                          Text(
                            'Subscribe to our SoundCloud',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      onTap: () => _launchUrl(_scUrl),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  // function to open any url
  void _launchUrl(final String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
