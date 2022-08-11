import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/accounts/confirm_code.dart';
import 'package:HFM/screens/home.dart';
import 'package:HFM/screens/accounts/profile.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  State<LoginOptions> createState() => _LoginOptionsState();
}

TextEditingController emailTextController = TextEditingController();
TextEditingController numberTextController = TextEditingController();
bool _phoneValidate = false;
int _state = 0;
String _emailAddress = '';
String _link = '';
String emailAdd = '';

var _repository = Repository();

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class _LoginOptionsState extends State<LoginOptions>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String phoneNumber = '';
  PhoneNumber number = PhoneNumber();
  String parsableNumber = '';
  String phoneIsoCode = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // _retrieveDynamicLink();
    // number = PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
    // setState(() {
    //   parsableNumber = number.parseNumber();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Welcome to HarvestFields',
          style: TextStyle(
            color: colorTheme.primaryColor,
            fontSize: 30,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        bottomOpacity: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/adinkra_pattern.png'),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                      bottom: 40, top: 40, left: 20, right: 20),
                  child: const Text(
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
                    width: MediaQuery.of(context).size.width,
                    height: 192,
                    decoration: const BoxDecoration(
                      // shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/hfm.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: const EdgeInsets.only(
                    top: 40,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showPhoneDialog(
                          context: context, child: _openPhoneDialog());
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        colorTheme.primaryColorDark,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    child: const Text(
                      'ENTER YOUR PHONE NUMBER',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showPhoneDialog(
                          context: context, child: _openEmailDialog());
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        colorTheme.primaryColor,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    child: const Text(
                      'ENTER YOUR EMAIL ADDRESS',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _state = 1;
                      });
                      Toast.show('Loading...',
                          gravity: Toast.bottom, duration: Toast.lengthShort);
                      _signInWithGoogle();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffDB4437),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    child: _setUpDialogChild(),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue[900]!,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    child: const Text(
                      'LOG IN WITH FACEBOOK',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void showPhoneDialog<T>(
      {required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You selected: $value'),
        ));
      }
    });
  }

  _openPhoneDialog() {
    return Dialogs.materialDialog(
      title: 'Phone Number Sign Up',
      customView: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          print(number.phoneNumber);
        },
        onInputValidated: (bool value) {
          print(value);
        },
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: const TextStyle(color: Colors.black),
        initialValue: number,
        textFieldController: numberTextController,
        formatInput: false,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: const OutlineInputBorder(),
        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
        },
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            'VERIFY NUMBER',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(fontSize: 16.0, color: colorTheme.primaryColorDark),
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
      context: context,
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
    return Dialogs.materialDialog(
      title: 'Email Sign Up',
      customView: TextField(
        controller: emailTextController,
        decoration: InputDecoration(
          hintText: 'Enter your email address',
          errorText: _phoneValidate ? 'Please enter an email address' : null,
        ),
        onChanged: (text) {},
        keyboardType: TextInputType.emailAddress,
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            'VERIFY EMAIL',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(fontSize: 16.0, color: colorTheme.primaryColorDark),
          ),
          onPressed: () {
            if (emailTextController.text.isNotEmpty) {
              Toast.show('verifying email...',
                  gravity: Toast.center, duration: Toast.lengthShort);
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
      context: context,
    );
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  _sendVerificationLink(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String emailAdd = (prefs.getString('emailAddress') ?? null);
    await prefs.setString('emailAddress', email);

    var acs = ActionCodeSettings(
        url: 'https://hfmapp.page.link/harverstfields',
        handleCodeInApp: true,
        iOSBundleId: 'com.ministry.hfmapp',
        androidPackageName: 'com.ministry.hfmapp',
        // installIfNotAvailable
        androidInstallApp: true,
        // minimumVersion
        androidMinimumVersion: '10');

    await _auth
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .then((onValue) {
      Toast.show(
          'A verification link has been sent to $_emailAddress. Please go and verify the link to sign in.',
          duration: Toast.lengthLong,
          gravity: Toast.center);
    });
  }

  _retrieveDynamicLink() async {
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance
        .getDynamicLink(Uri.parse('https://hfmapp.page.link/harverstfields'));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailAdd = (prefs.getString('emailAddress'))!;

    final Uri deepLink = data!.link;
    print(deepLink.toString());

    _link = deepLink.toString();
    Toast.show('Signing in...',
        duration: Toast.lengthLong, gravity: Toast.bottom);
    _signInWithEmailAndLink();
    return deepLink.toString();
  }

  _signInWithEmailAndLink() async {
    bool validLink = _auth.isSignInWithEmailLink(_link);
    if (validLink) {
      try {
        await _auth
            .signInWithEmailLink(email: emailAdd, emailLink: _link)
            .then((authResult) {
          // _user = authResult.user;
          Toast.show('Sign in successful',
              duration: Toast.lengthLong, gravity: Toast.bottom);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  Profile(data: emailAdd, user: authResult.user!)));
        });
      } catch (e) {
        print(e);
        //_showDialog(e.toString());
        Toast.show('An error occurred. Email not sent',
            duration: Toast.lengthLong, gravity: Toast.center);
      }
    }
  }

  Widget _setUpDialogChild() {
    if (_state == 0) {
      return const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(
          color: Colors.white,
        ),
      );
    } else if (_state == 1) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Text(
          'A verification link has been sent to $_emailAddress. Please go and verify the link to sign in.');
    }
  }

  _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // final authHeaders = _googleSignIn.currentUser.authHeaders;
    // final httpClient = GoogleHttpClient(authHeaders);

    // var data = await PeopleApi(httpClient).people.connections.list(
    //       'people/me',
    //       personFields: 'names,addresses',
    //       //pageToken: nextPageToken,
    //       pageSize: 100,
    //     );

    //PeopleApi(httpClient).people.get(resourceName)

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //final FirebaseUser user =
    await _auth.signInWithCredential(credential).then((onValue) {
      _repository.addDataToDb(onValue.user!).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Home(user: null);
        }));
      });
    });
    //print("signed in " + user.displayName);

    //FirebaseUser user = await _auth.currentUser();
    // _repository.addDataToDb(user).then((value) {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //     return Home(user: null);
    //   }));
    // });
  }

  // _saveDataToFirebaseDB(AuthResult authResult) async {
  //   //String downloadUrl = taskSnapshot != null ? await taskSnapshot.ref.getDownloadURL() : '';
  //   DocumentReference storeReference = Firestore.instance
  //       .collection('User Info')
  //       .document(authResult.user.uid);
  //   await storeReference.setData({
  //     'Name': authResult.user.displayName,
  //     'Email / Phone': authResult.user.email,
  //     'Username': authResult.user.displayName,
  //     'Gender': '',
  //     'Profile Image': authResult.user.photoUrl,
  //   }).then((onValue) {
  //     _saveUserDetails(authResult.user);
  //   });
  // }

  // _saveUserDetails(FirebaseUser user) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.setString('name', user.displayName);
  //   await preferences.setString('emailOrPhone', user.email);
  //   await preferences.setString('username', user.displayName);
  //   await preferences.setString('profileImage', user.photoUrl);

  //   Toast.show('Done', context,
  //       gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (BuildContext context) => Home(user: user)));
  // }
}
