import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchDetailPage extends StatefulWidget {
  MatchDetailPage({Key key, this.userId, this.post}) : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _MatchDetailPageState createState() =>
      _MatchDetailPageState(userId: userId, post: post);
}

class _MatchDetailPageState extends State<MatchDetailPage>
    with SingleTickerProviderStateMixin {
  _MatchDetailPageState({Key key, this.userId, this.post});
  final String userId;
  final DocumentSnapshot post;
  List join = [];
  List newMatched = [];
  bool matchComplete = false;
  List<Icon> iconList = [
    Icon(Icons.ac_unit),
    Icon(Icons.accessibility_new),
    Icon(Icons.airplanemode_active),
    Icon(Icons.airport_shuttle),
    Icon(Icons.videogame_asset),
    Icon(Icons.local_atm),
    Icon(Icons.filter_b_and_w),
    Icon(Icons.border_all),
    Icon(Icons.camera_roll),
    Icon(Icons.beach_access),
    Icon(Icons.brightness_2),
    Icon(Icons.local_bar),
    Icon(Icons.terrain),
    Icon(Icons.traffic),
    Icon(Icons.train),
    Icon(Icons.business_center),
    Icon(Icons.cake),
    Icon(Icons.brush),
    Icon(Icons.call),
    Icon(Icons.wb_cloudy),
    Icon(Icons.weekend),
    Icon(Icons.shopping_cart),
    Icon(Icons.pie_chart),
    Icon(Icons.laptop_chromebook),
    Icon(Icons.local_dining),
    Icon(Icons.local_florist),
    Icon(Icons.local_laundry_service),
    Icon(Icons.local_printshop),
    Icon(Icons.local_mall),
  ];
  List<Icon> newIconList = [];

  @override
  void initState() {
    super.initState();
    getJoinList().whenComplete(() {
      print(join);
    });
  }

  Future getJoinList() async {
    var respectsQuery = Firestore.instance
        .collection('resJoin')
        .where('activityId', isEqualTo: post['activityId'])
        .where('status', isEqualTo: 'checked');
    var querySnapshot = await respectsQuery.getDocuments();
    setState(() {
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        join.add(querySnapshot.documents[i]['form'][0]['value']);
      }
    });
  }

  _showTip() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.error,
                    color: Colors.blue,
                  ),
                  Text('  配對提示')
                ],
              ),
              content: Text('啟用配對後，報名方會獲得一個圖案，協助他們利用圖案找彼此吧！'));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text(post['title']),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
            onPressed: () {
              _showTip();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('interact')
                  .document(post.documentID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: const Text('Loading...'),
                  );
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '配對介紹',
                      style: TextStyle(fontSize: 25),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 30),
                      child: Text(post['content'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15)),
                    ),
                    Divider(),
                    Text(
                      '規則 ',
                      style: TextStyle(fontSize: 25),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 40),
                        child: Text('配對人數為一組 ' +
                            post['count'] +
                            ' 人，人數超出則另組成一組\n\n以下為報名者，共有' +
                            join.length.toString() +
                            '名：',textAlign: TextAlign.center,)),
                    snapshot.data['matchComplete'] == true
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Container(
                                height: 130 + 20 * double.parse(post['count']),
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: (snapshot.data['list'].length /
                                                int.parse(post['count'])) !=
                                            ((snapshot.data['list'].length /
                                                    int.parse(post['count']))
                                                .round())
                                        ? List.generate(
                                            (snapshot.data['list'].length /
                                                    int.parse(post['count']))
                                                .round(), (index) {
                                            return Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.blueGrey,
                                                          width: 2),
                                                      borderRadius:
                                                          new BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0)),
                                                    ),
                                                    child: Column(
                                                      children: <Widget>[
                                                        iconList[snapshot.data[
                                                            'iconList'][index]],
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text('配對姓名'),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Column(
                                                            children: List.generate(
                                                                int.parse(post[
                                                                    'count']),
                                                                (i) {
                                                          return (index *
                                                                          int.parse(post[
                                                                              'count']) +
                                                                      i) <
                                                                  snapshot
                                                                      .data[
                                                                          'list']
                                                                      .length
                                                              ? Text(
                                                                  snapshot
                                                                      .data['list']
                                                                          [
                                                                          index * int.parse(post['count']) +
                                                                              i]
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                )
                                                              : SizedBox();
                                                        })),
                                                      ],
                                                    )),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            );
                                          })
                                        : List.generate(
                                            (snapshot.data['list'].length /
                                                    int.parse(post['count']))
                                                .round(), (index) {
                                            return Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.blueGrey,
                                                          width: 2),
                                                      borderRadius:
                                                          new BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0)),
                                                    ),
                                                    child: Column(
                                                      children: <Widget>[
                                                        iconList[snapshot.data[
                                                            'iconList'][index]],
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text('配對姓名'),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Column(
                                                            children: List.generate(
                                                                int.parse(post[
                                                                    'count']),
                                                                (i) {
                                                          return Text(
                                                            snapshot.data[
                                                                    'list'][index *
                                                                        int.parse(
                                                                            post['count']) +
                                                                    i]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          );
                                                        })),
                                                      ],
                                                    )),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            );
                                          }))))
                        : Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Container(
                                height: 110,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        List.generate(join.length, (index) {
                                      return Row(
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blueGrey,
                                                    width: 2),
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(15.0)),
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Text('姓名'),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    join[index].toString(),
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      );
                                    })))),
                    SizedBox(
                      height: 40,
                    ),
                    snapshot.data['matchComplete'] == true
                        ? RaisedButton(
                            color: Colors.blueGrey,
                            splashColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            highlightElevation: 0,
                            child: Text("取消配對",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            onPressed: () {
                              _dismatch();
                            },
                          )
                        : SizedBox(),
                    RaisedButton(
                      color: Colors.blueGrey,
                      splashColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      child: Text("配對",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      onPressed: () {
                        _match();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                );
              })),
    );
  }

  void _match() async {
    newMatched.clear();
    newIconList.clear();
    var joinlist = new List<int>.generate(join.length, (int index) => index);
    joinlist.shuffle();
    for (var i = 0; i < joinlist.length; i++) {
      newMatched.add(join[joinlist[i]]);
    }
    var mixiconlist =
        new List<int>.generate(iconList.length, (int index) => index);
    mixiconlist.shuffle();
    // for (var i = 0; i < mixiconlist.length; i++) {
    //   newIconList.add(iconList[mixiconlist[i]]);
    // }
    setState(() {
      matchComplete = true;
    });
    await Firestore.instance
        .collection('interact')
        .document(post.documentID)
        .updateData({
      'iconList': mixiconlist,
      'list': newMatched,
      'matchComplete': true,
    });
  }

  void _dismatch() async {
    newMatched.clear();
    setState(() {
      matchComplete = false;
    });
    await Firestore.instance
        .collection('interact')
        .document(post.documentID)
        .updateData({
      'list': join,
      'matchComplete': false,
    });
  }
}
