import 'package:flutter/material.dart';

class CollectCell extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CollectState();
  }
}

class CollectState extends State<CollectCell> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: 4,
      itemBuilder: (context, rownumber) {
        var _currentIcon = "Icon(Icons.bookmark_border)";
        _onChanged() {
          setState(() {
            if (_currentIcon == "Icon(Icons.bookmark)") {
              _currentIcon = "Icon(Icons.bookmark_border)";
            } else {
              _currentIcon = "Icon(Icons.bookmark)";
            }
          });
        }

        return new FlatButton(
          padding: EdgeInsets.all(0.0),
          child: new Column(
            children: <Widget>[
              new Card(
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16.0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Expanded(
                            flex: 9,
                            child: new Text("CollectActivity $rownumber"),
                          ),
                          Expanded(
                            flex: 1,
                            child: new IconButton(
                              icon: Icon(Icons.bookmark_border),
                              onPressed: _onChanged,
                            ),
                          ),
                        ],
                      ),
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
                  builder: (context) => null,
                ));
          },
        );
      },
    );
  }
}
