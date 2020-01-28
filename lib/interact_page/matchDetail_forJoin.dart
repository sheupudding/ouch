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
  String nickName = '';
  int userIndex = 0;
  List join = [];
  bool matchComplete = false;
  bool userCatch = false;
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

  @override
  void initState() {
    super.initState();
    getJoinName().whenComplete(() {
      getJoinList().whenComplete(() {
        setState(() {
          userCatch = true;
        });
        print(post['list'][userIndex]);
        print(nickName);
      });
    });
  }

  Future getJoinList() async {
    var respectsQuery =
        Firestore.instance.collection('interact').document(post.documentID);
    var querySnapshot = await respectsQuery.get();
    setState(() {
      for (var i = 0; i < querySnapshot['list'].length; i++) {
        if (querySnapshot['list'][i] == nickName) {
          setState(() {
            userIndex = i;
          });
        }
      }
    });
  }

  Future getJoinName() async {
    var respectsQuery = Firestore.instance
        .collection('resJoin')
        .where('activityId', isEqualTo: post['activityId'])
        .where('joinedId', isEqualTo: userId);
    var querySnapshot = await respectsQuery.getDocuments();
    setState(() {
      nickName = querySnapshot.documents[0]['form'][0]['value'];
    });
  }

  _showIcon(list) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('配對圖案'),
            content: Container(
              height: MediaQuery.of(context).size.width * 0.9,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Transform.scale(
                scale: 7,
                child: IconButton(
                  onPressed: () {},
                  icon: iconList[list[
                      (((userIndex + 1) / int.parse(post['count'])).round() -
                          1)]],
                ),
              ),
              // Icon(Icons.ac_unit,size: 200,)
              // bigIconList[
              //   0
              //   // list[
              //   //   (((userIndex + 1) / int.parse(post['count'])).round() - 1)]
              //     ],
            ),
          );
        });
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
                getJoinList().whenComplete(() {
                  setState(() {
                    userCatch = true;
                  });
                });
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
                      '配對結果',
                      style: TextStyle(fontSize: 25),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 30),
                        child: Text(
                            '藍色的名字為你自己，以下為你與配對夥伴：')),
                    snapshot.data['matchComplete']
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Container(
                                height: 130 + 20 * double.parse(post['count']),
                                child: FlatButton(
                                  onPressed: () {
                                    _showIcon(snapshot.data['iconList']);
                                  },
                                  child:
                                      (post['list'].length /
                                                  int.parse(post['count'])) !=
                                              ((post['list'].length /
                                                      int.parse(post['count']))
                                                  .round())
                                          ? Container(
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
                                                  iconList[snapshot.data[
                                                      'iconList'][(((userIndex +
                                                                  1) /
                                                              int.parse(post[
                                                                  'count']))
                                                          .round() -
                                                      1)]],
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text('配對姓名'),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Column(
                                                      children: List.generate(
                                                          int.parse(
                                                              post['count']),
                                                          (i) {
                                                    return ((((userIndex + 1) / int.parse(post['count']))
                                                                            .round() -
                                                                        1) *
                                                                    int.parse(post[
                                                                        'count']) +
                                                                i +
                                                                1) <=
                                                            post['list'].length
                                                        ? (((userIndex + 1) / int.parse(post['count'])).round() -
                                                                            1) *
                                                                        int.parse(
                                                                            post['count']) +
                                                                    i ==
                                                                userIndex
                                                            ? Text(
                                                                snapshot
                                                                    .data['list']
                                                                        [
                                                                        (((userIndex + 1) / int.parse(post['count'])).round() - 1) *
                                                                                int.parse(post['count']) +
                                                                            i]
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .blue),
                                                              )
                                                            : Text(
                                                                snapshot
                                                                    .data['list']
                                                                        [
                                                                        (((userIndex + 1) / int.parse(post['count'])).round() - 1) *
                                                                                int.parse(post['count']) +
                                                                            i]
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18),
                                                              )
                                                        : SizedBox();
                                                  })),
                                                ],
                                              ))
                                          : Container(
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
                                                  iconList[snapshot.data[
                                                      'iconList'][(((userIndex +
                                                                  1) /
                                                              int.parse(post[
                                                                  'count']))
                                                          .round() -
                                                      1)]],
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text('配對姓名'),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Column(
                                                      children: List.generate(
                                                          int.parse(
                                                              post['count']),
                                                          (i) {
                                                    return ((userIndex + 1) /
                                                                        int.parse(
                                                                            post['count']))
                                                                    .round() +
                                                                i -
                                                                1 ==
                                                            userIndex
                                                        ? Text(
                                                            snapshot.data[
                                                                    'list'][((userIndex +
                                                                                1) /
                                                                            int.parse(post['count']))
                                                                        .round() +
                                                                    i -
                                                                    1]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .blue),
                                                          )
                                                        : Text(
                                                            snapshot.data[
                                                                    'list'][((userIndex +
                                                                                1) /
                                                                            int.parse(post['count']))
                                                                        .round() +
                                                                    i -
                                                                    1]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          );
                                                  })),
                                                ],
                                              )),
                                )))
                        : Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blueGrey, width: 2),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Text('尚未配對\n等待主辦方啟動吧！', style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('啟用配對後，你會獲得一個圖案，\n點擊以利用圖案找到你的夥伴吧！'),
                    SizedBox(
                      height: 40,
                    )
                  ],
                );
              }),
        ));
  }
}
