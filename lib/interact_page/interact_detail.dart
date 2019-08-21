import 'package:flutter/material.dart';
import './question_choices.dart';
import './question_text.dart';

class InteractDetail extends StatefulWidget {
  @override
  _InteractState createState() => _InteractState();
}

enum Answer { Join, UnJoin }

class _InteractState extends State<InteractDetail> {
  bool _join = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("互動名稱"),
      ),
      body: Center(
        child: SizedBox(
          // 高度
          height: MediaQuery.of(context).size.height * 0.8,
          child: PageView.builder(
            // 寬度
            controller: PageController(viewportFraction: 0.85),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, itemIndex);
            },
            itemCount: _join == false ? 1 : 3,
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
          color: itemIndex != 0 ? Colors.blueGrey[50] : null,
          // color: Colors.blueGrey[100],
          child: itemIndex == 0
              ? new Padding(
                  padding: EdgeInsets.all(15),
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                        flex: 4,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.all(20),
                              height: 100,
                              child: new Text("介紹",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            new Text(
                              "？子他向、一知企夜夠裡再物再型那明星、遠不文童民：細長性自，來多師開它上是只人樣工令公文心話被要你得養著有。為檢記朋在二自到卻標傳難出；成導爾書生大會洋金雨媽陽高越的學主！大通們古公同空那找，房教調界衣時全減也當",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      new Expanded(
                        flex: 2,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new Text(
                              "規則",
                              style: TextStyle(fontSize: 20),
                            ),
                            new Text(
                              "？子他向、一知企夜夠裡再物再型那明星、遠不文童民：細長性自，來多師開它上是只人樣工令公文心話被要你得養著有。為檢記朋在二自到卻標傳難出",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _join != true
                                ? new RaisedButton(
                                    child: new Row(
                                      children: <Widget>[
                                        new Text("參加",
                                            style: new TextStyle(
                                              color: Colors.white,
                                            )),
                                        // new Icon(
                                        //   Icons.arrow_forward,
                                        //   color: Colors.white,
                                        // ),
                                      ],
                                    ),
                                    color: Colors.blue,
                                    splashColor: Colors.blueGrey,
                                    onPressed: () {
                                      setState(() {
                                        _askjoin();
                                        // _join = true;
                                      });
                                    },
                                  )
                                : new Container(
                                    padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        new Text("已參加",
                                            style: new TextStyle(
                                              color: Colors.white,
                                            )),
                                        new Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : new Padding(
                  padding: EdgeInsets.all(10),
                  child: new Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: new Column(
                          children: <Widget>[
                            new Text(
                              "第 $itemIndex 題",
                              style: TextStyle(fontSize: 15),
                            ),
                            new Divider(),
                          ],
                        ),
                      ),
                      new Expanded(
                        flex: 9,
                        child: itemIndex == 1
                            ? new Choices()
                            : itemIndex == 2
                                ? new Stack(
                                    children: <Widget>[
                                      new InputText(),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: FloatingActionButton.extended(
                                          onPressed: () {
                                            print('submit');
                                          },
                                          label: new Text('提交', maxLines: 1),
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                      ),
                    ],
                  ))),
    );
  }

  Future<Null> _askjoin() async {
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('確定參加此互動嗎？'),
          children: <Widget>[
            new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Answer.Join);
              },
              child: const Text('確認'),
            ),
            new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Answer.UnJoin);
              },
              child: const Text('取消'),
            ),
          ],
        ))) {
      case Answer.Join:
        setState(() {
          _join = true;
        });
        break;
      case Answer.UnJoin:
        break;
    }
  }
}
