import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../interact_page/announce_forAdmin.dart';
import '../interact_page/interact_forAdmin.dart';
import '../interact_page/share_forAdmin.dart';
import 'tryImage.dart';

class Interact extends StatefulWidget {
  Interact({Key key, this.userId, this.post})
      : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _InteractState createState() => _InteractState(userId: userId, post: post);
}

class _InteractState extends State<Interact> {
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
            new InteractPage(userId: userId, post: post),
            new SharePage(userId: userId, post: post)
            // new ImagePage()
          ],
        ),
      ),
    );
  }
}
