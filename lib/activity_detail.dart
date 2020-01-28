import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'auth.dart';

bool joined = false;
int _joined = 0;
int _ticketCount = 1;
String marked = '';

class ActivityDetailPage extends StatefulWidget {
  ActivityDetailPage({Key key, this.auth, this.userId, this.post})
      : super(key: key);
  final BaseAuth auth;
  final String userId;
  final DocumentSnapshot post;
  @override
  State<StatefulWidget> createState() {
    return ActivityDetailPageState(userId: userId, auth: auth, post: post);
  }
}

class ActivityDetailPageState extends State<ActivityDetailPage> {
  ActivityDetailPageState({Key key, this.auth, this.userId, this.post});
  final BaseAuth auth;
  final String userId;
  final DocumentSnapshot post;

  Future joinStatus(post, userId) async {
    var respectsQuery = Firestore.instance
        .collection('resJoin')
        .where('activityId', isEqualTo: post.documentID)
        .where('joinedId', isEqualTo: userId);
    var querySnapshot = await respectsQuery.getDocuments();
    var totalEquals = querySnapshot.documents.length;
    return totalEquals;
  }

  @override
  void initState() {
    super.initState();
    joinStatus(post, userId).then((result) {
      setState(() {
        _joined = result;
      });
    });
    checkFormData(context, post);
  }

