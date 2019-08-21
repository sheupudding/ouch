import 'package:flutter/material.dart';
import './interact_detail.dart';

class InteractCell extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InteractState();
  }
}

class InteractState extends State<InteractCell> {
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
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Expanded(
                            flex: 7,
                            child: new Text("互動名稱 $rownumber" ,style: TextStyle(fontSize: 15),),
                          ),
                          Expanded(
                            flex: 3,
                            child: new Container(
                              height: 30,
                              width: 70.0,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(16.0),
                                color: Colors.black12,
                              ),
                              child: Center(
                                child: new Text('？人看過/參加'),
                              ),
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
                  builder: (context) => InteractDetail(),
                ));
          },
        );
      },
    );
  }
}
