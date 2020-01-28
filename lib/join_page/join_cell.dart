import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'joinactivity_detail.dart';
import '../auth.dart';

List joinedActivityId = [];

class JoinCell extends StatefulWidget {
  JoinCell({Key key, this.auth, this.userId}) : super(key: key);
  final BaseAuth auth;
  final String userId;

  @override
  State<StatefulWidget> createState() {
    return JoinCellState(userId: userId);
  }
}

class JoinCellState extends State<JoinCell> {
  JoinCellState({this.userId});
  final String userId;

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                JoinActivityDetailPage(userId: userId, post: post)));
  }

  void getJoined(userId) {
    Firestore.instance
        .collection('resJoin')
        .where('joinedId', isEqualTo: userId)
        .getDocuments()
        .then((doc) {
      if (doc == null) {
        print('沒資料');
      }
      joinedActivityId.clear();
      if (doc.documents.length != 0) {
        print(doc.documents[0]['activityName']);
        setState(() {
          for (int i = 0; i < doc.documents.length; i++)
            joinedActivityId.add(doc.documents[i]['activityId']);
        });
      }
      print(doc.documents.length);
      print(joinedActivityId);
    });
  }

  @override
  void initState() {
    super.initState();
    this.getJoined(userId);
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

  Widget joinStatusText(BuildContext context, post) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('resJoin')
            .where('joinedId', isEqualTo: userId)
            .where('activityName', isEqualTo: post['title'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text(
              "",
              style: TextStyle(color: Colors.white),
            );
          } else if (snapshot.data.documents.length == 0 && snapshot.hasData) {
            return new Text(
              "",
              style: TextStyle(color: Colors.white),
            );
          } else {
            return snapshot.data.documents[0]['status'] == 'checked'
                ? snapshot.data.documents[0]['paid'] == false
                    ? new Text(
                        "已報名 / 未繳費",
                        style: TextStyle(color: Colors.yellow),
                      )
                    : snapshot.data.documents[0]['paid'] == true
                        ? new Text(
                            "已報名 / 已繳費",
                            style: TextStyle(color: Colors.yellow),
                          )
                        : new Text(
                            "已報名",
                            style: TextStyle(color: Colors.yellow),
                          )
                : snapshot.data.documents[0]['status'] == 'unchecked'
                    ? new Text("尚未審核", style: TextStyle(color: Colors.yellow))
                    : new Text("審核不通過", style: TextStyle(color: Colors.yellow));
          }
        });
  }

  Widget showJoinedCell(id) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection('activity').document(id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: const Text('Loading...'),
            );
          return InkWell(
            onTap: () async {
              navigateToDetail(snapshot.data);
              var postQuery = await Firestore.instance
                  .collection('activityTapCount')
                  .where('activityId', isEqualTo: id)
                  .where('date',
            isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
                  .getDocuments();
              if (postQuery.documents.length == 0) {
                await Firestore.instance
                    .collection('activityTapCount')
                    .document()
                    .setData({
                  'activityId': id,
                  'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  'count': 1,
                  'time': DateTime.now()
                });
              } else {
                var post = postQuery.documents[0];
                await Firestore.instance
                    .collection('activityTapCount')
                    .document(post.documentID)
                    .updateData({'count': post['count'] + 1});
              }
            },
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
                          fit: BoxFit.fitWidth,
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
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
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
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                new Container(
                                  child: joinStatusText(context, snapshot.data),
                                )
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                      snapshot.data['creatorName'],
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
                                    joinCountText(context, snapshot.data),
                                    Text(
                                      '/ ' + snapshot.data['people_limit'],
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text('活動資訊'),
                      Row(
                        children: <Widget>[
                          Icon(Icons.access_time, size: 17),
                          Text(
                            ' ' +
                                DateFormat("yyyy-MM-dd hh:mm").format(
                                    snapshot.data['start_time'].toDate()),
                            style: TextStyle(color: Colors.black87),
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
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      )
                    ],
                  )),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      child: new ListView(
        children: new List.generate(
            joinedActivityId.length,
            (index) => new ListTile(
                  contentPadding: EdgeInsets.all(5),
                  title: showJoinedCell(joinedActivityId[index]),
                )),
      ),
    ));
  }
}
