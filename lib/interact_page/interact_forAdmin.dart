import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './lottery_forAdmin.dart';
import './match_forAdmin.dart';
import 'lotteryDetail_forAdmin.dart';
import 'matchDetail_forAdmin.dart';

class InteractPage extends StatefulWidget {
  InteractPage({Key key, this.userId, this.post}) : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _InteractPageState createState() =>
      _InteractPageState(userId: userId, post: post);
}

class _InteractPageState extends State<InteractPage> {
  _InteractPageState({Key key, this.userId, this.post});
  final String userId;
  final DocumentSnapshot post;

  String _userName = '';

  Future getNickName(userId) async {
    var respectsQuery = Firestore.instance
        .collection('users')
        .where('userid', isEqualTo: userId);
    var querySnapshot = await respectsQuery.getDocuments();
    setState(() {
      _userName = querySnapshot.documents[0]['displayName'];
    });
    return querySnapshot.documents[0]['displayName'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('interact')
            .where('activityId', isEqualTo: post.documentID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: const Text('Loading...'),
            );
          return new ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return new Padding(
                padding: EdgeInsets.all(10.0),
                child: new ListTile(
                  onTap: () {
                    snapshot.data.documents[index]['type']=='抽獎模式'?
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) =>
                              LotteryDetailPage(userId: userId, post: snapshot.data.documents[index],),
                        )): snapshot.data.documents[index]['type']=='配對模式'? Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) =>
                              MatchDetailPage(userId: userId, post: snapshot.data.documents[index],),
                        )) : null;
                  },
                  title: new Card(
                    child: new Container(
                      padding: EdgeInsets.all(16.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: new Text(
                                snapshot.data.documents[index]['title'],
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                  child: Row(
                                children: <Widget>[
                                  new Icon(
                                    Icons.account_circle,
                                    size: 20,
                                  ),
                                  new Text(post.data['creatorName']),
                                ],
                              )),
                              new Text(
                                snapshot.data.documents[index]['type'],
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _buildInteract(),
        icon: new Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: new Text('新增', maxLines: 1),
      ),
    );
  }

  _buildInteract() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("選擇模式"),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    splashColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Text('抽獎',
                        style: TextStyle(
                          color: Colors.blueGrey,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) =>
                                new LotteryPage(userId: userId, post: post),
                          ));
                    },
                  ),
                  OutlineButton(
                    splashColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Text('配對',
                        style: TextStyle(
                          color: Colors.blueGrey,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) =>
                                new MatchPage(userId: userId, post: post),
                          ));
                    },
                  ),
                  OutlineButton(
                    splashColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Text('開發中...',
                        style: TextStyle(
                          color: Colors.blueGrey,
                        )),
                    onPressed: () => {},
                  ),
                ],
              ),
            ),
            // actions: <Widget>[
            //   FlatButton(
            //     child: Text("發佈"),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   ),
            //   FlatButton(
            //     child: Text("取消"),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   )
            // ],
          );
        });
  }
}
