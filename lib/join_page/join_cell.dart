import 'package:flutter/material.dart';
import './joinactivity_detail.dart';

class JoinCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: 4,
      itemBuilder: (context, rownumber) {
        return new FlatButton(
          padding: EdgeInsets.all(0.0),
          child: new Column(
            children: <Widget>[
              new Card(
                child: new Container(
                  padding: EdgeInsets.all(16.0),
                  child: new Column(
                    children: <Widget>[
                      new Image.asset(
                        'images/IMG_7986.JPG',
                        fit: BoxFit.cover,
                      ),
                      new Text("JoinActivity $rownumber"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onPressed: ({dynamic $i: 2}) {
            print('cell tapped $rownumber');
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new JoinActivityDetailPage(),
                ));
          },
        );
      },
    );
  }
}
