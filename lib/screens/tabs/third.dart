import 'package:flutter/material.dart';

import '../../themes/colors.dart';

class Third extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(5),
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Give your church offering...',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    //padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              'PLEDGE',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: colortheme.accentColor,
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text(
                            'GIVE',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: colortheme.accentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),Card(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Give your First Fruit offering...',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    //padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              'PLEDGE',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: colortheme.accentColor,
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text(
                            'GIVE',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: colortheme.accentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),Card(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Give your Projects offering...',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    //padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              'PLEDGE',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: colortheme.accentColor,
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text(
                            'GIVE',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: colortheme.accentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),Card(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Special Pledges redeemed by Members...',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    //padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              'PLEDGE',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: colortheme.accentColor,
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text(
                            'GIVE',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: colortheme.accentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Give your Thanksgiving offering...',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    //padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              'PLEDGE',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: colortheme.accentColor,
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text(
                            'GIVE',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: colortheme.accentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
