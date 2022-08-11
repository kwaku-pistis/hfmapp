import 'package:HFM/themes/colors.dart';
import 'package:HFM/webview.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutHfm extends StatefulWidget {
  const AboutHfm({Key? key}) : super(key: key);

  @override
  State<AboutHfm> createState() => _AboutHfmState();
}

const _fbUrl = 'https://www.facebook.com/harvestfieldsministries/';
const _igUrl = 'https://www.instagram.com/harvestfieldsministries/';
const _twitterUrl = 'https://twitter.com/harvestfieldsmn';
const _scUrl = 'https://soundcloud.com/hfm-publicity';

class _AboutHfmState extends State<AboutHfm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About HARVESTFIELDS',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colorTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/adinkra_pattern.png'),
                  fit: BoxFit.cover,
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 192,
                      decoration: const BoxDecoration(
                        // shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/hfm.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 16),
                    //   child: Text(
                    //     'HarvestFields Ministries',
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(
                              left: 10, right: 14, top: 10, bottom: 10),
                          padding: const EdgeInsets.all(4),
                          decoration:
                              const BoxDecoration(color: Color(0xff333333)),
                          child: const Icon(
                            Icons.library_books,
                            color: Colors.white,
                          )),
                      const Text(
                        'Read About us Online',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const MyWebView(
                          title: 'About the Ministry',
                          selectedUrl:
                              'https://harvestfieldsministries.wordpress.com/about-the-ministry/'))),
                ),
              ),
              Container(
                width: double.infinity,
                color: const Color(0xff666666),
                height: 0.5,
                margin: const EdgeInsets.only(top: 0),
              ),
              Container(
                padding: const EdgeInsets.all(25.0),
                width: double.infinity,
                child: Column(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 25),
                    child: Text(
                      'Connect with Us',
                      style: TextStyle(
                          color: colorTheme.primaryColor, fontSize: 20),
                    ),
                  ),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(
                                left: 10, right: 14, top: 10, bottom: 10),
                            padding: const EdgeInsets.all(4),
                            decoration:
                                const BoxDecoration(color: Color(0xff333333)),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            )),
                        const Text(
                          'HarvestFields Ministries, \nDansoman High St, Accra, Ghana.',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    onTap: () => _launchMapsUrl(),
                  ),
                  Container(
                    width: double.infinity,
                    color: const Color(0xff666666),
                    height: 0.5,
                    margin: const EdgeInsets.only(top: 5),
                  ),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(
                                left: 10, right: 14, top: 10, bottom: 10),
                            child: const Image(
                                image: AssetImage(
                                    'assets/images/ic_facebook.png'))),
                        const Text(
                          'Like us on Facebook',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    onTap: () => _launchUrl(_fbUrl),
                  ),
                  Container(
                    width: double.infinity,
                    color: const Color(0xff666666),
                    height: 0.5,
                    margin: const EdgeInsets.only(top: 5),
                  ),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(
                                left: 10, right: 14, top: 10, bottom: 10),
                            child: const Image(
                                image: AssetImage(
                                    'assets/images/ic_instagram.png'))),
                        const Text(
                          'Follow us on Instagram',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    onTap: () => _launchUrl(_igUrl),
                  ),
                  Container(
                    width: double.infinity,
                    color: const Color(0xff666666),
                    height: 0.5,
                    margin: const EdgeInsets.only(top: 5),
                  ),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(
                                left: 10, right: 14, top: 10, bottom: 10),
                            child: const Image(
                                image: AssetImage(
                                    'assets/images/ic_twitter.png'))),
                        const Text(
                          'Follow us on Twitter',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    onTap: () => _launchUrl(_twitterUrl),
                  ),
                  Container(
                    width: double.infinity,
                    color: const Color(0xff666666),
                    height: 0.5,
                    margin: const EdgeInsets.only(top: 5),
                  ),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(
                                left: 10, right: 14, top: 10, bottom: 10),
                            child: const Image(
                                image: AssetImage('assets/images/ic_sc.png'))),
                        const Text(
                          'Subscribe to our SoundCloud',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    onTap: () => _launchUrl(_scUrl),
                  ),
                  Container(
                    width: double.infinity,
                    color: const Color(0xff666666),
                    height: 0.5,
                    margin: const EdgeInsets.only(top: 5),
                  ),

                  /// new feature
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 5, top: 20),
                    child: Text(
                      'Office Lines',
                      style: TextStyle(
                        fontSize: 20,
                        color: colorTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                      color: colorTheme.primaryColorDark,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(right: 0),
                            child: const Image(
                              image: AssetImage('assets/images/ic_phone.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          const Expanded(
                            child: SizedBox(
                              width: double.maxFinite,
                              child: Text(
                                '+233-205-589220',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => launchUrlString('tel://+233-205-589220'),
                  ),
                  GestureDetector(
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                      color: colorTheme.primaryColorDark,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(right: 0),
                            child: const Image(
                              image: AssetImage('assets/images/ic_phone.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          const Expanded(
                            child: SizedBox(
                              width: double.maxFinite,
                              child: Text(
                                '+233-241-335434',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => launchUrlString('tel://+233-241-335434'),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchMapsUrl() async {
    var url = Uri.parse(
        'https://www.google.com/maps/place/Harvestfields+Ministries/@5.5417936,-0.2670196,17z/data=!4m12!1m6!3m5!1s0xfdf973b82720ed3:0x2d05252fea92d3a6!2sHarvestfields+Ministries!8m2!3d5.5417936!4d-0.2648309!3m4!1s0xfdf973b82720ed3:0x2d05252fea92d3a6!8m2!3d5.5417936!4d-0.2648309');
    var appleUrl =
        Uri.parse('https://maps.apple.com/?sll=${5.5417936},${-0.2670196}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else if (await canLaunchUrl(appleUrl)) {
      await launchUrl(appleUrl);
    } else {
      throw 'Could not launch $url';
    }
  }

  // function to open any url
  void _launchUrl(final String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
