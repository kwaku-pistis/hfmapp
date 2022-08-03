import 'dart:io';

import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/themes/colors.dart';
import 'package:HFM/widgets/button_widget.dart';
import 'package:HFM/widgets/switch_widget.dart';
import 'package:HFM/widgets/vendor_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rave_flutter/rave_flutter.dart';

class Payments extends StatefulWidget {
  final String extra;

  Payments({required this.extra});

  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  var _repository = Repository();
  late User _user;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var autoValidate = false;
  bool acceptCardPayment = true;
  bool acceptAccountPayment = true;
  bool acceptMpesaPayment = false;
  bool shouldDisplayFee = true;
  bool acceptAchPayments = false;
  bool acceptGhMMPayments = true;
  bool acceptUgMMPayments = false;
  bool acceptMMFrancophonePayments = false;
  bool live = false;
  bool preAuthCharge = false;
  bool addSubAccounts = false;
  List<SubAccount> subAccounts = [];
  String email = '';
  double amount = 0.0;
  String publicKey = "FLWPUBK-795349cc358b4d96003546de855fabe5-X";
  String encryptionKey = "b03b6272ecafe12b99089a8a";
  late String txRef;
  String orderRef = '';
  String narration = '';
  String currency = 'GHS';
  String country = 'GH';
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    retrieveUserDetails();
    super.initState();
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
    //_future = _repository.retrieveUserPosts(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Make Payment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: colortheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Payment for ${widget.extra}',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                // SwitchWidget(
                //   value: acceptCardPayment,
                //   title: 'Accept card payments',
                //   onChanged: (value) =>
                //       setState(() => acceptCardPayment = value),
                // ),
                // SwitchWidget(
                //   value: acceptAccountPayment,
                //   title: 'Accept account payments',
                //   onChanged: (value) =>
                //       setState(() => acceptAccountPayment = value),
                // ),
                // SwitchWidget(
                //   value: acceptMpesaPayment,
                //   title: 'Accept Mpesa payments',
                //   onChanged: (value) =>
                //       setState(() => acceptMpesaPayment = value),
                // ),
                // SwitchWidget(
                //   value: shouldDisplayFee,
                //   title: 'Should Display Fee',
                //   onChanged: (value) =>
                //       setState(() => shouldDisplayFee = value),
                // ),
                // SwitchWidget(
                //   value: acceptAchPayments,
                //   title: 'Accept ACH payments',
                //   onChanged: (value) =>
                //       setState(() => acceptAchPayments = value),
                // ),
                // SwitchWidget(
                //   value: acceptGhMMPayments,
                //   title: 'Accept GH Mobile money payments',
                //   onChanged: (value) =>
                //       setState(() => acceptGhMMPayments = value),
                // ),
                // SwitchWidget(
                //   value: acceptUgMMPayments,
                //   title: 'Accept UG Mobile money payments',
                //   onChanged: (value) =>
                //       setState(() => acceptUgMMPayments = value),
                // ),
                // SwitchWidget(
                //   value: acceptMMFrancophonePayments,
                //   title: 'Accept Mobile money Francophone Africa payments',
                //   onChanged: (value) =>
                //       setState(() => acceptMMFrancophonePayments = value),
                // ),
                // SwitchWidget(
                //   value: live,
                //   title: 'Live',
                //   onChanged: (value) => setState(() => live = value),
                // ),
                // SwitchWidget(
                //   value: preAuthCharge,
                //   title: 'Pre Auth Charge',
                //   onChanged: (value) => setState(() => preAuthCharge = value),
                // ),
                // SwitchWidget(
                //     value: addSubAccounts,
                //     title: 'Add subaccounts',
                //     onChanged: onAddAccountsChange),
                buildVendorRefs(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        // TextFormField(
                        //   decoration: InputDecoration(hintText: 'Email'),
                        //   onSaved: (value) => email = value,
                        // ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Amount to charge (GHS)'),
                          onSaved: (value) => amount = double.tryParse(value!)!,
                          keyboardType: TextInputType.number,
                        ),
                        // SizedBox(height: 20),
                        // TextFormField(
                        //   decoration: InputDecoration(hintText: 'txRef'),
                        //   onSaved: (value) => txRef = value,
                        //   initialValue:
                        //       "rave_flutter-${DateTime.now().toString()}",
                        //   validator: (value) =>
                        //       value.trim().isEmpty ? 'Field is required' : null,
                        // ),
                        // SizedBox(height: 20),
                        // TextFormField(
                        //   decoration: InputDecoration(hintText: 'orderRef'),
                        //   onSaved: (value) => orderRef = value,
                        //   initialValue:
                        //       "rave_flutter-${DateTime.now().toString()}",
                        //   validator: (value) =>
                        //       value.trim().isEmpty ? 'Field is required' : null,
                        // ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Narration'),
                          onSaved: (value) => narration = value!,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Currency code e.g GHS'),
                          onSaved: (value) => currency = value!,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Country code e.g GH'),
                          onSaved: (value) => country = value!,
                        ),
                        SizedBox(height: 20),
                        // TextFormField(
                        //   decoration: InputDecoration(hintText: 'First name'),
                        //   onSaved: (value) => firstName = value,
                        // ),
                        // SizedBox(height: 20),
                        // TextFormField(
                        //   decoration: InputDecoration(hintText: 'Last name'),
                        //   onSaved: (value) => lastName = value,
                        // ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text('Start Payment'), 
                  onPressed: validateInputs
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildVendorRefs() {
    if (!addSubAccounts) {
      return SizedBox();
    }

    addSubAccount() async {
      var subAccount = await showDialog<SubAccount>(
          context: context, builder: (context) => AddVendorWidget());
      if (subAccount != null) {
        // if (subAccounts == null) subAccounts = [];
        setState(() => subAccounts.add(subAccount));
      }
    }

    var buttons = <Widget>[
      ElevatedButton(
        onPressed: addSubAccount,
        child: Text('Add vendor'),
      ),
      SizedBox(
        width: 10,
        height: 10,
      ),
      ElevatedButton(
        onPressed: () => onAddAccountsChange(false),
        child: Text('Clear'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Your current vendor refs are: ${subAccounts.map((a) => '${a.id}(${a.transactionSplitRatio})').join(', ')}',
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Platform.isIOS
                ? Column(
                    children: buttons,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buttons,
                  ),
          )
        ],
      ),
    );
  }

  onAddAccountsChange(bool value) {
    setState(() {
      addSubAccounts = value;
      if (!value) {
        subAccounts.clear();
      }
    });
  }

  void validateInputs() {
    var formState = formKey.currentState;
    if (!formState!.validate()) {
      setState(() => autoValidate = true);
      return;
    }

    formState.save();
    startPayment();
  }

  void startPayment() async {
    var initializer = RavePayInitializer(
        amount: amount,
        publicKey: publicKey,
        encryptionKey: encryptionKey,
        subAccounts: subAccounts.isEmpty ? null : null)
      ..country =
          country = country != null && country.isNotEmpty ? country : "GH"
      ..currency = currency != null && currency.isNotEmpty ? currency : "GHS"
      ..email = _user.email
      ..fName = _user.name
      ..lName = _user.name
      ..narration = narration
      ..txRef = widget.extra
      ..orderRef = orderRef
      ..acceptMpesaPayments = acceptMpesaPayment
      ..acceptAccountPayments = acceptAccountPayment
      ..acceptCardPayments = acceptCardPayment
      ..acceptAchPayments = acceptAchPayments
      ..acceptGHMobileMoneyPayments = acceptGhMMPayments
      ..acceptUgMobileMoneyPayments = acceptUgMMPayments
      ..acceptMobileMoneyFrancophoneAfricaPayments = acceptMMFrancophonePayments
      ..displayEmail = false
      ..displayAmount = true
      ..staging = !live
      ..isPreAuth = preAuthCharge
      ..displayFee = shouldDisplayFee;

    var response = await RavePayManager()
        .prompt(context: context, initializer: initializer);
    print(response);
    scaffoldKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.message)));
  }
}
