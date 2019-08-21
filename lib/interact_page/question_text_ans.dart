import 'package:flutter/material.dart';

class QuesAnswer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0.0,
        title: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                BackButton(),
                Text("所有回復"),
              ],
            ),
            Divider(),
          ],
        ),
        content: new SingleChildScrollView(
            child: new Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: new Column(
            // loop
            children: new List.generate(
                25,
                (index) => new Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.all(20),
                        child: new Text(
                          "data",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )),
          ),
        )));
  }
}
