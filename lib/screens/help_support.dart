import 'package:HFM/screens/about_hfm.dart';
import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({Key? key}) : super(key: key);

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

String packageName = '';
String version = '';

class _HelpSupportState extends State<HelpSupport> {
  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        packageName = packageInfo.packageName;
        version = packageInfo.version;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colorTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Help & Support',
                  style: TextStyle(color: colorTheme.primaryColor),
                ),
              ),
              GestureDetector(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          child: Icon(
                            Icons.email,
                            color: colorTheme.primaryColorDark,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.only(left: 25, top: 10),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: const Text(
                                    'Email Help Center',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: const Text(
                                    "We'd LOVE to hear from you! Tell us how we're doing, give us feedback, or just drop in to say hi!",
                                    style: TextStyle(),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _contactEmailCenter();
                  }),
              const Divider(
                height: 30.0,
              ),
              GestureDetector(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.phone,
                        color: colorTheme.primaryColorDark,
                        size: 30,
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 25, top: 10),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: const Text(
                                  'Call Us With Your Local Network',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: const Text(
                                  "Our client support staff are ready to hear from you",
                                  style: TextStyle(),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _showCallDialog();
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  'About the Church',
                  style: TextStyle(color: colorTheme.primaryColor),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 0, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 7),
                        child: const Text(
                          'About HARVERTFIELDS',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Important information about the church and its activities",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AboutHfm())),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  'About the Developer',
                  style: TextStyle(color: colorTheme.primaryColor),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 0, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 7),
                        child: const Text(
                          'About Deemiensa',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Deemiensa is software and technology company based in Ghana. We deal in all kinds of softwares aimed at providing solutions to problems all around us. \n\nContact Deemiensa for your app",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _contactDeveloper();
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  'Privacy & Security',
                  style: TextStyle(color: colorTheme.primaryColor),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 0, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 7),
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Review our privacy policy here",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  'About this App',
                  style: TextStyle(color: colorTheme.primaryColor),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 0, top: 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "version $version-HFM-release build 100",
                          style: const TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _launchPlayStore();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _contactEmailCenter() async {
    final Email mail = Email(
      body: '',
      subject: 'CONTACT HARVESTFIELDS',
      recipients: ['harvesters4ever@gmail.com'],
    );

    await FlutterEmailSender.send(mail).then((onValue) {
      Navigator.of(context).pop();
    });
  }

  _contactDeveloper() async {
    final Email mail = Email(
      body: '',
      subject: 'CONTACT DEEMIENSA',
      recipients: ['danielpartey.dp@gmail.com'],
    );

    await FlutterEmailSender.send(mail).then((onValue) {
      Navigator.of(context).pop();
    });
  }

  void _launchPlayStore() async {
    final url =
        Uri.parse('https://play.google.com/store/apps/details?id=$packageName');
    final appleUrl = Uri.parse("");
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else if (await launchUrl(appleUrl)) {
      await launchUrl(appleUrl);
    } else {
      throw 'Could not launch $url';
    }
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
                            colorTheme.primaryColor,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
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
                            colorTheme.primaryColor,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
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
                            colorTheme.primaryColor,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
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
}
