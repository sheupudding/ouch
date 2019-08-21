import 'package:flutter/material.dart';

class BuildInteract extends StatefulWidget {
  @override
  _BuildInteractState createState() => _BuildInteractState();
}

PageController _controller = PageController(viewportFraction: 0.85);

class _BuildInteractState extends State<BuildInteract> {
  int _count = 2;
  int _interCon = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新增互動"),
      ),
      body: Center(
        child: SizedBox(
          // 高度
          height: MediaQuery.of(context).size.height * 0.8,
          child: PageView.builder(
            controller: _controller,
            itemBuilder: (context, rownumber) {
              return _buildCardItem(context, rownumber);
            },
            itemCount: _count,
          ),
        ),
      ),
      floatingActionButton: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new FloatingActionButton.extended(
            shape: CircleBorder(),
            heroTag: null,
            onPressed: () {
              print('add');
              setState(() {
                _count++;
              });
              _controller.jumpToPage(
                _count,
              );
            },
            label: new Column(
              children: <Widget>[
                Text('新增', maxLines: 1),
                Text('題目', maxLines: 1),
              ],
            ),
          ),
          new Container(
            width: 0,
            height: 10,
          ),
          new FloatingActionButton.extended(
            shape: CircleBorder(),
            onPressed: () {
              print('submit');
            },
            label: new Column(
              children: <Widget>[
                Text('發佈', maxLines: 1),
                Text('互動', maxLines: 1),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, int itemIndex) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          color: itemIndex != 0 ? Colors.blueGrey[50] : null,
          child: new Padding(
            padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
            child: itemIndex == 0
                ? new Column(
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          padding: EdgeInsets.all(0),
                          child: new TextFormField(
                            style: TextStyle(fontSize: 20.0),
                            decoration: InputDecoration(
                              labelText: '互動名稱',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return '*必填* 請輸入文字';
                              }
                            },
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new ListView(
                          padding: EdgeInsets.all(0),
                          children: <Widget>[
                            new TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(fontSize: 15.0),
                              decoration: InputDecoration(
                                labelText: '互動介紹',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '*必填* 請輸入文字';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      new Expanded(
                        flex: 3,
                        child: new ListView(
                          padding: EdgeInsets.all(0),
                          children: <Widget>[
                            new TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(fontSize: 15.0),
                              decoration: InputDecoration(
                                labelText: '互動規則',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '*必填* 請輸入文字';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text("題目方向",
                                style: new TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                )),
                            new Icon(
                              Icons.arrow_forward,
                              color: Colors.blueGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : new Column(
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
                        child: new Center(
                          child: _interCon == 0
                              ? new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new RaisedButton(
                                      child: new Text("選項式互動"),
                                      onPressed: () {
                                        setState(() {
                                          _interCon = 1;
                                        });
                                      },
                                    ),
                                    new Container(
                                      height: 0,
                                      width: 10,
                                    ),
                                    new RaisedButton(
                                      child: new Text("問答式互動"),
                                      onPressed: () {
                                        setState(() {
                                          _interCon = 2;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : _interCon == 1
                                  ? new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Expanded(
                                          flex: 5,
                                          child: new TextFormField(
                                            maxLines: null,
                                            style: TextStyle(fontSize: 20.0),
                                            decoration: InputDecoration(
                                              labelText: '請輸入題目',
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return '*必填* 請輸入文字';
                                              }
                                            },
                                          ),
                                        ),
                                        new Expanded(
                                            flex: 4,
                                            child: new ListView.builder(
                                              itemCount: 2,
                                              itemBuilder:
                                                  (context, itemnumber) {
                                                return new TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          '選項 $itemnumber'),
                                                );
                                              },
                                            )),
                                        new Expanded(
                                          flex: 1,
                                          child: new IconButton(
                                            icon: Icon(Icons.add_circle),
                                            color: Colors.grey,
                                            onPressed: () {},
                                          ),
                                          // new RaisedButton(
                                          //   color: Colors.blue,
                                          //   child: new Row(
                                          //       children: <Widget>[
                                          //         new Icon(Icons.add, color: Colors.white,),
                                          //         new Text("新增選項", style: TextStyle(color: Colors.white),)
                                          //       ]),
                                          //   onPressed: () {},
                                          // )
                                        )
                                      ],
                                    )
                                  : new Center(
                                      child: new TextFormField(
                                        maxLines: null,
                                        style: TextStyle(fontSize: 20.0),
                                        decoration: InputDecoration(
                                          labelText: '請輸入題目',
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return '*必填* 請輸入文字';
                                          }
                                        },
                                      ),
                                    ),
                        ),
                        // Positioned(
                        //     bottom: 0,
                        //     right: 0,
                        //     child: itemIndex == _count - 1
                        //         ? new Row(
                        //             children: <Widget>[
                        //               new RaisedButton(
                        //                 shape: RoundedRectangleBorder(
                        //                     borderRadius:
                        //                         new BorderRadius.circular(
                        //                             30.0)),
                        //                 color: Colors.blue,
                        //                 onPressed: () {
                        //                   print('add');
                        //                   setState(() {
                        //                     _count++;
                        //                   });
                        //                   _controller.jumpToPage(
                        //                     _count,
                        //                   );
                        //                 },
                        //                 child: new Icon(Icons.delete)
                        //                 // new Text(
                        //                 //   '刪除題目',
                        //                 //   maxLines: 1,
                        //                 //   style: TextStyle(
                        //                 //       color: Colors.white),
                        //                 // ),
                        //               ),
                        //             ],
                        //           )
                        //         : Text("")),
                      ),
                      Expanded(
                          flex: 1,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new RaisedButton(
                                  shape: CircleBorder(),
                                  color: Colors.white,
                                  onPressed: () {
                                    print('add');
                                    setState(() {
                                      _count--;
                                    });
                                    _controller.jumpToPage(
                                      _count,
                                    );
                                  },
                                  child: new Icon(
                                    Icons.delete,
                                    color: Colors.brown,
                                  )),
                              new RaisedButton(
                                  shape: CircleBorder(),
                                  color: Colors.white,
                                  onPressed: () {
                                    print('add');
                                    setState(() {
                                      _interCon = 0;
                                    });
                                  },
                                  child: new Icon(
                                    Icons.restore_page,
                                    color: Colors.brown,
                                  )),
                            ],
                          )),
                    ],
                  ),
          ),
        ));
  }
}
