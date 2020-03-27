import 'package:flutter/material.dart';

import '../../themes/colors.dart';

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/adinkra_pattern.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text(
                    'HarvestFields Ministries',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'CALL US',
                    style: TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
              ),
              GestureDetector(
               child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'FIND US',
                    style: TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'CHECK IN',
                    style: TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
              ),
              GestureDetector(
               child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'DONATE',
                    style: TextStyle(fontSize: 16, color: colortheme.accentColor),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "HFM hasn't posted anything yet"
            ),
          ),
        ],
      ),
    );
  }
}
