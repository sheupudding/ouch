import 'package:flutter/material.dart';
import '../main.dart';
import '../build_page/build_interact_page.dart';
import './build_bottom.dart';

class BuildActivityDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: new Scaffold(
        appBar:
            AppBar(centerTitle: true, title: new Text("螞蟻學"), actions: <Widget>[
          new Padding(
            padding: EdgeInsets.all(15),
            child: new Container(
              width: 70.0,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(16.0),
                color: Colors.black12,
              ),
              child: Center(
                child: new Text('已啟動'),
              ),
            ),
          ),
        ]),
        body: TabBarView(
          // controller: _tabController,
          children: [
            new ActivityBody(),
            new Container(
              color: Colors.red,
            ),
            new Container(
              color: Colors.yellow,
            ),
            new Container(
              color: Colors.red,
            ),
            new Container(
              color: Colors.red,
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: new BuildBottomPart(),
        ),
      ),
    );
  }
}

class ActivityBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
        itemCount: 1,
        itemBuilder: (context, rownumber) {
          return new Container(
            padding: EdgeInsets.all(16.0),
            child: new Column(
              children: <Widget>[
                new Image.asset(
                  'images/IMG_7940.JPG',
                  fit: BoxFit.cover,
                ),
                new Container(
                  height: 16.0,
                ),
                new Container(
                  child: new Column(children: <Widget>[
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new FlatButton(
                          child: new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.account_circle,
                              ),
                              new Text('USER'),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => new BlankPage(),
                                ));
                          },
                        ),
                        new Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('介紹'),
                              new Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text('時間   2020/2/14 12:00-21:00'),
                                  ],
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text('地點  高雄大學'),
                                  ],
                                ),
                              ),
                              new Container(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Padding(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: new Text('已報名人數 15/60'),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: new Text('價錢  吃飽飽票 ＄300'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('button click');
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new InteractPage(),
              ));
        },
        icon: new Icon(
          Icons.record_voice_over,
          color: Colors.white,
        ),
        label: new Text('互動', maxLines: 1),
      ),
    );
  }
}
