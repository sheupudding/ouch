import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/services.dart';
import '../auth.dart';
import '../build_page/build_interact_page.dart';
import 'registrtion_cell.dart';
import './build_bottom.dart';
import 'qr_generate.dart';
import 'analysis_page.dart';

bool joined = false;
int _joined = 0;
int _ticketCount = 1;

class BuildActivityDetailPage extends StatefulWidget {
  BuildActivityDetailPage(
      {Key key, this.auth, this.userId, this.post, this.userName})
      : super(key: key);
  final BaseAuth auth;
  final String userId;
  final DocumentSnapshot post;
  final String userName;
  @override
  State<StatefulWidget> createState() {
    return BuildActivityDetailPageState(
        userId: userId, auth: auth, post: post, userName: userName);
  }
}

class BuildActivityDetailPageState extends State<BuildActivityDetailPage> {
  BuildActivityDetailPageState(
      {Key key, this.auth, this.userId, this.post, this.userName});
  final BaseAuth auth;
  final String userId;
  final DocumentSnapshot post;
  final String userName;

  Future joinStatus(post, userId) async {
    var respectsQuery = Firestore.instance
        .collection('resJoin')
        .where('activityId', isEqualTo: post.documentID)
        .where('joinedId', isEqualTo: userId);
    var querySnapshot = await respectsQuery.getDocuments();
    var totalEquals = querySnapshot.documents.length;
    return totalEquals;
  }

  Future getTicket(post, userId) async {
    int count;
    var respectsQuery = Firestore.instance
        .collection('resForm')
        .where('activityId', isEqualTo: post.documentID);
    var querySnapshot = await respectsQuery.getDocuments();
    var totalEquals = querySnapshot.documents[0]['tickets'];
    if (totalEquals[0] == null) {
      setState(() {
        count = 1;
      });
    } else if (totalEquals[1] == null) {
      setState(() {
        count = 1;
      });
    } else if (totalEquals[2] == null) {
      setState(() {
        count = 2;
      });
    } else if (totalEquals[3] == null) {
      setState(() {
        count = 3;
      });
    } else if (totalEquals[4] == null) {
      setState(() {
        count = 4;
      });
    } else {
      setState(() {
        count = 5;
      });
    }
    return count;
  }

