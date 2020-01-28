import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './announce_forJoin.dart';
import './interact_forJoin.dart';
import './share_forJoin.dart';

class InteractPage extends StatefulWidget {
  InteractPage({Key key, this.userId, this.post})
      : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _InteractState createState() => _InteractState(userId: userId, post: post);
}

class _InteractState extends State<InteractPage> {
  _InteractState({Key key, this.userId, this.post});
  final String userId;
  final DocumentSnapshot post;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(post['title']),
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
                    new Icon(Icons.dns),
                    new Text('功能模式'),
                  ],
                ),
              ),
              Tab(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.forum),
                    new Text('討論區'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            new AnnouncePage(userId: userId, post: post),
            new InteractCell(userId: userId, post: post),
            new SharePage(userId: userId, post: post),
          ],
        ),
      ),
    );
  }
}
