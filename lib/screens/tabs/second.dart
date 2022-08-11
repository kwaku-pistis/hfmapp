import 'package:HFM/screens/giving.dart';
import 'package:HFM/themes/colors.dart';
import 'package:HFM/webview.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Second extends StatefulWidget {
  const Second({Key? key}) : super(key: key);

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'CALL US',
                    style: TextStyle(
                        fontSize: 16, color: colorTheme.primaryColorDark),
                  ),
                ),
                onTap: () => _showCallDialog(),
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'FIND US',
                    style: TextStyle(
                        fontSize: 16, color: colorTheme.primaryColorDark),
                  ),
                ),
                onTap: () => _launchMapsUrl(),
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'QUICKWORD',
                    style: TextStyle(
                        fontSize: 16, color: colorTheme.primaryColorDark),
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const MyWebView(
                        title: 'Blog Posts',
                        selectedUrl:
                            'https://harvestfieldsministries.wordpress.com/'))),
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'DONATE',
                    style: TextStyle(
                        fontSize: 16, color: colorTheme.primaryColorDark),
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const Giving())),
              ),
            ],
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text("HFM hasn't posted anything yet"),
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
              'Call Us',
              style: TextStyle(
                  fontSize: 20,
                  color: colorTheme.primaryColorDark,
                  fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              colorTheme.primaryColorDark),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                        ),
                        onPressed: () {
                          launchUrlString('tel://+233-241-335434');
                        },
                        child: const Text(
                          'MTN',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              colorTheme.primaryColorDark),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                        ),
                        onPressed: () {
                          launchUrlString('tel://+233-205-589220');
                        },
                        child: const Text(
                          'VODAFONE',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              colorTheme.primaryColorDark),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                        ),
                        onPressed: () {
                          launchUrlString('tel://+233-577-296916');
                        },
                        child: const Text(
                          'AIRTELTIGO',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  void _launchMapsUrl() async {
    const url =
        'https://www.google.com/maps/place/Harvestfields+Ministries/@5.5417936,-0.2670196,17z/data=!4m12!1m6!3m5!1s0xfdf973b82720ed3:0x2d05252fea92d3a6!2sHarvestfields+Ministries!8m2!3d5.5417936!4d-0.2648309!3m4!1s0xfdf973b82720ed3:0x2d05252fea92d3a6!8m2!3d5.5417936!4d-0.2648309';
    const appleUrl = 'https://maps.apple.com/?sll=${5.5417936},${-0.2670196}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else if (await canLaunchUrlString(appleUrl)) {
      await launchUrlString(appleUrl);
    } else {
      throw 'Could not launch $url';
    }
  }
}
