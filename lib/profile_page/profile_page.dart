import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:ouch/root_page.dart';
import '../activity_detail.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.auth, this.onSignedOut, this.userId, this.userName});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String userName;
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(
        auth: auth,
        onSignedOut: onSignedOut,
        userId: userId,
        userName: userName);
  }
}

class ProfilePageState extends State<ProfilePage> {
  ProfilePageState({this.auth, this.onSignedOut, this.userId, this.userName});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String userName;
  String _userId;
  String _userName;
  List<String> markedIdList = [];
  bool open = false;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Widget _getName(BuildContext context, DocumentSnapshot document) {
    return Text(document['displayName'], style: TextStyle(fontSize: 20));
  }

  Widget realGetNickname(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('userid', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          // var userDocument = snapshot.data;
          return _getName(context, snapshot.data.documents[0]);
        });
  }

  void getMarked() async {
    markedIdList.clear();
    var markedQuery = Firestore.instance
        .collection('markedActivity')
        .where('userId', isEqualTo: userId);
    var markedQuerySnapshot = await markedQuery.getDocuments();
    if (markedQuerySnapshot.documents.length != 0) {
      for (var i = 0; i < markedQuerySnapshot.documents.length; i++) {
        setState(() {
          markedIdList.add(
              markedQuerySnapshot.documents[i].data['activityId'].toString());
        });
      }
    }
  }

  Widget joinCountText(BuildContext context, post) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('resJoin')
            .where('activityName', isEqualTo: post['title'])
            .where('status', isEqualTo: 'checked')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("0",
                style: TextStyle(
                  color: Colors.grey[300],
                ));
          } else if (snapshot.data.documents.length == 0 && snapshot.hasData) {
            return new Text("0",
                style: TextStyle(
                  color: Colors.grey[300],
                ));
          } else {
            return new Text(snapshot.data.documents.length.toString(),
                style: TextStyle(
                  color: Colors.grey[300],
                ));
          }
        });
  }

  @override
  void initState() {
    super.initState();
    getMarked();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(tabs: <Widget>[
            Tab(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(
                    Icons.bookmark,
                    color: Colors.black,
                  ),
                  new Text(
                    '我的追蹤',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            Tab(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(
                    Icons.perm_contact_calendar,
                    color: Colors.black,
                  ),
                  new Text(
                    '個人',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ]),
          body: TabBarView(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: markedIdList.length,
                    itemBuilder: (context, index) => StreamBuilder(
                        stream: Firestore.instance
                            .collection('activity')
                            .document(markedIdList[index])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: const Text('Loading...'),
                            );
                          return InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivityDetailPage(
                                          userId: userId,
                                          auth: auth,
                                          post: snapshot.data,
                                        ))),
                            child: Card(
                              color: Colors.indigo[50],
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 200,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: snapshot.data['image'],
                                          placeholder: (context, url) => Center(
                                              child: SizedBox(
                                            child: CircularProgressIndicator(),
                                            height: 20.0,
                                            width: 20.0,
                                          )),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                      Container(
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            gradient: LinearGradient(
                                                begin:
                                                    FractionalOffset.topCenter,
                                                end: FractionalOffset
                                                    .bottomCenter,
                                                colors: [
                                                  Colors.grey.withOpacity(0.0),
                                                  Colors.grey.withOpacity(0.0),
                                                  Colors.black87,
                                                ],
                                                stops: [
                                                  0.0,
                                                  0.4,
                                                  1.0
                                                ])),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 130,
                                          ),
                                          ListTile(
                                            title: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    snapshot.data['title'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                    child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.account_circle,
                                                      size: 20,
                                                      color: Colors.grey[300],
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data['creatorName'],
                                                      style: TextStyle(
                                                        color: Colors.grey[300],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      '參加人數： ',
                                                      style: TextStyle(
                                                        color: Colors.grey[300],
                                                      ),
                                                    ),
                                                    joinCountText(
                                                        context, snapshot.data),
                                                    Text(
                                                      '/ ' +
                                                          snapshot.data[
                                                              'people_limit'],
                                                      style: TextStyle(
                                                        color: Colors.grey[300],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                      title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // Text('活動資訊'),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.access_time, size: 17),
                                          Text(
                                            ' ' +
                                                DateFormat("yyyy-MM-dd hh:mm")
                                                    .format(snapshot
                                                        .data['start_time']
                                                        .toDate()),
                                            style: TextStyle(
                                                color: Colors.black87),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            size: 17,
                                          ),
                                          Text(
                                            ' ' +
                                                snapshot.data['localityArea'] +
                                                '' +
                                                snapshot.data['localityLocal'],
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          );
                        }))),
            new ListView.builder(
                itemCount: 1,
                itemBuilder: (context, rownumber) {
                  return new Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(30.0),
                        child: new Center(
                          child: new Column(
                            children: <Widget>[
                              new Icon(
                                Icons.account_circle,
                                size: 80.0,
                              ),
                              new Container(
                                width: 15.0,
                                height: 20,
                              ),
                              realGetNickname(context),
                            ],
                          ),
                        ),
                      ),
                      new FlatButton(
                        child: new Text('登出'),
                        splashColor: Colors.amber,
                        onPressed: () {
                          _signOut();
                          widget.auth.signOut();
                        },
                      ),
                    ],
                  );
                }),
          ]),
        ));
  }
}
