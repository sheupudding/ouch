import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: 1,
        itemBuilder: (context, rownumber) {
          return new Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(30.0),
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      new Icon(
                        Icons.account_circle,
                        size: 80.0,
                      ),
                      new Container(
                        width: 15.0,
                        height: 20,
                      ),
                      new Text(
                        '樊幗馨',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              new FlatButton(
                child: new Text('個人資料'),
                splashColor: Colors.amber,
                onPressed: () {},
              ),
              new FlatButton(
                child: new Text('登出'),
                splashColor: Colors.amber,
                onPressed: () {},
              ),
            ],
          );
        });
  }
}
