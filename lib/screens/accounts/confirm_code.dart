import 'package:HFM/screens/accounts/profile.dart';
import 'package:HFM/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ConfirmCode extends StatefulWidget {
  @override
  _ConfirmCodeState createState() =>
      _ConfirmCodeState(phoneNumber: phoneNumber);

  final String phoneNumber;

  ConfirmCode({required this.phoneNumber});
}

TextEditingController codeTextController = new TextEditingController();
String currentText = '';
int _state = 0;
FirebaseUser? _user;
String _smsVerificationCode = '';

FirebaseAuth _auth = FirebaseAuth.instance;

class _ConfirmCodeState extends State<ConfirmCode> {
  String phoneNumber;

  _ConfirmCodeState({required this.phoneNumber});

  @override
  void initState() {
    verifyPhone();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Phone Number',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/adinkra_pattern.png'),
            fit: BoxFit.cover,
          )),
          padding: EdgeInsets.only(left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  'A six digit code has been sent to $phoneNumber',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  'Enter code:',
                  style: TextStyle(
                    fontSize: 26,
                    color: colortheme.accentColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: PinCodeTextField(
                  length: 6,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  shape: PinCodeFieldShape.underline,
                  animationDuration: Duration(milliseconds: 300),
                  //borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  backgroundColor: Colors.white,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  enableActiveFill: false,
                  controller: codeTextController,
                  textStyle: TextStyle(color: Colors.black),
                  textInputType: TextInputType.numberWithOptions(),
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                ),
              ),
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    'Resend code',
                    style: TextStyle(
                      fontSize: 16,
                      color: colortheme.accentColor,
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
                margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
                height: 50,
                child: RaisedButton(
                  child: _setUpButtonChild(),
                  textColor: Colors.white,
                  color: colortheme.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    setState(() {
                      _state = 1;
                    });
                    _signInWithPhoneNumber(codeTextController.text);
                  },
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
        phoneNumber: phoneNumber,
        timeout: Duration(minutes: 1),
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
    Toast.show('Resending code...', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool runState = (prefs.getBool('disableResend') ?? false);

    if (!runState) {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(minutes: 2),
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
          context,
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
    }
  }

  void _signInWithPhoneNumber(String smsCode) async {
    AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _smsVerificationCode, smsCode: smsCode);

    _user = await _auth.signInWithCredential(credential).then((onValue) {
      Toast.show('Code confirmed', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    data: phoneNumber,
                    user: _user!,
                  )),
          ModalRoute.withName('/'));
      return onValue.user;
    });
  }

  Widget _setUpButtonChild() {
    if (_state == 0) {
      return Text(
        'CONFIRM',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  /// will get an AuthCredential object that will help with logging into Firebase.
  _verificationComplete(AuthCredential authCredential, BuildContext context) {
    _auth.signInWithCredential(authCredential).then((authResult) {
      // final snackBar =
      //     SnackBar(content: Text("Success!!! UUID is: " + authResult.user.uid));
      // _user = authResult.user;
      // Scaffold.of(context).showSnackBar(snackBar);

      Toast.show('Code confirmed', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    data: phoneNumber,
                    user: authResult.user,
                  )),
          ModalRoute.withName('/'));
    });
  }

  _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
    Toast.show('Code is sent to $phoneNumber', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    final snackBar = SnackBar(
        content:
            Text("Exception!! message:" + authException.message.toString()));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
  }
}
