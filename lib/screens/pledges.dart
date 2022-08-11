import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/themes/colors.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class Pledges extends StatefulWidget {
  final String extra;

  const Pledges({Key? key, required this.extra}) : super(key: key);

  @override
  State<Pledges> createState() => _PledgesState();
}

final format = DateFormat("dd-MM-yyyy");
var dateTextController = TextEditingController();
var amountController = TextEditingController();
bool _dateValidate = false;
bool _amtValidate = false;

class _PledgesState extends State<Pledges> {
  final _repository = Repository();
  late User _user;
  late String name;

  @override
  void initState() {
    retrieveUserDetails();
    super.initState();
  }

  retrieveUserDetails() async {
    auth.User currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;
      name = _user.name!;
    });
    //_future = _repository.retrieveUserPosts(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Financial Pledges',
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Pledge into ${widget.extra}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              // Expanded(
              //   child:
              // )
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        hintText: 'Amount to pledge',
                        hintStyle: const TextStyle(fontSize: 16),
                        errorText: _amtValidate
                            ? 'Enter an amount greater than 0'
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    child: Text(
                      'GHS',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 16),
                child: const Text(
                  'Redeem pledge by:',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.only(top: 16, right: 16),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            colorTheme.primaryColor),
                      ),
                      child: const Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: DateTimeField(
                      format: format,
                      controller: dateTextController,
                      decoration: InputDecoration(
                        hintText: 'date to redeem pledge',
                        hintStyle: const TextStyle(fontSize: 16),
                        errorText: _dateValidate ? 'Please pick a date' : null,
                        //contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue!,
                            lastDate: DateTime(2100));
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (amountController.text.isEmpty ||
                        amountController.text == '0') {
                      setState(() {
                        _amtValidate = true;
                      });
                    } else {
                      setState(() {
                        _amtValidate = false;
                      });
                    }

                    if (dateTextController.text.isEmpty) {
                      setState(() {
                        _dateValidate = true;
                      });
                    } else {
                      setState(() {
                        _dateValidate = false;
                      });
                    }

                    if (!_amtValidate && !_dateValidate) {
                      Toast.show('sending pledge',
                          duration: Toast.lengthLong, gravity: Toast.bottom);
                      _makeAPledge();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        colorTheme.primaryColorDark),
                  ),
                  child: const Text(
                    'MAKE A PLEDGE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _makeAPledge() async {
    final Email mail = Email(
      body:
          '$name has made a pledge of GHS ${amountController.text} to ${widget.extra} and to be redeemed by ${dateTextController.text}.',
      subject: '${widget.extra} Pledge',
      recipients: ['app.harvestfields@gmail.com'],
    );

    await FlutterEmailSender.send(mail).then((onValue) {
      Navigator.of(context).pop();
    });
  }
}
