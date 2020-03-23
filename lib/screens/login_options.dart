import 'package:HFM/screens/confirm_code.dart';
import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:toast/toast.dart';

class LoginOptions extends StatefulWidget {
  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

//GlobalKey<State<StatefulWidget>> _scaffoldKey = GlobalKey(debugLabel: 'A');
TextEditingController phoneTextController = new TextEditingController();
bool _phoneValidate = false;
String _number;

class _LoginOptionsState extends State<LoginOptions> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/adinkra_pattern.png'),
                  fit: BoxFit.cover),
              color: colortheme.primaryColor),
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
                  onPressed: () {},
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
        // child: TextField(
        //   controller: phoneTextController,
        //   decoration: InputDecoration(
        //     hintText: 'Enter your phone number',
        //     errorText: _phoneValidate ? 'Please enter a phone number' : null,
        //   ),
        //   onChanged: (text) {},
        // ),
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
            if (phoneNumber.length == 9){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ConfirmCode(phoneNumber: '0$phoneNumber')));
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
}
