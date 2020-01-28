import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import './activity_cell.dart';
import './join_page/join_cell.dart';
import './build_page/build_page.dart';
import './build_page/build_cell.dart';
import './profile_page/profile_page.dart';
import './animated_bottombar.dart';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './activity_detail.dart';
// import './build_page/build_page.dart';
import './build_page/buildactivity_detail.dart';
import './join_page/joinactivity_detail.dart';

Icon cusSearchIcon = Icon(Icons.search);
Widget cusSearchbar = Text("Ouch!");
bool _search = false;
List<String> _newData = [];
bool searchByCode = false;
String area = '';
String yetArea = '';
bool searchCode = false;
TextEditingController _codeController = new TextEditingController();
List<String> areaList = [
  '台北市',
  '新北市',
  '基隆市',
  '宜蘭縣',
  '桃園市',
  '新竹市',
  '新竹縣',
  '苗栗縣',
  '台中市',
  '彰化縣',
  '南投縣',
  '雲林縣',
  '嘉義市',
  '嘉義縣',
  '台南市',
  '高雄市',
  '屏東縣',
  '花蓮縣',
  '台東縣'
];
String selectArea;
List<String> tagList = [
  "運動",
  "音樂",
  "藝術",
  "知識",
  "飲食",
  "公益",
  "聚會",
  "會議",
  "旅遊",
  "展覽",
  "表演",
  "競賽",
  "社交"
];
String tag = '';
String yetTag = '';

// String userid="";

// void initState() async {
//   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
//   final String uid = user.uid.toString();
//   userid=uid;
// }

class Home extends StatefulWidget {
  Home({this.auth, this.onSignedOut, this.userId});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  final List<BarItem> barItems = [
    BarItem(
      text: "首頁",
      iconData: Icons.home,
      color: Colors.indigo,
    ),
    BarItem(
      text: "報名的活動",
      iconData: Icons.local_activity,
      color: Colors.pinkAccent,
    ),
    BarItem(
      text: "你的活動",
      iconData: Icons.flag,
      color: Colors.yellow.shade900,
    ),
    // BarItem(
    //   text: "珍藏",
    //   iconData: Icons.star,
    //   color: Colors.teal,
    // ),
    BarItem(
      text: "個人",
      iconData: Icons.perm_identity,
      color: Colors.teal,
    ),
  ];
  @override
  State<StatefulWidget> createState() {
    return new HomeState(auth: auth, onSignedOut: onSignedOut, userId: userId);
  }
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  HomeState({this.auth, this.onSignedOut, this.userId});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  String userName = '';
  int selectedBarIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> getNickName() async {
    await Firestore.instance
        .collection("users")
        .where('userid', isEqualTo: userId)
        .getDocuments()
        .then((doc) {
      userName = doc.documents[0]['displayName'];
    });
    if (userName == null || userName == '') {
      setState(() {
        userName = 'QQ';
        print("沒有");
      });
    } else {
      print('有！ $userName');
      setState(() {
        userName = userName;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getNickName();
  }

  _showLocationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Center(
              child: SingleSelectChip(areaList, onSelectionChanged: (selected) {
                setState(() {
                  yetArea = selected;
                });
                print(area);
                Navigator.pop(context);
              }),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  _showTagDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Center(
              child: SingleSelectChip(tagList, onSelectionChanged: (selected) {
                setState(() {
                  yetTag = selected;
                });
                print(tag);
                Navigator.pop(context);
              }),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> myTabs = <Tab>[
      new Tab(
        child: new ActivityCell(auth: widget.auth, userId: userId),
      ),
      new Tab(
        child: new JoinCell(userId: userId),
      ),
      new Tab(
        child: new BuildCell(
            auth: widget.auth, userId: userId, userName: userName),
      ),
      // new Tab(
      //   child: new CollectCell(),
      // ),
      new Tab(
        child: new ProfilePage(
            auth: widget.auth,
            onSignedOut: onSignedOut,
            userId: userId,
            userName: userName),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Row(
                children: <Widget>[
                  VerticalDivider(
                    thickness: 5,
                    color: Colors.white60,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '今天是 ' +
                            DateFormat("yyyy/MM/dd").format(DateTime.now()),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        '\n嗨！ ' +
                            userName +
                            ' 歡迎回來 :D \n\n今天也辛苦了！知道嗎？\n每個努力的自己都能讓明天更美好。',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                '你在找什麼？',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            !searchCode
                ? Column(
                    children: <Widget>[
                      Divider(),
                      Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.blueGrey,
                                      ),
                                      Text(
                                        '  地點  ',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    _showLocationDialog();
                                  },
                                ),
                              ),
                              yetArea != null && yetArea != ''
                                  ? RaisedButton(
                                      color: Colors.blueGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            yetArea,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          yetArea = '';
                                        });
                                      })
                                  : SizedBox(),
                            ],
                          )),
                      Divider(),
                      Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.local_offer,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(
                                      '  標籤  ',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  _showTagDialog();
                                },
                              )),
                              yetTag != null && yetTag != ''
                                  ? RaisedButton(
                                      color: Colors.blueGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            yetTag,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          yetTag = '';
                                        });
                                      })
                                  : SizedBox(),
                            ],
                          )),
                      Divider(),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        hintText: "輸入活動代碼",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: !searchCode
                  ? FlatButton(
                      child: Text(
                        '或是活動代碼搜尋',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      onPressed: () {
                        setState(() {
                          searchCode = true;
                        });
                      },
                    )
                  : FlatButton(
                      child: Text(
                        '或是以類型搜尋',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      onPressed: () {
                        setState(() {
                          searchCode = false;
                        });
                      },
                    ),
            ),
            Center(
              child: OutlineButton(
                splashColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.blue),
                child: Text("搜尋",
                    style: TextStyle(color: Colors.blue, fontSize: 17)),
                onPressed: () {
                  if (!searchCode) {
                    setState(() {
                      searchByCode = false;
                      area = yetArea;
                      tag = yetTag;
                    });
                  } else {
                    setState(() {
                      searchByCode = true;
                    });
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(
                                userId: userId,
                                auth: auth,
                              )));
                },
              ),
            ),
          ],
        ),
      )),
      appBar: AppBar(
        centerTitle: true,
        title: cusSearchbar,
        leading: IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            setState(() {
              yetArea = area;
              yetTag = tag;
            });
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: AnimatedContainer(
        // color: widget.barItems[selectedBarIndex].color,
        duration: const Duration(milliseconds: 300),
        child: Stack(
          children: <Widget>[
            new Container(
              height: 1200,
              child: myTabs[selectedBarIndex],
            ),
            // Positioned(
            //   top: 0,
            //   left: 60,
            //   child: ListViewSearch(),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBottomBar(
          barItems: widget.barItems,
          animationDuration: const Duration(milliseconds: 150),
          barStyle: BarStyle(fontSize: 10.0, iconSize: 25.0),
          onBarTap: (index) {
            setState(() {
              selectedBarIndex = index;
            });
          }),
    );
  }
}

class SingleSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(String) onSelectionChanged;

  SingleSelectChip(this.reportList, {this.onSelectionChanged});

  @override
  _SingleSelectChipState createState() => _SingleSelectChipState();
}

class _SingleSelectChipState extends State<SingleSelectChip> {
  // String selectedChoice = "";
  String selectedChoice = '';

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = selected ? item : null;
              widget.onSelectionChanged(selectedChoice);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class Floating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print('add');
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new BuildActivity()));
        });
  }
}

class ListViewSearch extends StatefulWidget {
  _ListViewSearchState createState() => _ListViewSearchState();
}

class _ListViewSearchState extends State<ListViewSearch> {
  @override
  Widget build(BuildContext context) {
    return _search
        ? _newData != null && _newData.length != 0
            ? new Container(
                color: Colors.grey[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _newData.map((data) {
                    return new Container(
                      width: 250,
                      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      child: new Text(
                        data,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // padding: EdgeInsets.all(10.0),
                children: [
                  Text(
                    "沒有相符的結果",
                    style: TextStyle(color: Colors.blueGrey),
                  )
                ]
                // )
                ,
              )
        : Text("");
  }
}

class ActivityCell extends StatefulWidget {
  ActivityCell({Key key, this.auth, this.userId, this.userName})
      : super(key: key);
  final BaseAuth auth;
  final String userId;
  final String userName;

  @override
  State<StatefulWidget> createState() {
    return ActivityCellState(userId: userId, auth: auth, userName: userName);
  }
}

class ActivityCellState extends State<ActivityCell> {
  ActivityCellState({Key key, this.auth, this.userId, this.userName});
  final String userId;
  final BaseAuth auth;
  final String userName;
  String status = '';

  DocumentSnapshot _lastVisible;
  List<DocumentSnapshot> _data = new List<DocumentSnapshot>();
  DocumentSnapshot codeActivity;
  bool _isLoading;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController controller;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  Future<Null> _getData() async {
//    await new Future.delayed(new Duration(seconds: 5));
    QuerySnapshot data;

    if (searchByCode) {
      codeActivity = await Firestore.instance
          .collection('activity')
          .document(_codeController.text)
          .get();
    } else if (area != '' && area != null && tag != '' && tag != null) {
      if (_lastVisible == null)
        data = await Firestore.instance
            .collection('activity')
            .where('localityArea', isEqualTo: area)
            .where('tags', arrayContains: tag)
            .orderBy('start_time')
            .limit(3)
            .getDocuments();
      else
        data = await Firestore.instance
            .collection('activity')
            .orderBy('start_time')
            .where('localityArea', isEqualTo: area)
            .where('tags', arrayContains: tag)
            .startAfter([_lastVisible['start_time']])
            .limit(3)
            .getDocuments();
    } else if (area != '' && area != null) {
      if (_lastVisible == null)
        data = await Firestore.instance
            .collection('activity')
            .where('localityArea', isEqualTo: area)
            .orderBy('start_time')
            .limit(3)
            .getDocuments();
      else
        data = await Firestore.instance
            .collection('activity')
            .where('localityArea', isEqualTo: area)
            .orderBy('start_time')
            .startAfter([_lastVisible['start_time']])
            .limit(3)
            .getDocuments();
    } else if (tag != '' && tag != null) {
      if (_lastVisible == null)
        data = await Firestore.instance
            .collection('activity')
            .where('tags', arrayContains: tag)
            .orderBy('start_time')
            .limit(3)
            .getDocuments();
      else
        data = await Firestore.instance
            .collection('activity')
            .where('tags', arrayContains: tag)
            .orderBy('start_time')
            .startAfter([_lastVisible['start_time']])
            .limit(3)
            .getDocuments();
    } else {
      if (_lastVisible == null)
        data = await Firestore.instance
            .collection('activity')
            .orderBy('start_time')
            .limit(3)
            .getDocuments();
      else
        data = await Firestore.instance
            .collection('activity')
            .orderBy('start_time')
            .startAfter([_lastVisible['start_time']])
            .limit(3)
            .getDocuments();
    }

    if (data != null && data.documents.length > 0) {
      _lastVisible = data.documents[data.documents.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _data.addAll(data.documents);
        });
      }
    } else {
      setState(() => _isLoading = false);
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('沒有更多活動了'),
        ),
      );
    }
    return null;
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  navigateToDetail(DocumentSnapshot post, userId, auth) async {
    var respectsQuery = Firestore.instance
        .collection('resJoin')
        .where('activityId', isEqualTo: post.documentID)
        .where('joinedId', isEqualTo: userId);
    var querySnapshot = await respectsQuery.getDocuments();

    if (post['creator'] == userId) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BuildActivityDetailPage(
                  userId: userId, auth: auth, post: post, userName: userName)));
    } else if (querySnapshot.documents.length == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ActivityDetailPage(
                    userId: userId,
                    auth: auth,
                    post: post,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JoinActivityDetailPage(
                    userId: userId,
                    auth: auth,
                    post: post,
                  )));
    }
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

  Widget joinCountText(BuildContext context, post) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('resJoin')
            .where('activityName', isEqualTo: post['title'])
            .where('status', isEqualTo: 'checked')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text(
              "0",
              style: TextStyle(
                color: Colors.grey[300],
              ),
            );
          } else if (snapshot.data.documents.length == 0 && snapshot.hasData) {
            return new Text(
              "0",
              style: TextStyle(
                color: Colors.grey[300],
              ),
            );
          } else {
            return new Text(
              snapshot.data.documents.length.toString(),
              style: TextStyle(
                color: Colors.grey[300],
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        body: searchByCode
            ? codeActivity != null
                ? Container(
                    child: Column(children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: RaisedButton(
                        color: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _codeController.text,
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            searchByCode = false;
                          });
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                        userId: userId,
                                        auth: auth,
                                      )));
                        },
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        navigateToDetail(codeActivity, userId, auth);
                        if (codeActivity['creator'] != userId) {
                          var postQuery = await Firestore.instance
                              .collection('activityTapCount')
                              .where('activityId',
                                  isEqualTo: codeActivity.documentID)
                              .getDocuments();
                          var post = postQuery.documents[0];
                          await Firestore.instance
                              .collection('activityTapCount')
                              .document(post.documentID)
                              .updateData({
                            'daily': [
                              {
                                DateFormat("yyyy-MM-dd").format(DateTime.now()):
                                    post['daily'][DateFormat("yyyy-MM-dd")
                                                .format(DateTime.now())] !=
                                            null
                                        ? post['daily'][DateFormat("yyyy-MM-dd")
                                                .format(DateTime.now())] +
                                            1
                                        : 1
                              }
                            ],
                          });
                        }
                      },
                      contentPadding: EdgeInsets.all(10),
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
                                    imageUrl: codeActivity['image'],
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
                                              codeActivity['title'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          new Container(
                                            child: codeActivity['creator'] ==
                                                    userId
                                                ? Text(
                                                    '你的活動',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : joinStatusText(
                                                    context, codeActivity),
                                          )
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
                                                codeActivity['creatorName'],
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
                                                  context, codeActivity),
                                              Text(
                                                '/ ' +
                                                    codeActivity[
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Text('活動資訊'),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time, size: 17),
                                    Text(
                                      ' ' +
                                          DateFormat("yyyy-MM-dd hh:mm").format(
                                              codeActivity['start_time']
                                                  .toDate()),
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
                                          codeActivity['localityArea'] +
                                          ' ' +
                                          codeActivity['localityLocal'],
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ],
                                )
                              ],
                            )),
                            // ListTile(title: Text(document['people_limit'])),
                            // ListTile(title: Text(document['creator'])),
                          ],
                        ),
                      ),
                    )
                  ]))
                : Center(
                    child: Text('無此活動'),
                  )
            : Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        area != '' && area != null
                            ? RaisedButton(
                                color: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      area,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  setState(() {
                                    area = '';
                                  });
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home(
                                                userId: userId,
                                                auth: auth,
                                              )));
                                },
                              )
                            : SizedBox(),
                        SizedBox(
                          width: 20,
                        ),
                        tag != '' && tag != null
                            ? RaisedButton(
                                color: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      tag,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  setState(() {
                                    tag = '';
                                  });
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home(
                                                userId: userId,
                                                auth: auth,
                                              )));
                                },
                              )
                            : SizedBox()
                      ],
                    )),
                    Expanded(
                      child: RefreshIndicator(
                        child: ListView.builder(
                            controller: controller,
                            itemCount: _data.length + 1,
                            itemBuilder: (context, index) {
                              if (index < _data.length) {
                                final DocumentSnapshot document = _data[index];
                                return ListTile(
                                  onTap: () async {
                                    navigateToDetail(document, userId, auth);
                                    if (document['creator'] != userId) {
                                      print('點擊');
                                      var postQuery = await Firestore.instance
                                          .collection('activityTapCount')
                                          .where('activityId',
                                              isEqualTo: document.documentID)
                                          .where('date',
                                              isEqualTo:
                                                  DateFormat("yyyy-MM-dd")
                                                      .format(DateTime.now()))
                                          .getDocuments();
                                      if (postQuery.documents.length == 0) {
                                        await Firestore.instance
                                            .collection('activityTapCount')
                                            .document()
                                            .setData({
                                          'activityId': document.documentID,
                                          'date': DateFormat("yyyy-MM-dd")
                                              .format(DateTime.now()),
                                          'count': 1,
                                          'time': DateTime.now()
                                        });
                                      } else {
                                        var post = postQuery.documents[0];
                                        await Firestore.instance
                                            .collection('activityTapCount')
                                            .document(post.documentID)
                                            .updateData(
                                                {'count': post['count'] + 1});
                                      }
                                    }
                                  },
                                  contentPadding: EdgeInsets.all(10),
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
                                                imageUrl: document['image'],
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child: SizedBox(
                                                  child:
                                                      CircularProgressIndicator(),
                                                  height: 20.0,
                                                  width: 20.0,
                                                )),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                            Container(
                                              height: 200.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  gradient: LinearGradient(
                                                      begin: FractionalOffset
                                                          .topCenter,
                                                      end: FractionalOffset
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.grey
                                                            .withOpacity(0.0),
                                                        Colors.grey
                                                            .withOpacity(0.0),
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
                                                          document['title'],
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      new Container(
                                                        child: document[
                                                                    'creator'] ==
                                                                userId
                                                            ? Text(
                                                                '你的活動',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            : joinStatusText(
                                                                context,
                                                                document),
                                                      )
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
                                                            Icons
                                                                .account_circle,
                                                            size: 20,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                          Text(
                                                            document[
                                                                'creatorName'],
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            '參加人數： ',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                          ),
                                                          joinCountText(context,
                                                              document),
                                                          Text(
                                                            '/ ' +
                                                                document[
                                                                    'people_limit'],
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[300],
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
                                                Icon(Icons.access_time,
                                                    size: 17),
                                                Text(
                                                  ' ' +
                                                      DateFormat(
                                                              "yyyy-MM-dd hh:mm")
                                                          .format(document[
                                                                  'start_time']
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
                                                      document['localityArea'] +
                                                      ' ' +
                                                      document['localityLocal'],
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                        // ListTile(title: Text(document['people_limit'])),
                                        // ListTile(title: Text(document['creator'])),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: new Opacity(
                                    opacity: _isLoading ? 1.0 : 0.0,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: new SizedBox(
                                          width: 32.0,
                                          height: 32.0,
                                          child:
                                              new CircularProgressIndicator()),
                                    ),
                                  ),
                                );
                              }
                            }),
                        onRefresh: () async {
                          _data.clear();
                          _lastVisible = null;
                          await _getData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
