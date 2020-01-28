import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'buildactivity_detail.dart';
import '../auth.dart';
import '../build_page/build_page.dart';

class BuildCell extends StatefulWidget {
  BuildCell({Key key, this.auth, this.userId, this.userName}) : super(key: key);
  final BaseAuth auth;
  final String userId;
  final String userName;

  @override
  State<StatefulWidget> createState() {
    return BuildCellState(userId: userId, userName: userName);
  }
}

class BuildCellState extends State<BuildCell> {
  BuildCellState({this.userId, this.userName});
  final String userId;
  final String userName;

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BuildActivityDetailPage(
                userId: userId, post: post, userName: userName)));
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
  Widget build(BuildContext context) {
    return new Scaffold(
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('activity')
                .where('creator', isEqualTo: userId)
                .orderBy('start_time')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: const Text('Loading...'),
                );
              return Container(
                  child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) => ListTile(
                            onTap: () => navigateToDetail(
                                snapshot.data.documents[index]),
                            contentPadding: EdgeInsets.all(5),
                            title: Card(
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
                                          imageUrl: snapshot
                                              .data.documents[index]['image'],
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
                                                    snapshot.data
                                                            .documents[index]
                                                        ['title'],
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
                                                      snapshot.data
                                                              .documents[index]
                                                          ['creatorName'],
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
                                                        context,
                                                        snapshot.data
                                                            .documents[index]),
                                                    Text(
                                                      '/ ' +
                                                          snapshot.data
                                                                      .documents[
                                                                  index]
                                                              ['people_limit'],
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
                                        Text( ' '+
                                          DateFormat("yyyy-MM-dd hh:mm").format(
                                              snapshot
                                                  .data
                                                  .documents[index]
                                                      ['start_time']
                                                  .toDate()),
                                          style:
                                              TextStyle(color: Colors.black87),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.location_on, size: 17,),
                                        Text(' '+
                                          snapshot.data.documents[index]
                                            ['localityArea']+''+snapshot.data.documents[index]['localityLocal'],
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      ],
                                    )
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          )));
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('add');
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new BuildActivity(userId: userId),
                ));
          },
          icon: new Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: new Text('建立', maxLines: 1),
        ));
  }
}