  Future checkFormData(BuildContext context, post) async {
    var formQuery = Firestore.instance
        .collection('resForm')
        .where('activityId', isEqualTo: post.documentID);
    var querySnapshot = await formQuery.getDocuments();
    setState(() {
      if (querySnapshot.documents[0].data['tickets'][0] == null) {
        setState(() {
          _ticketCount = 0;
        });
      } else if (querySnapshot.documents[0].data['tickets'][1] == null) {
        setState(() {
          _ticketCount = 1;
        });
      } else if (querySnapshot.documents[0].data['tickets'][2] == null) {
        setState(() {
          _ticketCount = 2;
        });
      } else if (querySnapshot.documents[0].data['tickets'][3] == null) {
        setState(() {
          _ticketCount = 3;
        });
      } else if (querySnapshot.documents[0].data['tickets'][4] == null) {
        setState(() {
          _ticketCount = 4;
        });
      } else {
        setState(() {
          _ticketCount = 5;
        });
      }
    });
    // return querySnapshot.documents.toString();
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
    return new Scaffold(
        appBar:
            AppBar(centerTitle: true, title: new Text('活動'), actions: <Widget>[
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
                        color: _joined == 0 ? Colors.black12 : Colors.grey,
                      ),
                      child: Center(
                        child: joinStatusText(context),
                      ),
                    ))
        ]),
        body: new ActivityBody(userId: userId, auth: auth, post: post));
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

  Widget markedStatus(BuildContext context, post) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('markedActivity')
            .where('activityId', isEqualTo: post.documentID)
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return IconButton(
                icon: Icon(
                  Icons.bookmark_border,
                  color: Colors.yellow,
                  size: 30,
                ),
                onPressed: () {});
          } else if (snapshot.data.documents.length == 0 && snapshot.hasData) {
            return IconButton(
                icon: Icon(
                  Icons.bookmark_border,
                  color: Colors.yellow,
                  size: 30,
                ),
                onPressed: () async {
                  await Firestore.instance
                      .collection('markedActivity')
                      .document()
                      .setData({
                    'activityId': post.documentID,
                    'userId': userId
                  }).whenComplete(() {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('已追蹤此活動')));
                  });
                });
          } else {
            return IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: Colors.yellow,
                  size: 30,
                ),
                onPressed: () async {
                  await Firestore.instance
                      .collection('markedActivity')
                      .document(snapshot.data.documents[0].documentID)
                      .delete()
                      .whenComplete(() {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('取消追蹤')));
                  });
                });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListView.builder(
        itemCount: 1,
        itemBuilder: (context, rownumber) {
          return new Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: new Column(
              children: <Widget>[
                Stack(
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
                    Container(
                      width: double.infinity,
                      height: 200.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                              begin: FractionalOffset.topRight,
                              end: FractionalOffset.bottomLeft,
                              colors: [
                                Colors.black87,
                                Colors.grey.withOpacity(0.0),
                                Colors.grey.withOpacity(0.0),
                              ],
                              stops: [
                                0.0,
                                0.2,
                                1.0
                              ])),
                    ),
                    Positioned(
                        top: 5, right: 5, child: markedStatus(context, post))
                  ],
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
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        DateFormat("yyyy-MM-dd HH:mm").format(
                                            post['start_time'].toDate())),
                                    new Text('至 ' +
                                        DateFormat("yyyy-MM-dd HH:mm")
                                            .format(post['end_time'].toDate())),
                                    new Divider(),
                                  ],
                                ),
                              ),
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
                                height: _ticketCount == 0
                                    ? 25.0
                                    : 25.0 * _ticketCount,
                                child: _showForm() == null
                                    ? Text('無票券')
                                    : _showForm(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    new Container(
                        child: post['creator'] == userId
                            ? SizedBox(
                                height: 0,
                              )
                            : _joined != 0
                                ? SizedBox(
                                    height: 0,
                                  )
                                : new Column(
                                    children: <Widget>[
                                      new ResExpanded(
                                          post: post,
                                          userId: userId,
                                          auth: auth),
                                      // new NestedScrollViewDemo(),
                                    ],
                                  )),
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

class ResExpanded extends StatefulWidget {
  ResExpanded({Key key, this.userId, this.post, this.auth});
  final BaseAuth auth;
  final String userId;
  final DocumentSnapshot post;
  @override
  _ResExpandedState createState() =>
      new _ResExpandedState(post: post, userId: userId, auth: auth);
}

class _ResExpandedState extends State<ResExpanded> {
  _ResExpandedState({Key key, this.userId, this.post, this.auth});
  final BaseAuth auth;
  final String userId;
  final DocumentSnapshot post;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController firstForm = new TextEditingController();
  TextEditingController secondForm = new TextEditingController();
  TextEditingController thirdForm = new TextEditingController();
  TextEditingController fourthForm = new TextEditingController();
  TextEditingController fifthForm = new TextEditingController();
  TextEditingController sixthForm = new TextEditingController();
  TextEditingController seventhForm = new TextEditingController();
  bool _open = false;
  double _bodyHeight = 50.0;
  double _finalHeight = 50.0;
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(10),
      child: new SingleChildScrollView(
        child: new Card(
          child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new FlatButton(
                  color: Colors.grey[200],
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          child: new Text('報名'),
                        ),
                        new Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_open) {
                        this._bodyHeight = 50.0;
                        _open = false;
                      } else {
                        this._bodyHeight = _finalHeight;
                        _open = true;
                      }
                    });
                  },
                ),
                // checkData(context, post),
                Expanded(
                  child: registrationForm(context, post),
                ),
                new Center(
                  child: new FlatButton(
                    child: new Container(
                      width: 70.0,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(16.0),
                        color: Colors.blueAccent,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Icon(
                            Icons.local_activity,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          new Text(
                            '報名',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await Firestore.instance
                            .collection('resJoin')
                            .document()
                            .setData({
                          'activityId': '${post.documentID}',
                          'joinedId': '$userId',
                          'activityName': post['title'],
                          'form': [
                            {'title': '姓名', 'value': _name.text},
                            _form.length >= 1
                                ? {
                                    'title': _form[0].toString(),
                                    'value': firstForm.text
                                  }
                                : null,
                            _form.length >= 2
                                ? {
                                    'title': _form[1].toString(),
                                    'value': secondForm.text
                                  }
                                : null,
                            _form.length >= 3
                                ? {
                                    'title': _form[2].toString(),
                                    'value': thirdForm.text
                                  }
                                : null,
                            _form.length >= 4
                                ? {
                                    'title': _form[3].toString(),
                                    'value': fourthForm.text
                                  }
                                : null,
                            _form.length >= 5
                                ? {
                                    'title': _form[4].toString(),
                                    'value': fifthForm.text
                                  }
                                : null,
                            _form.length >= 6
                                ? {
                                    'title': _form[5].toString(),
                                    'value': sixthForm.text
                                  }
                                : null,
                            _form.length >= 7
                                ? {
                                    'title': _form[6].toString(),
                                    'value': seventhForm.text
                                  }
                                : null,
                          ],
                          'ticket': _selected,
                          'status': 'unchecked'
                        }).whenComplete(() {
                          Navigator.pop(context);
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text('報名完成')));
                        });
                        var markedQuery = Firestore.instance
                            .collection('markedActivity')
                            .where('activityId', isEqualTo: post.documentID)
                            .where('userId', isEqualTo: userId);
                        var markedQuerySnapshot =
                            await markedQuery.getDocuments();
                        if (markedQuerySnapshot.documents.length != 0) {
                          await Firestore.instance
                              .collection('markedActivity')
                              .document(
                                  markedQuerySnapshot.documents[0].documentID)
                              .delete();
                        }
                        print(_name.text);
                      } else {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('欄位未完成')));
                      }
                    },
                  ),
                ),
              ],
            ),
            height: _bodyHeight,
          ),
        ),
      ),
    );
  }

  Widget registrationForm(context, post) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text('請填寫報名表'),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _name,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        labelText: '姓名',
                      ),
                      validator: (value) => value.isEmpty ? '*必填*' : null,
                    ),
                    resForm(context, post),
                    SizedBox(
                      height: 20,
                    ),
                    _ticketForm[0] == null
                        ? SizedBox()
                        : Column(
                            children: <Widget>[
                              Text('請選擇票券'),
                              SizedBox(
                                height: 20,
                              ),
                              tickets(),
                            ],
                          )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  // String _name = '';
  List _form = [];
  List _ticketForm = [];
  List<Widget> listWidgetMyForm = [];

  @override
  void initState() {
    super.initState();
    checkFormData(context, post);
  }

  Future checkFormData(BuildContext context, post) async {
    var formQuery = Firestore.instance
        .collection('resForm')
        .where('activityId', isEqualTo: post.documentID);
    var querySnapshot = await formQuery.getDocuments();
    setState(() {
      _ticketForm = querySnapshot.documents[0].data['tickets'];
      _form = querySnapshot.documents[0].data['form'];
      if (_ticketForm[0] == null) {
        setState(() {
          _ticketCount = 0;
        });
      } else if (_ticketForm[1] == null) {
        setState(() {
          _ticketCount = 1;
        });
      } else if (_ticketForm[2] == null) {
        setState(() {
          _ticketCount = 2;
        });
      } else if (_ticketForm[3] == null) {
        setState(() {
          _ticketCount = 3;
        });
      } else if (_ticketForm[4] == null) {
        setState(() {
          _ticketCount = 4;
        });
      } else {
        setState(() {
          _ticketCount = 5;
        });
      }
      setState(() {
        _finalHeight = 310.0 + 50.0 * _ticketCount + _form.length * 70.0;
      });

      for (var i = 0; i < _form.length; i++) {
        listWidgetMyForm.add(new TextFormField(
          controller: i == 0
              ? firstForm
              : i == 1
                  ? secondForm
                  : i == 2
                      ? thirdForm
                      : i == 3
                          ? fourthForm
                          : i == 4
                              ? fifthForm
                              : i == 5 ? sixthForm : seventhForm,
          style: TextStyle(),
          decoration: InputDecoration(
            labelText: _form[i],
          ),
          validator: (value) => value.isEmpty ? '*必填*' : null,
          // onSaved: (value) => i==0? firstForm = value : i==1? secondForm = value : thirdForm = value,
        ));
      }
    });
    // return querySnapshot.documents.toString();
  }

  Widget resForm(context, post) {
    return Column(children: listWidgetMyForm);
  }

  var _selected;
  void onChanged(value) {
    setState(() {
      _selected = value;
    });
    print('Value = $value');
  }

  Widget tickets() {
    return Container(
      height: 50.0 * _ticketCount,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _ticketForm.length,
        itemBuilder: (context, index) {
          return _ticketForm[index] != null
              ? Row(
                  children: <Widget>[
                    Radio(
                      activeColor: Colors.blue,
                      value: _ticketForm[index],
                      groupValue: _selected,
                      onChanged: (val) {
                        onChanged(val);
                      },
                      // title: Text("Number $index"),
                    ),
                    _ticketForm[index]['price'] == '0'
                        ? Text(_ticketForm[index]['title'] + '   免費')
                        : Text(_ticketForm[index]['title'] +
                            '   \$' +
                            _ticketForm[index]['price']),
                  ],
                )
              : SizedBox();
        },
      ),
    );
  }
}

class JoinBottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      labelStyle: TextStyle(
        fontSize: 10.0,
      ),
      tabs: [
        Tab(icon: new Icon(Icons.art_track), text: ('活動')),
        Tab(
          icon: Icon(Icons.payment),
          text: ('線上繳費'),
        ),
        Tab(
          icon: new Icon(Icons.filter_center_focus),
          text: ('活動代碼'),
        ),
        Tab(
          icon: new Icon(Icons.local_activity),
          text: ('報到'),
        ),
      ],
      labelColor: Colors.amber[800],
      unselectedLabelColor: Colors.blue,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Colors.red,
    );
  }
}
