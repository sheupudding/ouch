import 'package:firebase_auth/firebase_auth.dart';
import 'package:ouch/auth.dart';
import 'root_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(OuchApp());

class OuchApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new RootPage(auth: new Auth(),),
    );
  }
}


class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:
          AppBar(centerTitle: true, title: new Text("Ouch!"), actions: <Widget>[
        new IconButton(
            icon: new Icon(
              Icons.account_circle,
              size: 40.0,
            ),
            onPressed: () {
              print('hello');
              // setState(() {
              // //  _isLoading = false;
              // });
            }),
      ]),
    );
  }
}
