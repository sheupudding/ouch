import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchPage extends StatefulWidget {
  MatchPage({Key key, this.userId, this.post}) : super(key: key);
  final String userId;
  final DocumentSnapshot post;
  @override
  _MatchPageState createState() => _MatchPageState(userId: userId, post: post);
}

class _MatchPageState extends State<MatchPage> {
  _MatchPageState({Key key, this.userId, this.post});
  final String userId;
  final DocumentSnapshot post;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();
  TextEditingController _countController = new TextEditingController(text: '2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('建立配對')),
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
                    labelText: '為你的配對加入介紹吧',
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
                      'Step 2  分組設置',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '說明：',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text('此模式能夠由主辦方啟動或重啟\n隨機配對會依照組別人數將報名方隨機分組，無法整除則會另成一組')
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  controller: _countController,
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    labelText: '人數 /組',
                  ),
                  validator: (value) => value.isEmpty ? '*人數必填*' : null,
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
                            'type': "配對模式",
                            'title': _titleController.text,
                            'content': _contentController.text,
                            'count': _countController.text,
                            'activityId': post.documentID,
                            'list': [],
                            'matchComplete': false,
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
}
