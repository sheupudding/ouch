import 'package:flutter/material.dart';
import '../main.dart';

class AnimateExpanded extends StatefulWidget {
  @override
  _AnimateExpandedState createState() => new _AnimateExpandedState();
}

class _AnimateExpandedState extends State<AnimateExpanded> {
  double _bodyHeight = 50.0;
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Card(
              child: new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new FlatButton(
                      child: new Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              child: new Text('報名資料'),
                            ),
                            new Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_bodyHeight == 50.0) {
                            this._bodyHeight = 300.0;
                          } else {
                            this._bodyHeight = 50.0;
                          }
                        });
                      },
                    ),
                    new Center(
                      child: new FlatButton(
                        child: new Container(
                          width: 70.0,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(16.0),
                            color: Colors.blueAccent,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                Icons.local_activity,
                                size: 20.0,
                                color: Colors.white,
                              ),
                              new Text(
                                '報名',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          print('join!');
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new BlankPage()));
                        },
                      ),
                    ),
                  ],
                ),
                height: _bodyHeight,
              ),
            ),
            // new Card(
            //   child: new AnimatedContainer(
            //     child: new Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         new IconButton(
            //           icon: new Icon(Icons.keyboard_arrow_up),
            //           onPressed: () {
            //             setState(() {
            //               this._bodyHeight = 50.0;
            //             });
            //           },
            //         ),
            //       ],
            //     ),
            //     curve: Curves.easeInOut,
            //     duration: const Duration(milliseconds: 500),
            //     height: _bodyHeight,
            //     // color: Colors.red,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
