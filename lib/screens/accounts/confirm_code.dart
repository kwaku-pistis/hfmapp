import 'package:HFM/screens/accounts/profile.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ConfirmCode extends StatefulWidget {
  final String phoneNumber;

  const ConfirmCode({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<ConfirmCode> createState() => _ConfirmCodeState();
}

TextEditingController codeTextController = TextEditingController();
String currentText = '';
int _state = 0;
User? _user;
String _smsVerificationCode = '';

FirebaseAuth _auth = FirebaseAuth.instance;

class _ConfirmCodeState extends State<ConfirmCode> {
  @override
  void initState() {
    verifyPhone();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Phone Number',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/adinkra_pattern.png'),
            fit: BoxFit.cover,
          )),
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 50),
                child: Text(
                  'A six digit code has been sent to ${widget.phoneNumber}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 50),
                child: Text(
                  'Enter code:',
                  style: TextStyle(
                    fontSize: 26,
                    color: colorTheme.primaryColorDark,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  animationDuration: const Duration(milliseconds: 300),
                  //borderRadius: BorderRadius.circular(5),
                  backgroundColor: Colors.white,
                  enableActiveFill: false,
                  controller: codeTextController,
                  textStyle: const TextStyle(color: Colors.black),
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  appContext: context,
                ),
              ),
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Resend code',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorTheme.primaryColorDark,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                onTap: () {
                  resendCode();
                },
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      colorTheme.primaryColorDark,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _state = 1;
                    });
                    _signInWithPhoneNumber(codeTextController.text);
                  },
                  child: _setUpButtonChild(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  verifyPhone() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: const Duration(minutes: 1),
        verificationCompleted: (authCredentials) =>
            _verificationComplete(authCredentials, context),
        verificationFailed: (authException) =>
            _verificationFailed(authException, context),
        codeSent: (verificationId, [int? code]) =>
            _smsCodeSent(verificationId, [code!]),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId));
  }

  resendCode() async {
    Toast.show('Resending code...',
        duration: Toast.lengthLong, gravity: Toast.center);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool runState = (prefs.getBool('disableResend') ?? false);

    if (!runState) {
      await _auth.verifyPhoneNumber(
          phoneNumber: widget.phoneNumber,
          timeout: const Duration(minutes: 2),
          verificationCompleted: (authCredentials) =>
              _verificationComplete(authCredentials, context),
          verificationFailed: (authException) =>
              _verificationFailed(authException, context),
          codeSent: (verificationId, [int? code]) =>
              _smsCodeSent(verificationId, [code!]),
          codeAutoRetrievalTimeout: (verificationId) =>
              _codeAutoRetrievalTimeout(verificationId));

      await prefs.setBool('disableResend', true);
    } else {
      Toast.show(
          'Resend code only work once. Try entering the email or phone number again.',
          gravity: Toast.bottom,
          duration: Toast.lengthLong);
    }
  }

  void _signInWithPhoneNumber(String smsCode) async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _smsVerificationCode, smsCode: smsCode);

    _user = await _auth.signInWithCredential(credential).then((onValue) {
      Toast.show('Code confirmed',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    data: widget.phoneNumber,
                    user: _user!,
                  )),
          ModalRoute.withName('/'));
      return onValue.user;
    });
  }

  Widget _setUpButtonChild() {
    if (_state == 0) {
      return const Text(
        'CONFIRM',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else if (_state == 1) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return const Icon(Icons.check, color: Colors.white);
    }
  }

  /// will get an AuthCredential object that will help with logging into Firebase.
  _verificationComplete(AuthCredential authCredential, BuildContext context) {
    _auth.signInWithCredential(authCredential).then((authResult) {
      // final snackBar =
      //     SnackBar(content: Text("Success!!! UUID is: " + authResult.user.uid));
      // _user = authResult.user;
      // Scaffold.of(context).showSnackBar(snackBar);

      Toast.show('Code confirmed',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    data: widget.phoneNumber,
                    user: authResult.user!,
                  )),
          ModalRoute.withName('/'));
    });
  }

  _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
    Toast.show('Code is sent to ${widget.phoneNumber}',
        duration: Toast.lengthLong, gravity: Toast.center);
  }

  _verificationFailed(Exception authException, BuildContext context) {
    final snackBar =
        SnackBar(content: Text("Exception!! message:$authException"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
  }
}
