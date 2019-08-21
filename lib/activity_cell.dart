import 'package:flutter/material.dart';
import './activity_detail.dart';
import './build_page/build_page.dart';

class ActivityCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body:
            //   new IconButton(
            //     icon: new Icon(Icons.format_align_left),
            //     onPressed: () {
            //       print('tagss');
            //     },
            //   ),
            //   new IconButton(
            //     icon: new Icon(Icons.search),
            //     onPressed: () {
            //       print('search');
            //     },
            //   ),
            //   new IconButton(
            //     icon: new Icon(Icons.notifications),
            //     onPressed: () {
            //       print('oh!');
            //     },
            //   ),
            // ]),
            new ListView.builder(
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
                            'images/IMG_5841.JPG',
                            fit: BoxFit.cover,
                          ),
                          new Text("Activity $rownumber"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // onPressed: ({dynamic $i: 1}) {
              //   print('cell tapped $rownumber');
              //   Navigator.push(
              //       context,
              //       new MaterialPageRoute(
              //         builder: (context) => new ActivityDetailPage(),
              //       ));
              // },
              onPressed: ({dynamic $i: 2}) {
                print('cell tapped $rownumber');
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new ActivityDetailPage(),
                    ));
              },
            );
          },
        ),
        floatingActionButton:
            // _tabController.index == 0
            // ?
            FloatingActionButton.extended(
          onPressed: () {
            print('add');
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new BuildActivity(),
                ));
          },
          icon: new Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: new Text('建立', maxLines: 1),
        ));
  }
}
