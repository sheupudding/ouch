import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LotteryPage extends StatefulWidget {
  LotteryPage({Key key, this.userId, this.post}) : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _LotteryPageState createState() =>
      _LotteryPageState(userId: userId, post: post);
}

class _LotteryPageState extends State<LotteryPage> {
  _LotteryPageState({Key key, this.userId, this.post});
  final String userId;
  final DocumentSnapshot post;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();
  TextEditingController _prizeController = new TextEditingController();
  TextEditingController _prizeCountController = new TextEditingController();
  TextEditingController _percentageController =
      new TextEditingController(text: '40');
  TextEditingController _prizeController2 = new TextEditingController();
  TextEditingController _prizeCountController2 = new TextEditingController();
  TextEditingController _prizeController3 = new TextEditingController();
  TextEditingController _prizeCountController3 = new TextEditingController();
  TextEditingController _prizeController4 = new TextEditingController();
  TextEditingController _prizeCountController4 = new TextEditingController();
  TextEditingController _prizeController5 = new TextEditingController();
  TextEditingController _prizeCountController5 = new TextEditingController();

  TextEditingController _timeController = new TextEditingController(text: '1');
  TextEditingController _dailyController = new TextEditingController(text: '1');
  String _isRadioSelected='次數';
  int prizeCount = 1;
  String prizeStatus = '增加獎項';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('建立抽獎')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Center(
                    child: Text(
                      'Step 1  標題及介紹',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                TextFormField(
                  maxLines: 1,
                  controller: _titleController,
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    labelText: '功能模式名稱',
                  ),
                  validator: (value) => value.isEmpty ? '*名稱必填*' : null,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: null,
                  controller: _contentController,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    labelText: '為你的抽獎加入介紹吧',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Color.fromRGBO(58, 66, 86, 1.0)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                  child: Center(
                    child: Text(
                      'Step 2  獎項設置',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Container(
                    height: 150.0 * prizeCount,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: prizeCount,
                      itemBuilder: (context, rownumber) {
                        return _buildItem(context, rownumber);
                      },
                    )),
                SizedBox(
                  height: 20,
                ),
                OutlineButton(
                  splashColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  highlightElevation: 0,
                  borderSide: BorderSide(color: Colors.grey),
                  child: Text(prizeStatus,
                      style: TextStyle(
                        color: Colors.blueGrey,
                      )),
                  onPressed: () {
                    setState(() {
                      if (prizeCount > 4) {
                        prizeStatus = '僅能擁有5種獎項';
                      } else {
                        prizeCount++;
                        if (prizeCount > 4) {
                          prizeStatus = '僅能擁有5種獎項';
                        }
                      }
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                  child: Center(
                    child: Text(
                      'Step 3  抽獎規則',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                RadioListTile(
                    groupValue: _isRadioSelected,
                    title: Row(
                      children: <Widget>[
                        Text('一人只能抽 '),
                        Container(
                          width: 60,
                          child: TextFormField(
                            controller: _timeController,
                            decoration: InputDecoration(
                              hintText: '次數',
                            ),
                          ),
                        ),
                        Text(' 次')
                      ],
                    ),
                    value: '次數',
                    onChanged: (val) {
                      setState(() {
                        _isRadioSelected = val;
                        debugPrint('VAL = $val');
                      });
                    }),
                // RadioListTile(
                //     groupValue: _isRadioSelected,
                //     title: Row(
                //       children: <Widget>[
                //         Text('每天 '),
                //         Container(
                //           width: 60,
                //           child: TextFormField(
                //             controller: _dailyController,
                //             decoration: InputDecoration(
                //               hintText: '次數',
                //             ),
                //           ),
                //         ),
                //         Text(' 次，抽完為止')
                //       ],
                //     ),
                //     value: '每天',
                //     onChanged: (val) {
                //       setState(() {
                //         _isRadioSelected = val;
                //         debugPrint('VAL = $val');
                //       });
                //     }),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                  child: Center(
                    child: new RaisedButton(
                        child: Text('建立',
                            style: new TextStyle(
                              color: Colors.white,
                            )),
                        color: Colors.blue,
                        splashColor: Colors.blueGrey,
                        onPressed: () async {
                          await Firestore.instance
                              .collection('interact')
                              .document()
                              .setData({
                            'type': "抽獎模式",
                            'title': _titleController.text,
                            'content': _contentController.text,
                            'percentage': _percentageController.text,
                            'prize': [
                              _prizeController.text != ''
                                  ? {
                                      'name': _prizeController.text,
                                      'count': _prizeCountController.text,
                                      'leftCount': _prizeCountController.text,
                                    }
                                  : null,
                              _prizeController2.text != ''
                                  ? {
                                      'name': _prizeController2.text,
                                      'count': _prizeCountController2.text,
                                      'leftCount': _prizeCountController2.text,
                                    }
                                  : null,
                              _prizeController3.text != ''
                                  ? {
                                      'name': _prizeController3.text,
                                      'count': _prizeCountController3.text,
                                      'leftCount': _prizeCountController3.text,
                                    }
                                  : null,
                              _prizeController4.text != ''
                                  ? {
                                      'name': _prizeController4.text,
                                      'count': _prizeCountController4.text,
                                      'leftCount': _prizeCountController4.text,
                                    }
                                  : null,
                              _prizeController5.text != ''
                                  ? {
                                      'name': _prizeController5.text,
                                      'count': _prizeCountController5.text,
                                      'leftCount': _prizeCountController5.text,
                                    }
                                  : null,
                            ],
                            'activityId': post.documentID,
                            'rule': _isRadioSelected,
                            'ruleValue': _isRadioSelected == '次數'
                                ? _timeController.text
                                : _dailyController.text,
                          }).whenComplete(() {
                            Navigator.of(context).pop();
                          });
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int itemIndex) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 25),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  '●   ',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: itemIndex == 0
                      ? _prizeController
                      : itemIndex == 1
                          ? _prizeController2
                          : itemIndex == 2
                              ? _prizeController3
                              : itemIndex == 3
                                  ? _prizeController4
                                  : _prizeController5,
                  decoration: InputDecoration(
                    labelText: '獎品項目',
                  ),
                  validator: (value) => value.isEmpty ? '*名稱必填*' : null,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '機率：  ',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: itemIndex == 0
                      ? _prizeCountController
                      : itemIndex == 1
                          ? _prizeCountController2
                          : itemIndex == 2
                              ? _prizeCountController3
                              : itemIndex == 3
                                  ? _prizeCountController4
                                  : _prizeCountController5,
                  decoration: InputDecoration(
                    hintText: '獎項數量',
                  ),
                  validator: (value) => value.isEmpty ? '*必填*' : null,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '   /   ',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _percentageController,
                  decoration: InputDecoration(
                    hintText: '機率分母',
                  ),
                  validator: (value) => value.isEmpty ? '*必填*' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
