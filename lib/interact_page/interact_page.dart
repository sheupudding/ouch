import 'package:flutter/material.dart';
import './announce.dart';
import './Interact_cell.dart';

class InteractPage extends StatefulWidget {
  @override
  _InteractState createState() => _InteractState();
}

class _InteractState extends State<InteractPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('烤肉趴'),
          actions: <Widget>[
            new Padding(
              padding: EdgeInsets.all(15),
              child: new Container(
                width: 70.0,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(16.0),
                  color: Colors.black12,
                ),
                child: Center(
                  child: new Text('未報名'),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.book),
                    new Text('公告'),
                  ],
                ),
              ),
              Tab(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.people),
                    new Text('功能模式'),
                  ],
                ),
              ),
              Tab(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.announcement),
                    new Text('意見回饋'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            new AnnouncePage(),
            new InteractCell(),
            new Container(
              color: Colors.lightGreen,
            ),
          ],
        ),
      ),
    );
  }
}
