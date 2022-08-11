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
  String? phoneNumber;
  bool validNumber = false;
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
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/adinkra_pattern.png'),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to HarvestFields',
                  style: TextStyle(
                    color: colorTheme.primaryColor,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    // shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/hfm.png'),
                        fit: BoxFit.fitHeight),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  margin: const EdgeInsets.only(
                    top: 40,
                  ),
                  child: ElevatedButton(
                    onPressed: () => _openPhoneDialog(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        colorTheme.primaryColorDark,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(8),
                    ),
                    child: const Text(
                      'SIGN UP WITH PHONE NUMBER',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  margin: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () => _openEmailDialog(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        colorTheme.primaryColor,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(8),
                    ),
                    child: const Text(
                      'SIGN UP WITH EMAIL ADDRESS',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  margin: const EdgeInsets.only(
                    top: 16,
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(8),
                    ),
                    child: _setUpDialogChild(),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  margin: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue[900]!,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(8),
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

  _openPhoneDialog() {
    return Dialogs.materialDialog(
      // title: 'Phone Number Sign Up',
      // color: Colors.grey,
      customView: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Phone Number Sign Up',
                style: TextStyle(
                  color: colorTheme.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                  setState(() {
                    phoneNumber = number.phoneNumber!;
                  });
                },
                onInputValidated: (bool value) {
                  print(value);
                  setState(() {
                    validNumber = value;
                  });
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: const TextStyle(color: Colors.black),
                initialValue: number,
                maxLength: 9,
                countries: const ['GH', 'NG'],
                textFieldController: numberTextController,
                spaceBetweenSelectorAndTextField: 4,
                formatInput: false,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: const OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },
              ),
            ],
          )),
      actions: <Widget>[
        SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                colorTheme.primaryColorDark,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              elevation: MaterialStateProperty.all(8),
            ),
            child: Text(
              'VERIFY PHONE NUMBER',
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(fontSize: 16.0, color: Colors.white),
            ),
            onPressed: () {
              if (validNumber) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ConfirmCode(phoneNumber: phoneNumber!)));
              }
            },
          ),
        )
      ],
      context: context,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive) {
      // _retrieveDynamicLink();
    }
  }

  _openEmailDialog() {
    return Dialogs.materialDialog(
      customView: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Email Sign Up',
              style: TextStyle(
                color: colorTheme.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: emailTextController,
              decoration: InputDecoration(
                hintText: 'Enter your email address',
                errorText:
                    _phoneValidate ? 'Please enter an email address' : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (text) {},
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                colorTheme.primaryColorDark,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              elevation: MaterialStateProperty.all(8),
            ),
            child: Text(
              'VERIFY EMAIL ADDRESS',
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(fontSize: 16.0, color: Colors.white),
            ),
            onPressed: () {
              if (validNumber) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ConfirmCode(phoneNumber: phoneNumber!)));
              }
            },
          ),
        )
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
