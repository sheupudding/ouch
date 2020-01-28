import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncePage extends StatefulWidget {
  AnnouncePage({Key key, this.userId, this.post}) : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _AnnouncePageState createState() =>
      _AnnouncePageState(userId: userId, post: post);
}

class _AnnouncePageState extends State<AnnouncePage> {
  _AnnouncePageState({Key key, this.userId, this.post});
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

  Widget commentText(BuildContext context, announce) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('announceComment')
            .where('announceId', isEqualTo: announce.documentID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("0 則留言");
          } else if (snapshot.data.documents.length == 0 && snapshot.hasData) {
            return new Text("0 則留言");
          } else {
            return new Text(
              snapshot.data.documents.length.toString() + " 則留言",
              style: TextStyle(color: Colors.grey),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('announce')
            .where('activityId', isEqualTo: post.documentID)
            .orderBy('time', descending: true)
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
                child: new Column(
                  children: <Widget>[
                    new Card(
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
                                  ),
                                ),
                                Text(
                                  DateFormat("yyyy-MM-dd HH:mm").format(snapshot
                                      .data.documents[index]['time']
                                      .toDate()),
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                )
                              ],
                            ),
                            new Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(snapshot.data.documents[index]
                                        ['content']),
                                  ],
                                ),
                              ),
                            ),
                            new Divider(),
                            Stack(
                              children: <Widget>[
                                Center(
                                  child: OutlineButton(
                                    splashColor: Colors.blueGrey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    highlightElevation: 0,
                                    borderSide: BorderSide(color: Colors.grey),
                                    child: commentText(context,
                                        snapshot.data.documents[index]),
                                    onPressed: () => _addComment(
                                        snapshot
                                            .data.documents[index].documentID,
                                        userId),
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
              );
            },
          );
        },
      ),
    );
  }

  Widget _comments(announceId) {
    return Container(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('announceComment')
              .where('announceId', isEqualTo: announceId)
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: const Text('無留言'),
              );
            return snapshot.data.documents.length == 0
                ? Center(
                    child: const Text('無留言'),
                  )
                : new ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      new Icon(
                                        Icons.account_circle,
                                        size: 20,
                                      ),
                                      Text(
                                        snapshot.data.documents[index]
                                            ['postName'],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                snapshot.data.documents[index]['time'] != null
                                    ? Text(
                                        DateFormat("yyyy-MM-dd HH:mm").format(
                                            snapshot
                                                .data.documents[index]['time']
                                                .toDate()),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15),
                                      )
                                    : null,
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(snapshot.data.documents[index]['comment']),
                            Divider()
                          ],
                        ),
                      );
                    });
          }),
    );
  }

  final _commentFormKey = GlobalKey<FormState>();
  TextEditingController _commentController = new TextEditingController();

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  _addComment(announceId, userId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Form(
                  key: _commentFormKey,
                  child: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: _comments(announceId),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _commentController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: '留言',
                                ),
                                validator: (value) =>
                                    value.isEmpty ? '*無內容*' : null,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlatButton(
                                child: Text('送出'),
                                onPressed: () async {
                                  DateTime now = new DateTime.now();
                                  getNickName(userId).whenComplete(() async {
                                    if (_commentFormKey.currentState
                                        .validate()) {
                                      await Firestore.instance
                                          .collection('announceComment')
                                          .document()
                                          .setData({
                                        'announceId': announceId,
                                        'postId': userId,
                                        'postName': _userName,
                                        'comment': _commentController.text,
                                        'time': now,
                                      }).whenComplete(() {
                                        // Navigator.of(context).pop();
                                        _dismissKeyboard(context);
                                        _commentController.text = '';
                                      });
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )));
        });
  }
}
