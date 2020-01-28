import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SharePage extends StatefulWidget {
  SharePage({Key key, this.userId, this.post}) : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _SharePageState createState() => _SharePageState(userId: userId, post: post);
}

class _SharePageState extends State<SharePage> {
  _SharePageState({Key key, this.userId, this.post});
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

  Widget commentText(BuildContext context, share) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('shareComment')
            .where('shareId', isEqualTo: share.documentID)
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(physics: NeverScrollableScrollPhysics(), children: <
              Widget>[
            StreamBuilder(
              stream: Firestore.instance
                  .collection('share')
                  .where('activityId', isEqualTo: post.documentID)
                  .where('type', isEqualTo: '公開')
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
                                    child: new Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: new Text(
                                              snapshot.data.documents[index]
                                                  ['title'],
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                        ),
                                        new Text(
                                          snapshot.data.documents[index]
                                              ['type'],
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.account_circle,
                                              size: 20,
                                            ),
                                            new Text(snapshot.data
                                                .documents[index]['postName'])
                                          ],
                                        ),
                                      ),
                                      Text(
                                        DateFormat("yyyy-MM-dd HH:mm").format(
                                            snapshot
                                                .data.documents[index]['time']
                                                .toDate()),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                  new Container(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(snapshot.data
                                              .documents[index]['content']),
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
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          child: commentText(context,
                                            snapshot.data.documents[index]),
                                          onPressed: () => _addComment(
                                              snapshot.data.documents[index]
                                                  .documentID,
                                              userId),
                                        ),
                                      ),
                                      // Positioned(
                                      //   bottom: 10,
                                      //   right: 10,
                                      //   child: commentText(context,
                                      //       snapshot.data.documents[index]),
                                      // )
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
            StreamBuilder(
              stream: Firestore.instance
                  .collection('share')
                  .where('activityId', isEqualTo: post.documentID)
                  .where('postId', isEqualTo: userId)
                  .where('type', isEqualTo: '私人')
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
                                    child: new Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: new Text(
                                              snapshot.data.documents[index]
                                                  ['title'],
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                        ),
                                        new Text(
                                          snapshot.data.documents[index]
                                              ['type'],
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.account_circle,
                                              size: 20,
                                            ),
                                            new Text(snapshot.data
                                                .documents[index]['postName'])
                                          ],
                                        ),
                                      ),
                                      Text(
                                        DateFormat("yyyy-MM-dd HH:mm").format(
                                            snapshot
                                                .data.documents[index]['time']
                                                .toDate()),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                  new Container(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(snapshot.data
                                              .documents[index]['content']),
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
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          child: commentText(context,
                                            snapshot.data.documents[index]),
                                          onPressed: () => _addComment(
                                              snapshot.data.documents[index]
                                                  .documentID,
                                              userId),
                                        ),
                                      ),
                                      // Positioned(
                                      //   bottom: 10,
                                      //   right: 10,
                                      //   child: commentText(context,
                                      //       snapshot.data.documents[index]),
                                      // )
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
          ]),
          bottomNavigationBar: BottomAppBar(
            child: new TabBar(
              labelStyle: TextStyle(
                fontSize: 15.0,
              ),
              tabs: <Widget>[
                Tab(
                  child: new Text(
                    '公開',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
                Tab(
                  child:
                      new Text('私人', style: TextStyle(color: Colors.blueGrey)),
                ),
              ],
              indicatorWeight: 4,
              indicatorColor: Colors.blueGrey[200],
              unselectedLabelColor: Colors.blueGrey[200],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _buildShare(),
            icon: new Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: new Text('發佈', maxLines: 1),
          ),
        ));
  }

  Widget _comments(shareId) {
    return Container(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('shareComment')
              .where('shareId', isEqualTo: shareId)
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
                                  child: snapshot.data.documents[index]
                                              ['postId'] ==
                                          post.data['creator']
                                      ? Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.account_circle,
                                              size: 20,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              snapshot.data.documents[index]
                                                  ['postName'],
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.account_circle,
                                              size: 20,
                                              color: Colors.black54,
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

  _addComment(shareId, userId) {
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
                          child: _comments(shareId),
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
                                          .collection('shareComment')
                                          .document()
                                          .setData({
                                        'shareId': shareId,
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

  String _selected = '公開';
  void onChanged(value) {
    setState(() {
      _selected = value;
    });
    print('Value = $value');
  }

  _buildShare() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(
              onValueChange: onChanged,
              initialValue: _selected,
              post: post,
              userId: userId,
              userName: _userName);
        });
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog(
      {this.onValueChange,
      this.initialValue,
      this.post,
      this.userId,
      this.userName});

  final String initialValue;
  final void Function(String) onValueChange;
  final DocumentSnapshot post;
  final String userId;
  final String userName;

  @override
  State createState() =>
      new MyDialogState(post: post, userId: userId, userName: userName);
}

class MyDialogState extends State<MyDialog> {
  MyDialogState({this.post, this.userId, this.userName});
  String _selectedId;
  final DocumentSnapshot post;
  final String userId;
  final String userName;
  String _userName;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

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

  Widget build(BuildContext context) {
    return new AlertDialog(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text("發佈文章"),
          ),
          DropdownButton<String>(
            value: _selectedId,
            onChanged: (String value) {
              setState(() {
                _selectedId = value;
              });
              widget.onValueChange(value);
            },
            items: <String>['公開', '私人'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Container(
          height: 200,
          child: Column(
            children: <Widget>[
              TextFormField(
                maxLines: 1,
                controller: _titleController,
                style: TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                  labelText: '文章名稱',
                ),
                validator: (value) => value.isEmpty ? '*文章名稱必填*' : null,
              ),
              SizedBox(height: 20),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: '文章內容',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Color.fromRGBO(58, 66, 86, 1.0)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) => value.isEmpty ? '*文章內容必填*' : null,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("發佈"),
          onPressed: () async {
            DateTime now = new DateTime.now();
            getNickName(userId).whenComplete(() async {
              if (_formKey.currentState.validate()) {
                await Firestore.instance
                    .collection('share')
                    .document()
                    .setData({
                  'activityId': post.documentID,
                  'title': _titleController.text,
                  'content': _contentController.text,
                  'postId': userId,
                  'postName': _userName,
                  'type': _selectedId,
                  'time': now
                }).whenComplete(() {
                  Navigator.of(context).pop();
                });
              }
            });
          },
        ),
        FlatButton(
          child: Text("取消"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
