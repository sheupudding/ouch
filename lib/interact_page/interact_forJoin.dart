import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lotteryDetail_forJoin.dart';
import 'matchDetail_forJoin.dart';

class InteractCell extends StatefulWidget {
  InteractCell({Key key, this.userId, this.post}) : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _InteractPageState createState() =>
      _InteractPageState(userId: userId, post: post);
}

class _InteractPageState extends State<InteractCell> {
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
                    snapshot.data.documents[index]['type'] == '抽獎模式'
                        ? Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => LotteryDetailPage(
                                userId: userId,
                                post: snapshot.data.documents[index],
                              ),
                            ))
                        : snapshot.data.documents[index]['type'] == '配對模式'
                            ? Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => MatchDetailPage(
                                    userId: userId,
                                    post: snapshot.data.documents[index],
                                  ),
                                ))
                            : null;
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
    );
  }
}
