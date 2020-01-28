import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth.dart';

class RegistrationCell extends StatefulWidget {
  RegistrationCell({Key key, this.auth, this.userId, this.post})
      : super(key: key);
  final BaseAuth auth;
  final String userId;
  final DocumentSnapshot post;

  @override
  State<StatefulWidget> createState() {
    return RegistrationCellState(userId: userId, post: post);
  }
}

class RegistrationCellState extends State<RegistrationCell> {
  RegistrationCellState({this.userId, this.post});
  final String userId;
  final DocumentSnapshot post;

  // navigateToDetail(DocumentSnapshot join){
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => BuildActivityDetailPage(
  //     userId: userId, join: join,)));
  // }

  _showUncheckedDetail(post, join, ticket) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('報名資料'),
            content: Container(
                height: 300,
                width: MediaQuery.of(context).size.width * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          '表單',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      join[0] != null
                          ? Row(
                              children: <Widget>[
                                Text(join[0]['title'] + ' ： '),
                                Text(join[0]['value'])
                              ],
                            )
                          : SizedBox(),
                      join[1] != null
                          ? Row(
                              children: <Widget>[
                                Text(join[1]['title'] + ' ： '),
                                Text(join[1]['value'])
                              ],
                            )
                          : SizedBox(),
                      join[2] != null
                          ? Row(
                              children: <Widget>[
                                Text(join[2]['title'] + ' ： '),
                                Text(join[2]['value'])
                              ],
                            )
                          : SizedBox(),
                      join[3] != null
                          ? Row(
                              children: <Widget>[
                                Text(join[3]['title'] + ' ： '),
                                Text(join[3]['value'])
                              ],
                            )
                          : SizedBox(),
                      join[4] != null
                          ? Row(
                              children: <Widget>[
                                Text(join[4]['title'] + ' ： '),
                                Text(join[4]['value'])
                              ],
                            )
                          : SizedBox(),
                      join[5] != null
                          ? Row(
                              children: <Widget>[
                                Text(join[5]['title'] + ' ： '),
                                Text(join[5]['value'])
                              ],
                            )
                          : SizedBox(),
                      join[6] != null
                          ? Row(
                              children: <Widget>[
                                Text(join[6]['title'] + ' ： '),
                                Text(join[6]['value'])
                              ],
                            )
                          : SizedBox(),
                      join[7] != null
                          ? Row(
                              children: <Widget>[
                                Text(join[7]['title'] + ' ： '),
                                Text(join[7]['value'])
                              ],
                            )
                          : SizedBox(),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          '票券',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ticket != null
                          ? Row(
                              children: <Widget>[
                                Text(ticket['title'] + ' ： '),
                                Text(ticket['price'])
                              ],
                            )
                          : Text('無票券'),
                    ],
                  ),
                )),
            actions: <Widget>[
              FlatButton(
                child: Text("不通過"),
                onPressed: () async {
                  await Firestore.instance
                      .collection('resJoin')
                      .document(post.documentID)
                      .updateData({
                    'status': 'checkFailed',
                  });
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("通過"),
                onPressed: () async {
                  await Firestore.instance
                      .collection('resJoin')
                      .document(post.documentID)
                      .updateData({
                    'status': 'checked',
                    'paid': ticket != null ? false : null,
                  });
                  Navigator.of(context).pop();
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
        });
  }

  _showcheckedDetail(post, join, ticket) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('報名資料'),
              content: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            '表單',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        join[0] != null
                            ? Row(
                                children: <Widget>[
                                  Text(join[0]['title'] + ' ： '),
                                  Text(join[0]['value'])
                                ],
                              )
                            : SizedBox(),
                        join[1] != null
                            ? Row(
                                children: <Widget>[
                                  Text(join[1]['title'] + ' ： '),
                                  Text(join[1]['value'])
                                ],
                              )
                            : SizedBox(),
                        join[2] != null
                            ? Row(
                                children: <Widget>[
                                  Text(join[2]['title'] + ' ： '),
                                  Text(join[2]['value'])
                                ],
                              )
                            : SizedBox(),
                        join[3] != null
                            ? Row(
                                children: <Widget>[
                                  Text(join[3]['title'] + ' ： '),
                                  Text(join[3]['value'])
                                ],
                              )
                            : SizedBox(),
                        join[4] != null
                            ? Row(
                                children: <Widget>[
                                  Text(join[4]['title'] + ' ： '),
                                  Text(join[4]['value'])
                                ],
                              )
                            : SizedBox(),
                        join[5] != null
                            ? Row(
                                children: <Widget>[
                                  Text(join[5]['title'] + ' ： '),
                                  Text(join[5]['value'])
                                ],
                              )
                            : SizedBox(),
                        join[6] != null
                            ? Row(
                                children: <Widget>[
                                  Text(join[6]['title'] + ' ： '),
                                  Text(join[6]['value'])
                                ],
                              )
                            : SizedBox(),
                        join[7] != null
                            ? Row(
                                children: <Widget>[
                                  Text(join[7]['title'] + ' ： '),
                                  Text(join[7]['value'])
                                ],
                              )
                            : SizedBox(),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            '票券',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ticket != null
                            ? Row(
                                children: <Widget>[
                                  Text(ticket['title'] + ' ： '),
                                  Text(ticket['price'])
                                ],
                              )
                            : Text('無票券'),
                      ],
                    ),
                  )),
              actions: ticket != null
                  ? <Widget>[
                      paid(context, post),
                      FlatButton(
                        child: Text("取消"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]
                  : <Widget>[
                      FlatButton(
                        child: Text("確認"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]);
        });
  }

  Widget paid(BuildContext context, post) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('resJoin')
            .document(post.documentID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text(
              "",
              style: TextStyle(color: Colors.white),
            );
          } else {
            return snapshot.data['paid'] == false
                ? FlatButton(
                    child: Text("更改成已繳費"),
                    onPressed: () async {
                      await Firestore.instance
                          .collection('resJoin')
                          .document(post.documentID)
                          .updateData({
                        'paid': true,
                      });
                      Navigator.of(context).pop();
                    },
                  )
                : Text('此人已繳費');
          }
        });
  }

  Widget paidStatus(BuildContext context, post) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('resJoin')
            .document(post.documentID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text(
              "",
              style: TextStyle(color: Colors.white),
            );
          } else {
            return snapshot.data['paid'] == null
                ? Text('')
                : snapshot.data['paid'] == false
                    ? Text(
                        '未繳費',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Text(
                        '已繳費',
                        style: TextStyle(color: Colors.grey),
                      );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: new TabBar(
              labelStyle: TextStyle(
                fontSize: 15.0,
              ),
              tabs: <Widget>[
                Tab(
                  child: new Text(
                    '未審核',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child:
                      new Text('已通過', style: TextStyle(color: Colors.black)),
                ),
              ],
              indicatorWeight: 4,
              indicatorColor: Colors.grey,
            ),
          ),
          body: TabBarView(
            // physics: NeverScrollableScrollPhysics(), 
            children: <
              Widget>[
            StreamBuilder(
                stream: Firestore.instance
                    .collection('resJoin')
                    .where('activityId', isEqualTo: post.documentID)
                    .where('status', isEqualTo: 'unchecked')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: const Text('Loading...'),
                    );
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // onTap: () => navigateToDetail(snapshot.data.documents[index]),
                          onTap: () {
                            print('有點到！');
                            _showUncheckedDetail(
                                snapshot.data.documents[index],
                                snapshot.data.documents[index]['form'],
                                snapshot.data.documents[index]['ticket']);
                          },
                          contentPadding: EdgeInsets.all(5),
                          title: Card(
                            color: Colors.indigo[50],
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      snapshot.data.documents[index]['form'][0]
                                          ['value'],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  subtitle: snapshot.data.documents[index]
                                              ['ticket'] !=
                                          null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                // Icon(
                                                //   Icons.account_circle,
                                                //   size: 20,
                                                //   color: Colors.grey,
                                                // ),
                                                Text(snapshot.data
                                                            .documents[index]
                                                        ['ticket']['title'] +
                                                    '  \$' +
                                                    snapshot.data
                                                            .documents[index]
                                                        ['ticket']['price']),
                                                // _showDetail(
                                                //     snapshot.data.documents[index]['form'],
                                                //     _tapped),
                                              ],
                                            )),
                                          ],
                                        )
                                      : SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('resJoin')
                    .where('activityId', isEqualTo: post.documentID)
                    .where('status', isEqualTo: 'checked')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: const Text('Loading...'),
                    );
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // onTap: () => navigateToDetail(snapshot.data.documents[index]),
                          onTap: () {
                            print('有點到！');
                            _showcheckedDetail(
                                snapshot.data.documents[index],
                                snapshot.data.documents[index]['form'],
                                snapshot.data.documents[index]['ticket']);
                          },
                          contentPadding: EdgeInsets.all(5),
                          title: Card(
                            color: Colors.indigo[50],
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            snapshot.data.documents[index]
                                                ['form'][0]['value'],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      paidStatus(context,
                                          snapshot.data.documents[index])
                                    ],
                                  ),
                                  subtitle: snapshot.data.documents[index]
                                              ['ticket'] !=
                                          null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                // Icon(
                                                //   Icons.account_circle,
                                                //   size: 20,
                                                //   color: Colors.grey,
                                                // ),
                                                Text(snapshot.data
                                                            .documents[index]
                                                        ['ticket']['title'] +
                                                    '  \$' +
                                                    snapshot.data
                                                            .documents[index]
                                                        ['ticket']['price']),
                                                // _showDetail(
                                                //     snapshot.data.documents[index]['form'],
                                                //     _tapped),
                                              ],
                                            )),
                                            checkedStatus(context,
                                                snapshot.data.documents[index]),
                                          ],
                                        )
                                      : Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(),
                                            ),
                                            checkedStatus(context,
                                                snapshot.data.documents[index])
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
          ]),
        ));
  }

  Widget checkedStatus(BuildContext context, post) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('joinChecked')
            .where('joinedActivityId', isEqualTo: post['activityId'])
            .where('joinedId', isEqualTo: post['joinedId'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text(
              "123",
              style: TextStyle(color: Colors.white),
            );
          } else if (snapshot.data.documents.length == 0 && snapshot.hasData) {
            return new Text("未報到",
                style: TextStyle(
                  color: Colors.grey,
                ));
          } else {
            return new Text('已報到',
                style: TextStyle(
                  color: Colors.blue,
                ));
          }
        });
  }
}
