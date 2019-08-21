import 'package:flutter/material.dart';
import '../interact_page/build_question_choices.dart';
import '../interact_page/build_question_text.dart';

class InteractDetail extends StatefulWidget {
  @override
  _InteractState createState() => _InteractState();
}

class _InteractState extends State<InteractDetail> {
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
            itemCount: 3,
          ),
        ),
      ),
      floatingActionButton: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // new FloatingActionButton.extended(
          //   shape: CircleBorder(),
          //   heroTag: null,
          //   onPressed: () {},
          //   label: new Column(
          //     children: <Widget>[
          //       Text('關閉', maxLines: 1),
          //       Text('互動', maxLines: 1),
          //     ],
          //   ),
          // ),
          // new Container(
          //   width: 0,
          //   height: 10,
          // ),
          new FloatingActionButton.extended(
            shape: CircleBorder(),
            onPressed: () {
              print('submit');
            },
            label: new Column(
              children: <Widget>[
                Text('關閉', maxLines: 1),
                Text('互動', maxLines: 1),
              ],
            ),
          )
        ],
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
                            new Container(
                              padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              child: new Text("參加人數  5/12",
                                  style: new TextStyle(
                                    color: Colors.white,
                                  )),
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
                          child:
                              itemIndex == 1 ? new Choices() : new InputText()),
                    ],
                  ))),
    );
  }
}
