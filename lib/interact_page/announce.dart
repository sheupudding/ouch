import 'package:flutter/material.dart';

class AnnouncePage extends StatelessWidget {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: new Text("地點更改了喔喔喔",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                      new Row(
                        children: <Widget>[
                          new Icon(
                            Icons.account_circle,
                            size: 20,
                          ),
                          new Text('USER'),
                        ],
                      ),
                      new Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('！注意！本次地點由球哥家更換到球哥家陽台'),
                              new Image.asset(
                                'images/IMG_5841.JPG',
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        );
      },
    );
  }
}
