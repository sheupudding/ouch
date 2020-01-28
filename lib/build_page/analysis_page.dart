import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnalysisPage extends StatefulWidget {
  AnalysisPage({this.post});
  final DocumentSnapshot post;
  @override
  _AnalysisPage createState() => _AnalysisPage();
}

class _AnalysisPage extends State<AnalysisPage> {
  final blue = charts.MaterialPalette.blue.makeShades(2);
  final red = charts.MaterialPalette.red.makeShades(2);
  final green = charts.MaterialPalette.green.makeShades(2);
  final gray = charts.MaterialPalette.gray.makeShades(2);
  bool gen = false;
  bool veg = false;
  List<int> genderList = [0, 0, 0, 0, 0];
  List<int> vegList = [0, 0, 0, 0];
  List<int> checkList = [0, 0];
  List<DateTime> dateList = [];
  List<int> tapCountList = [];
  int joinedcheck = 0;

  @override
  void initState() {
    super.initState();
    getTaped();
    getChecked();
    getIfData();
  }

  void getIfData() async {
    var markedQuery = Firestore.instance
        .collection('resForm')
        .where('activityId', isEqualTo: widget.post.documentID);
    var markedQuerySnapshot = await markedQuery.getDocuments();
    if (markedQuerySnapshot.documents.length != 0) {
      for (var j = 0;
          j < markedQuerySnapshot.documents[0].data['form'].length;
          j++) {
        if (markedQuerySnapshot.documents[0].data['form'][j] == '性別') {
          setState(() {
            gen = true;
          });
          getGender();
        }
        if (markedQuerySnapshot.documents[0].data['form'][j] == '葷素') {
          setState(() {
            veg = true;
          });
          getVeg();
        }
      }
    }
  }

  void getGender() async {
    var markedQuery = Firestore.instance
        .collection('resJoin')
        .where('activityId', isEqualTo: widget.post.documentID)
        .where('status', isEqualTo: 'checked');
    var markedQuerySnapshot = await markedQuery.getDocuments();
    if (markedQuerySnapshot.documents.length != 0) {
      for (var i = 0; i < markedQuerySnapshot.documents.length; i++) {
        for (var j = 0;
            j < markedQuerySnapshot.documents[i].data['form'].length;
            j++) {
          genderList[4] = markedQuerySnapshot.documents.length;
          if (markedQuerySnapshot.documents[i].data['form'][j] !=
              null) if (markedQuerySnapshot.documents[i].data['form'][j]
                  ['title'] ==
              '性別') {
            genderList[3] += 1;
            String data =
                markedQuerySnapshot.documents[i].data['form'][j]['value'];
            print(data);
            if (data == '男' ||
                data == '男性' ||
                data == '男生' ||
                data == '公' ||
                data == '男的') {
              setState(() {
                genderList[0] = genderList[0] + 1;
              });
            } else if (data == '女' ||
                data == '女性' ||
                data == '女生' ||
                data == '母' ||
                data == '女的') {
              setState(() {
                genderList[1] = genderList[1] + 1;
              });
            } else {
              setState(() {
                genderList[2] = genderList[2] + 1;
              });
            }
          }
        }
      }
    }
  }

  void getVeg() async {
    var markedQuery = Firestore.instance
        .collection('resJoin')
        .where('activityId', isEqualTo: widget.post.documentID)
        .where('status', isEqualTo: 'checked');
    var markedQuerySnapshot = await markedQuery.getDocuments();
    if (markedQuerySnapshot.documents.length != 0) {
      for (var i = 0; i < markedQuerySnapshot.documents.length; i++) {
        for (var j = 0;
            j < markedQuerySnapshot.documents[i].data['form'].length;
            j++) {
          if (markedQuerySnapshot.documents[i].data['form'][j] !=
              null) if (markedQuerySnapshot.documents[i].data['form'][j]
                  ['title'] ==
              '葷素') {
            vegList[3] += 1;
            String data =
                markedQuerySnapshot.documents[i].data['form'][j]['value'];
            if (data == '葷' || data == '葷食' || data == '吃肉' || data == '肉') {
              setState(() {
                vegList[0] = vegList[0] + 1;
              });
            } else if (data == '素' ||
                data == '素食' ||
                data == '吃素' ||
                data == '不吃肉' ||
                data == '吃菜') {
              setState(() {
                vegList[1] = vegList[1] + 1;
              });
            } else {
              setState(() {
                vegList[2] = vegList[2] + 1;
              });
            }
          }
        }
      }
    }
  }

  void getChecked() async {
    var markedQuery = Firestore.instance
        .collection('resJoin')
        .where('activityId', isEqualTo: widget.post.documentID);
    var markedQuerySnapshot = await markedQuery.getDocuments();
    if (markedQuerySnapshot.documents.length != 0) {
      for (var i = 0; i < markedQuerySnapshot.documents.length; i++) {
        if (markedQuerySnapshot.documents[i].data['status'] == 'unchecked') {
          setState(() {
            checkList[0] = checkList[0] + 1;
          });
        } else {
          setState(() {
            checkList[1] = checkList[1] + 1;
          });
        }
      }
    }
  }