  Future setTapCount() async {
    var respectsQuery = await Firestore.instance
        .collection('activityTapCount')
        .where('activityId', isEqualTo: post.documentID)
        .where('date',
            isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
        .getDocuments();
    if (respectsQuery.documents.length == 0) {
      await Firestore.instance
          .collection('activityTapCount')
          .document()
          .setData({
        'activityId': post.documentID,
        'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
        'count': 0,
        'time': DateTime.now()
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setTapCount();
    joinStatus(post, userId).then((result) {
      setState(() {
        _joined = result;
      });
    });
    getTicket(post, userId).then((result) {
      setState(() {
        _ticketCount = result;
      });
    });
  }

  Widget joinStatusText(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('resJoin')
            .where('joinedId', isEqualTo: userId)
            .where('activityName', isEqualTo: post['title'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("未報名");
          } else if (snapshot.data.documents.length == 0 && snapshot.hasData) {
            print('沒報名！');
            return new Text("未報名");
          } else {
            print('有報名！');
            return Text('已報名');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: new Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: new Text('活動'),
              actions: <Widget>[
                new Padding(
                    padding: EdgeInsets.all(15),
                    child: post['creator'] == userId
                        ? new Container(
                            width: 70.0,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(16.0),
                              color: Colors.orange[300],
                            ),
                            child: Center(
                              child: new Text(
                                '你的活動',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : new Container(
                            width: 70.0,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(16.0),
                              color:
                                  _joined == 0 ? Colors.black12 : Colors.grey,
                            ),
                            child: Center(
                              child: joinStatusText(context),
                            ),
                          ))
              ]),
          body: TabBarView(
            children: [
              new ActivityBody(userId: userId, auth: auth, post: post),
              new AnalysisPage(post: post),
              new RegistrationCell(userId: userId, auth: auth, post: post),
              new QrShow(post: post),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: new BuildBottomPart(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              print('button click');
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) =>
                        new Interact(userId: userId, post: post),
                  ));
            },
            icon: new Icon(
              Icons.record_voice_over,
              color: Colors.white,
            ),
            label: new Text('互動', maxLines: 1),
          ),
        ));
  }
}

class ActivityBody extends StatefulWidget {
  ActivityBody({Key key, this.auth, this.userId, this.post});
  final BaseAuth auth;
  final String userId;
  final DocumentSnapshot post;

  @override
  State<StatefulWidget> createState() {
    return ActivityBodyState(userId: userId, auth: auth, post: post);
  }
}

class ActivityBodyState extends State<ActivityBody> {
  ActivityBodyState({Key key, this.auth, this.userId, this.post});
  final BaseAuth auth;
  final String userId;
  final DocumentSnapshot post;
  final Set<Marker> _markers = {};
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    setState(() {
      mapController = controller;
    });
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
            return new Text("0");
          } else if (snapshot.data.documents.length == 0 && snapshot.hasData) {
            return new Text("0");
          } else {
            return new Text(snapshot.data.documents.length.toString());
          }
        });
  }

  Widget actvityCode(BuildContext context, post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.code,
              size: 17,
              color: Colors.blueGrey,
            ),
            new Text(
              ' 活動代碼',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text(post.documentID),
            IconButton(
              icon: Icon(
                Icons.content_copy,
                size: 20,
              ),
              onPressed: () {
                Clipboard.setData(new ClipboardData(text: post.documentID));
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('已複製活動代碼')));
              },
            )
          ],
        ),
        Divider(),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Event event = Event(
      title: post['title'],
      description: post['introduction'] == null ? '' : post['introduction'],
      location: post['address'],
      startDate: post['start_time'].toDate(),
      endDate: post['end_time'].toDate(),
    );
    return new Container(
      child: new ListView.builder(
        itemCount: 1,
        itemBuilder: (context, rownumber) {
          return new Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: new Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 200,
                  child: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: post['image'],
                    placeholder: (context, url) => Center(
                        child: SizedBox(
                      child: CircularProgressIndicator(),
                      height: 20.0,
                      width: 20.0,
                    )),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                new Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Text(
                          post['title'],
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                List.generate(post['tags'].length, (index) {
                              return Row(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.all(3),
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          new BorderRadius.circular(16.0),
                                      color: Colors.grey,
                                    ),
                                    child: Center(
                                      child: Text(
                                        post['tags'][index],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  )
                                ],
                              );
                            }))
                      ],
                    )),
                new Container(
                  child: new Column(children: <Widget>[
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: new FlatButton(
                                child: new Row(
                                  children: <Widget>[
                                    new Icon(
                                      Icons.account_circle,
                                    ),
                                    new Text(
                                      post['creatorName'],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Row(
                                children: <Widget>[
                                  Text('參加人數： '),
                                  joinCountText(context, post),
                                  Text('/ ' + post['people_limit'])
                                ],
                              ),
                            ),
                          ],
                        ),
                        new Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // new Divider(),
                              new Text(post['introduction'] == null
                                  ? ''
                                  : post['introduction']),
                              new Divider(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                child:  Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.access_time,
                                                size: 17,
                                                color: Colors.blueGrey,
                                              ),
                                              new Text(
                                                ' 時間',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blueGrey),
                                              )
                                            ],
                                          ),
                                          new Text('由 ' +
                                              DateFormat("yyyy-MM-dd HH:mm")
                                                  .format(post['start_time']
                                                      .toDate())),
                                          new Text('至 ' +
                                              DateFormat("yyyy-MM-dd HH:mm")
                                                  .format(post['end_time']
                                                      .toDate())),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.today,size: 35,color: Colors.blueGrey,),
                                          onPressed: () {
                                            Add2Calendar.addEvent2Cal(event);
                                          },
                                        ),
                                        Text('加入行事曆',style: TextStyle(color: Colors.blueGrey),),
                                        SizedBox(height: 5,)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              new Divider(),
                              SizedBox(
                                height: 10,
                              ),
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 17,
                                          color: Colors.blueGrey,
                                        ),
                                        new Text(
                                          ' 地點',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueGrey),
                                        )
                                      ],
                                    ),
                                    new Text(post['address'] +
                                        ' -- ' +
                                        post['address_comment']),
                                    new Container(
                                        height: 200,
                                        child: Stack(
                                          children: <Widget>[
                                            Card(
                                              child: GoogleMap(
                                                // mapType: MapType.satellite,
                                                rotateGesturesEnabled: true,
                                                onMapCreated: _onMapCreated,
                                                markers: {
                                                  Marker(
                                                    markerId: MarkerId(
                                                        _markers.toString()),
                                                    position: LatLng(
                                                        post['latitude'],
                                                        post['longtitude']),
                                                    infoWindow: InfoWindow(
                                                      title: post['address'],
                                                    ),
                                                  )
                                                },
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: LatLng(
                                                      post['latitude'],
                                                      post['longtitude']),
                                                  zoom: 16.0,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 10,
                                              left: 10,
                                              child: Card(
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        new Icon(
                                                          Icons.error,
                                                          color: Colors.blue,
                                                        ),
                                                        new Text('  點擊地圖上的地標↑'),
                                                      ],
                                                    ),
                                                    new Text(
                                                        ' 右下角可產生Google Maps連結 '),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              new Divider(),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.local_activity,
                                    size: 17,
                                    color: Colors.blueGrey,
                                  ),
                                  new Text(
                                    ' 票券',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blueGrey),
                                  )
                                ],
                              ),
                              Container(
                                  height: 25.0 * _ticketCount,
                                  child: _showForm()),
                              post['line_pay'] != ''
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                        ),
                                        new Divider(),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.payment,
                                              size: 17,
                                              color: Colors.blueGrey,
                                            ),
                                            new Text(
                                              ' Line 轉帳代碼',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blueGrey),
                                            )
                                          ],
                                        ),
                                        Text(post['line_pay']),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Divider()
                                      ],
                                    )
                                  : SizedBox(),
                              actvityCode(context, post),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _showForm() {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('resForm')
            .where('activityId', isEqualTo: post.documentID)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.data.documents[0]['tickets'][0] == null
              ? Text('無票券')
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents[0]['tickets'].length,
                  itemBuilder: (context, index) =>
                      snapshot.data.documents[0]['tickets'][index] == null
                          ? null
                          : Row(
                              children: <Widget>[
                                Text(
                                  '●',
                                  style: TextStyle(fontSize: 5),
                                ),
                                Text('    ' +
                                    snapshot.data.documents[0]['tickets'][index]
                                        ['title']),
                                snapshot.data.documents[0]['tickets'][index]
                                            ['price'] ==
                                        '0'
                                    ? Text(
                                        '    免費',
                                        style: TextStyle(color: Colors.blue),
                                      )
                                    : Text(
                                        '    \$' +
                                            snapshot.data.documents[0]
                                                ['tickets'][index]['price'],
                                        style: TextStyle(color: Colors.blue),
                                      ),
                              ],
                            ));
        });
  }
}
