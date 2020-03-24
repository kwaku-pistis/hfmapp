import 'package:HFM/screens/confirm_code.dart';
import 'package:HFM/screens/profile.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginOptions extends StatefulWidget {
  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

//GlobalKey<State<StatefulWidget>> _scaffoldKey = GlobalKey(debugLabel: 'A');
TextEditingController emailTextController = new TextEditingController();
bool _phoneValidate = false;
int _state = 0;
String _emailAddress;
String _link;
String emailAdd;

final FirebaseAuth _auth = FirebaseAuth.instance;
// FirebaseUser _user;

class _LoginOptionsState extends State<LoginOptions>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _retrieveDynamicLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: colortheme.primaryColor,
            fontSize: 40,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        bottomOpacity: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/adinkra_pattern.png'),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(bottom: 40, top: 40, left: 20, right: 20),
                  child: Text(
                    'Use any of the following means to register for HarverstFields Ministries app',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/hfm.jpeg'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: EdgeInsets.only(
                    top: 40,
                  ),
                  child: RaisedButton(
                    onPressed: () {
                      showPhoneDialog(
                          context: context, child: _openPhoneDialog());
                    },
                    child: Text(
                      'ENTER YOUR PHONE NUMBER',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: colortheme.accentColor,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  child: RaisedButton(
                    onPressed: () {
                      showPhoneDialog(
                          context: context, child: _openEmailDialog());
                    },
                    child: Text(
                      'ENTER YOUR EMAIL ADDRESS',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: colortheme.primaryColor,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'SIGN IN WITH GOOGLE',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: Color(0xffDB4437),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'LOG IN WITH FACEBOOK',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: Colors.blue[900],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void showPhoneDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('You selected: $value'),
        ));
      }
    });
  }

  _openPhoneDialog() {
    return MaterialDialog(
      enableFullWidth: true,
      enableFullHeight: true,
      title: Text('Phone Number Sign Up'),
      //subTitle: Text('Subtitle'),
      content: Container(
        // child: InternationalPhoneNumberInput(
        //   onInputChanged: (PhoneNumber number) {
        //     _number = number.phoneNumber;
        //     print(number.phoneNumber);
        //   },
        //   inputDecoration: InputDecoration(

        //   ),
        //   isEnabled: true,
        //   autoValidate: _phoneValidate,
        //   formatInput: true,
        //   textFieldController: phoneTextController,
        //   errorMessage: _phoneValidate ? 'Please enter a phone number' : null,
        // ),
        child: InternationalPhoneInput(
          onPhoneNumberChange: onPhoneNumberChange,
          initialPhoneNumber: phoneNumber,
          initialSelection: phoneIsoCode,
          enabledCountries: [
            '+233',
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'VERIFY NUMBER',
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontSize: 16.0, color: colortheme.accentColor),
          ),
          onPressed: () {
            if (phoneNumber.length == 9) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ConfirmCode(phoneNumber: '+233$phoneNumber')));
            }
          },
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive) {
      _retrieveDynamicLink();
    }
  }

  _openEmailDialog() {
    return MaterialDialog(
      enableFullWidth: true,
      enableFullHeight: true,
      title: Text('Email Sign Up'),
      content: Container(
        child: _setUpDialogChild(),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'VERIFY EMAIL',
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontSize: 16.0, color: colortheme.accentColor),
          ),
          onPressed: () {
            if (emailTextController.text.isNotEmpty) {
              Toast.show('verifying email...', context,
                  gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
              Navigator.of(context).pop();
              // setState(() {
              //   _state = 1;
              // });
              _emailAddress = emailTextController.text;
              _sendVerificationLink(_emailAddress);
            } else {
              _phoneValidate = true;
            }
          },
        ),
      ],
    );
  }

  String phoneNumber;
  String phoneIsoCode;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  _sendVerificationLink(String _email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String emailAdd = (prefs.getString('emailAddress') ?? null);
    await prefs.setString('emailAddress', _email);

    await _auth
        .sendSignInWithEmailLink(
            email: _email,
            androidInstallIfNotAvailable: true,
            iOSBundleID: "com.ministry.hfmapp",
            androidMinimumVersion: "16",
            androidPackageName: "com.ministry.hfmapp",
            url: "https://hfmapp.page.link/harverstfields",
            handleCodeInApp: true)
        .then((onValue) {
      Toast.show(
          'A verification link has been sent to $_emailAddress. Please go and verify the link to sign in.',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    });
  }

  _retrieveDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.retrieveDynamicLink();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailAdd = (prefs.getString('emailAddress') ?? null);

    final Uri deepLink = data?.link;
    print(deepLink.toString());

    if (deepLink.toString() != null && emailAdd != null) {
      _link = deepLink.toString();
      Toast.show('Siging in...', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _signInWithEmailAndLink();
    }
    return deepLink.toString();
  }

  _signInWithEmailAndLink() async {
    bool validLink = await _auth.isSignInWithEmailLink(_link);
    if (validLink) {
      try {
        await _auth
            .signInWithEmailAndLink(email: emailAdd, link: _link)
            .then((authResult) {
          // _user = authResult.user;
          Toast.show('Sign in successful', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  Profile(data: emailAdd, user: authResult.user)));
        });
      } catch (e) {
        print(e);
        //_showDialog(e.toString());
        Toast.show('An error occured. Email not sent', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    }
  }

  Widget _setUpDialogChild() {
    if (_state == 0) {
      return TextField(
        controller: emailTextController,
        decoration: InputDecoration(
          hintText: 'Enter your email address',
          errorText: _phoneValidate ? 'Please enter an email address' : null,
        ),
        onChanged: (text) {},
        keyboardType: TextInputType.emailAddress,
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      );
    } else {
      return Text(
          'A verification link has been sent to $_emailAddress. Please go and verify the link to sign in.');
    }
  }
}
