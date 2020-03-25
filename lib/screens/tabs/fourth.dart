import 'package:HFM/screens/accounts/profile_details.dart';
import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String name;

class Fourth extends StatefulWidget {
  @override
  _FourthState createState() => _FourthState();
}

class _FourthState extends State<Fourth> {
  @override
  void initState() {
    super.initState();

    _retrieveLocalData();
  }

  @override
  Widget build(BuildContext context) {
    //_retrieveLocalData();
    return SingleChildScrollView(
      child: Container(
        //color: colortheme.primaryColor,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              //height: 120,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/adinkra_pattern.png'),
                fit: BoxFit.cover,
              )),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/profile.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              name != null ? name : 'name',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              'member',
                              style: TextStyle(),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: colortheme.accentColor,
              ),
              title: Text('Profile'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ProfileDetails()
              )),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: colortheme.accentColor,
              ),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: colortheme.accentColor,
              ),
              title: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }

  _retrieveLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = (preferences.getString('name') ?? null);
    });
  }
}
