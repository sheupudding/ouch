import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../lottery_model/board_view.dart';
import '../lottery_model/model.dart';

class LotteryDetailPage extends StatefulWidget {
  LotteryDetailPage({Key key, this.userId, this.post}) : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _LotteryDetailPageState createState() =>
      _LotteryDetailPageState(userId: userId, post: post);
}

class _LotteryDetailPageState extends State<LotteryDetailPage>
    with SingleTickerProviderStateMixin {
  _LotteryDetailPageState({Key key, this.userId, this.post});
  final String userId;
  final DocumentSnapshot post;

  double _angle = 0;
  double _current = 0;
  AnimationController _ctrl;
  Animation _ani;
  List<Luck> _items = [
    Luck("hit", Colors.lightBlue[100]),
  ];

  bool lose = true;

  @override
  void initState() {
    super.initState();
    int prizeCount = 0;
    for (var i = 0; i < post['prize'].length; i++) {
      if (post['prize'][i] != null) {
        prizeCount = int.parse(post['prize'][i]['count']) + prizeCount;
      }
    }
    int num = (int.parse(post['percentage']) / prizeCount).round();
    for (var i = 0; i < num; i++) {
      _items.add(
        Luck("blank", Colors.white),
      );
    }

    var _duration = Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text(post['title']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //         colors: [Colors.blue[100], Colors.blue.withOpacity(0.2)])
        //         ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              '抽獎介紹',
              style: TextStyle(fontSize: 25),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 30),
              child: Text(post['content'],
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
            ),
            Divider(),
            Text(
              '獎項與規則',
              style: TextStyle(fontSize: 25),
            ),
            _prizeList(),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: post['rule'] == '次數'
                  ? Column(
                      children: <Widget>[
                        Text(
                          '報名方只有 ' + post['ruleValue'] + ' 次抽獎機會喔！\n建立者抽獎無效',
                          textAlign: TextAlign.center,
                        ),
                        OutlineButton(
                            splashColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            highlightElevation: 0,
                            borderSide: BorderSide(color: Colors.grey),
                            child: Text('查看中獎結果',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                )),
                            onPressed: () => _results()),
                      ],
                    )
                  : Text(
                      '報名方每天都有 ' + post['ruleValue'] + ' 次抽獎機會喔！\n建立者抽獎無效！',
                      textAlign: TextAlign.center,
                    ),
            ),
            AnimatedBuilder(
                animation: _ani,
                builder: (context, child) {
                  final _value = _ani.value;
                  final _angle = _value * this._angle;
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      BoardView(
                          items: _items, current: _current, angle: _angle),
                      _buildGo(),
                      _buildResult(_value),
                    ],
                  );
                }),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  _results() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('中獎名單'),
            content: Container(
              height: 300,
              child: lotteryHitText(context, post),
            ),
          );
        });
  }

  Widget lotteryHitText(BuildContext context, post) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(post['prize'].length, (i) {
            return post['prize'][i]!=null?
            new StreamBuilder(
                stream: Firestore.instance
                    .collection('lotteryCount')
                    .where('prize', isEqualTo: post['prize'][i]['name'])
                    .where('interactId', isEqualTo: post.documentID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Text("");
                  } else if (snapshot.data.documents.length == 0 &&
                      snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post['prize'][i]['name'],
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        new Text("沒有人抽到", style: TextStyle(fontSize: 15)),
                        SizedBox(height: 20,)
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post['prize'][i]['name'],
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                snapshot.data.documents.length, (index) {
                          return realGetNickname(context,
                              snapshot.data.documents[index]['userId']);
                        })),
                        SizedBox(height: 20,)
                      ],
                    );
                  }
                }):SizedBox();
          })),
    );
  }

  Widget realGetNickname(BuildContext context, id) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('userid', isEqualTo: id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          // var userDocument = snapshot.data;
          return Text('·  '+snapshot.data.documents[0]['displayName']);
        });
  }

  Widget _prizeList() {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: new StreamBuilder(
          stream: Firestore.instance
              .collection('interact')
              .document(post.documentID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("0");
            } else {
              return Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    snapshot.data['prize'][0] != null
                        ? Container(
                            padding: EdgeInsets.all(20),
                            // width: 50,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blueGrey, width: 2),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data['prize'][0]['name'],
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '共有 ' +
                                      snapshot.data['prize'][0]['count'] +
                                      ' 個名額',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                Text(
                                  '已抽出數量：' +
                                      (int.parse(snapshot.data['prize'][0]
                                                  ['count']) -
                                              int.parse(snapshot.data['prize']
                                                  [0]['leftCount']))
                                          .toString(),
                                  style: TextStyle(color: Colors.blueGrey),
                                )
                              ],
                            ))
                        : SizedBox(),
                    SizedBox(
                      width: 20,
                    ),
                    snapshot.data['prize'][1] != null
                        ? Container(
                            padding: EdgeInsets.all(20),
                            // width: 50,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blueGrey, width: 2),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data['prize'][1]['name'],
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '共有 ' +
                                      snapshot.data['prize'][1]['count'] +
                                      ' 個名額',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                Text(
                                  '已抽出數量：' +
                                      (int.parse(snapshot.data['prize'][1]
                                                  ['count']) -
                                              int.parse(snapshot.data['prize']
                                                  [1]['leftCount']))
                                          .toString(),
                                  style: TextStyle(color: Colors.blueGrey),
                                )
                              ],
                            ))
                        : SizedBox(),
                    SizedBox(
                      width: 20,
                    ),
                    snapshot.data['prize'][2] != null
                        ? Container(
                            padding: EdgeInsets.all(20),
                            // width: 50,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blueGrey, width: 2),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data['prize'][2]['name'],
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '共有 ' +
                                      snapshot.data['prize'][2]['count'] +
                                      ' 個名額',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                Text(
                                  '已抽出數量：' +
                                      (int.parse(snapshot.data['prize'][2]
                                                  ['count']) -
                                              int.parse(snapshot.data['prize']
                                                  [2]['leftCount']))
                                          .toString(),
                                  style: TextStyle(color: Colors.blueGrey),
                                )
                              ],
                            ))
                        : SizedBox(),
                    SizedBox(
                      width: 20,
                    ),
                    snapshot.data['prize'][3] != null
                        ? Container(
                            padding: EdgeInsets.all(20),
                            // width: 50,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blueGrey, width: 2),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data['prize'][3]['name'],
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '共有 ' +
                                      snapshot.data['prize'][3]['count'] +
                                      ' 個名額',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                Text(
                                  '已抽出數量：' +
                                      (int.parse(snapshot.data['prize'][3]
                                                  ['count']) -
                                              int.parse(snapshot.data['prize']
                                                  [3]['leftCount']))
                                          .toString(),
                                  style: TextStyle(color: Colors.blueGrey),
                                )
                              ],
                            ))
                        : SizedBox(),
                    SizedBox(
                      width: 20,
                    ),
                    snapshot.data['prize'][4] != null
                        ? Container(
                            padding: EdgeInsets.all(20),
                            // width: 50,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blueGrey, width: 2),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data['prize'][4]['name'],
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '共有 ' +
                                      snapshot.data['prize'][4]['count'] +
                                      ' 個名額',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                Text(
                                  '已抽出數量：' +
                                      (int.parse(snapshot.data['prize'][4]
                                                  ['count']) -
                                              int.parse(snapshot.data['prize']
                                                  [4]['leftCount']))
                                          .toString(),
                                  style: TextStyle(color: Colors.blueGrey),
                                )
                              ],
                            ))
                        : SizedBox(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  _buildGo() {
    return Material(
      color: Colors.white,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          width: 72,
          child: Text(
            "GO !",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () {
          _animation();
        },
      ),
    );
  }

  _animation() {
    if (!_ctrl.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();
      }).whenComplete(_showDialog);
    }
  }

  List prize = [];
  void _showDialog() {
    String result = '';
    if (!lose) {
      for (var i = 0; i < post['prize'].length; i++) {
        if (post['prize'][i] != null) {
          for (var j = 0; j < int.parse(post['prize'][i]['count']); j++) {
            prize.add(post['prize'][i]['name']);
          }
        }
      }
      result = prize[Random().nextInt(prize.length)];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: lose ? new Text("再接再厲！") : new Text("恭喜你！"),
          content: lose
              ? new Text("很抱歉，沒有中獎 :( \n下次的你會更幸運！")
              : new Text("幸運的你抽中了 $result！！"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }

  // void setLose(){
  //   setState(() {
  //     lose = false;
  //   });
  // }

  _buildResult(_value) {
    var _index = _calIndex(_value * _angle + _current);
    String _asset = _items[_index].asset;
    if (_asset == 'images/blank.png') {
      lose = true;
    } else {
      lose = false;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Align(alignment: Alignment.bottomCenter, child: SizedBox()
          // _asset == 'images/blank.png'
          //     ? Image.asset('images/none.png', height: 80, width: 80)
          //     : Image.asset(_asset, height: 80, width: 80),
          ),
    );
  }
}