  void getJoinChecked() async {
    var markedQuery = Firestore.instance
        .collection('resJoin')
        .where('activityId', isEqualTo: widget.post.documentID);
    var markedQuerySnapshot = await markedQuery.getDocuments();
    if (markedQuerySnapshot.documents.length != 0) {
      for (var i = 0; i < markedQuerySnapshot.documents.length; i++) {
        if (markedQuerySnapshot.documents[i].data['joinChecked'] == true) {
          setState(() {
            joinedcheck = joinedcheck + 1;
          });
        }
      }
    }
  }

  void getTaped() async {
    var markedQuery = Firestore.instance
        .collection('activityTapCount')
        .where('activityId', isEqualTo: widget.post.documentID)
        .orderBy('time');
    var markedQuerySnapshot = await markedQuery.getDocuments();
    if (markedQuerySnapshot.documents.length != 0) {
      for (var i = 0; i < markedQuerySnapshot.documents.length; i++) {
        setState(() {
          dateList.add(markedQuerySnapshot.documents[i]['time'].toDate());
          tapCountList.add(markedQuerySnapshot.documents[i]['count']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
                    '關於活動',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
                Tab(
                  child: new Text('關於報名方',
                      style: TextStyle(color: Colors.blueGrey)),
                ),
              ],
              indicatorWeight: 4,
              indicatorColor: Colors.grey,
            ),
          ),
          body: TabBarView(
              // physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                new SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                  child: Column(
                    children: <Widget>[
                      // Text(checkList.toString()),
                      // Text(joinedcheck.toString()),
                      dateList.length != 0
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    '活\n動\n點\n擊\n熱\n度',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: charts.TimeSeriesChart(
                                    _createTappedData(),
                                    animate: true,
                                    animationDuration: Duration(seconds: 1),
                                    domainAxis: new charts.DateTimeAxisSpec(
                                      tickFormatterSpec: new charts
                                              .AutoDateTimeTickFormatterSpec(
                                          minute: new charts.TimeFormatterSpec(
                                            format:
                                                'MM/dd',
                                            transitionFormat: 'yyyy-MM/dd',
                                          ),
                                          hour: new charts.TimeFormatterSpec(
                                            format:
                                                'MM/dd',
                                            transitionFormat: 'yyyy-MM/dd',
                                          ),
                                          day: new charts.TimeFormatterSpec(
                                              format: 'd',
                                              transitionFormat: 'yyyy-MM/dd')),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Center(
                              child: Text('Loading'),
                            ),
                            SizedBox(height: 40,),
                      checkList[0] == 0 && checkList[1] == 0
                          ? Center(
                              child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                Text('尚無人報名你的活動喔'),
                              ],
                            ))
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    '關\n於\n報\n名',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: charts.PieChart(_createCheckedData(),
                                      animate: true,
                                      animationDuration: Duration(seconds: 1),
                                      defaultRenderer:
                                          new charts.ArcRendererConfig(
                                              arcRendererDecorators: [
                                            new charts.ArcLabelDecorator(
                                                insideLabelStyleSpec:
                                                    new charts.TextStyleSpec(
                                                        fontSize: 15),
                                                // outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 11),
                                                labelPosition: charts
                                                    .ArcLabelPosition.auto)
                                          ])),
                                )
                              ],
                            ),
                      SizedBox(
                        height: 40,
                      ),
                      checkList[0] == 0 && checkList[1] == 0
                          ? SizedBox()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    '關\n於\n報\n到',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: charts.PieChart(
                                      _createJoinedCheckedData(),
                                      animate: true,
                                      animationDuration: Duration(seconds: 1),
                                      defaultRenderer:
                                          new charts.ArcRendererConfig(
                                              arcRendererDecorators: [
                                            new charts.ArcLabelDecorator(
                                                insideLabelStyleSpec:
                                                    new charts.TextStyleSpec(
                                                        fontSize: 15),
                                                // outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 11),
                                                labelPosition: charts
                                                    .ArcLabelPosition.auto)
                                          ])),
                                )
                              ],
                            ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
                new SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Text(genderList.toString()),
                          // Text(vegList.toString()),
                          gen && checkList[1] != 0
                              ? Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            '關\n於\n姓\n別',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: charts.PieChart(
                                              _createGenderData(),
                                              animate: true,
                                              animationDuration:
                                                  Duration(seconds: 1),
                                              // Add an [ArcLabelDecorator] configured to render labels outside of the
                                              // arc with a leader line.
                                              //
                                              // Text style for inside / outside can be controlled independently by
                                              // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
                                              //
                                              // Example configuring different styles for inside/outside:
                                              //       new charts.ArcLabelDecorator(
                                              //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                                              //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                                              defaultRenderer:
                                                  new charts.ArcRendererConfig(
                                                      arcRendererDecorators: [
                                                    new charts
                                                            .ArcLabelDecorator(
                                                        outsideLabelStyleSpec:
                                                            new charts
                                                                    .TextStyleSpec(
                                                                fontSize: 15),
                                                        labelPosition: charts
                                                            .ArcLabelPosition
                                                            .auto)
                                                  ])),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40,
                                    )
                                  ],
                                )
                              : SizedBox(),
                          veg && checkList[1] != 0
                              ? Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            '關\n於\n葷\n素',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: charts.BarChart(
                                            _createVegData(),
                                            animate: true,
                                            animationDuration:
                                                Duration(seconds: 1),
                                            // vertical: false,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40,
                                    )
                                  ],
                                )
                              : SizedBox(),
                          !veg && !gen || checkList[1] == 0
                              ? Center(
                                  child: Text('目前無可以統計的資料喔'),
                                )
                              : SizedBox()
                        ]))
              ]),
        ));
  }

  List<charts.Series<Gender, String>> _createGenderData() {
    final data = genderList[2] == 0
        ? [
            new Gender('男', genderList[0]),
            new Gender('女', genderList[1]),
          ]
        : [
            new Gender('男', genderList[0]),
            new Gender('女', genderList[1]),
            new Gender('其他', genderList[2]),
          ];

    return [
      new charts.Series<Gender, String>(
        id: 'Gender',
        domainFn: (Gender gender, _) => gender.gender,
        measureFn: (Gender gender, _) => gender.count,
        colorFn: (Gender gender, _) {
          switch (gender.gender) {
            case "男":
              {
                return blue[1];
              }

            case "女":
              {
                return red[1];
              }

            case "其他":
              {
                return green[1];
              }

            default:
              {
                return gray[0];
              }
          }
        },
        data: data,
        labelAccessorFn: (Gender gender, _) =>
            '${gender.gender}: ${gender.count}',
      )
    ];
  }

  List<charts.Series<Veg, String>> _createVegData() {
    final data = vegList[2] == 0
        ? [
            new Veg('葷', vegList[0]),
            new Veg('素', vegList[1]),
          ]
        : [
            new Veg('葷', vegList[0]),
            new Veg('素', vegList[1]),
            new Veg('其他', vegList[2]),
          ];

    return [
      new charts.Series<Veg, String>(
        id: 'Veg',
        domainFn: (Veg veg, _) => veg.veg,
        measureFn: (Veg veg, _) => veg.count,
        colorFn: (Veg veg, _) {
          switch (veg.veg) {
            case "葷":
              {
                return gray[1];
              }

            case "素":
              {
                return green[1];
              }

            case "其他":
              {
                return blue[1];
              }

            default:
              {
                return red[0];
              }
          }
        },
        data: data,
        labelAccessorFn: (Veg veg, _) => '${veg.veg}: ${veg.count}',
      )
    ];
  }

  List<charts.Series<Checked, String>> _createCheckedData() {
    final data = [
      new Checked('未通過', checkList[0]),
      new Checked('已報名', checkList[1]),
    ];

    return [
      new charts.Series<Checked, String>(
        id: 'Checked',
        domainFn: (Checked veg, _) => veg.checkStatus,
        measureFn: (Checked veg, _) => veg.count,
        data: data,
        labelAccessorFn: (Checked veg, _) => '${veg.checkStatus}: ${veg.count}',
      )
    ];
  }

  List<charts.Series<JoinedChecked, String>> _createJoinedCheckedData() {
    final data = [
      new JoinedChecked('未報到', checkList[1] - joinedcheck),
      new JoinedChecked('已報到', joinedcheck),
    ];

    return [
      new charts.Series<JoinedChecked, String>(
        id: 'JoinedChecked',
        domainFn: (JoinedChecked veg, _) => veg.checkStatus,
        measureFn: (JoinedChecked veg, _) => veg.count,
        data: data,
        labelAccessorFn: (JoinedChecked veg, _) =>
            '${veg.checkStatus}: ${veg.count}',
      )
    ];
  }

  List<charts.Series<Tapped, DateTime>> _createTappedData() {
    List<Tapped> data = [];
    for (var i = 0; i < dateList.length; i++) {
      data.add(Tapped(dateList[i], tapCountList[i]));
    }

    return [
      new charts.Series<Tapped, DateTime>(
        id: 'Tapped',
        domainFn: (Tapped veg, _) => veg.tapped,
        measureFn: (Tapped veg, _) => veg.count,
        data: data,
        labelAccessorFn: (Tapped veg, _) => '${veg.tapped}: ${veg.count}',
      )
    ];
  }
}

class Gender {
  final String gender;
  final int count;

  Gender(this.gender, this.count);
}

class Veg {
  final String veg;
  final int count;

  Veg(this.veg, this.count);
}

class Checked {
  final String checkStatus;
  final int count;

  Checked(this.checkStatus, this.count);
}

class JoinedChecked {
  final String checkStatus;
  final int count;

  JoinedChecked(this.checkStatus, this.count);
}

class Tapped {
  final DateTime tapped;
  final int count;

  Tapped(this.tapped, this.count);
}
