import 'package:flutter/material.dart';
import './question_text_ans.dart';

class InputText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TextState();
  }
}

class TextState extends State<InputText>{
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text("你昨天吃什麼？", style: TextStyle(fontSize: 15),),
          new RaisedButton(
            color: Colors.white,
            child: new Text("查看回覆", style: TextStyle(color: Colors.blue),),
            onPressed: (){
              showDialog(
                context: context,
                child: QuesAnswer(),
              );
            },
          )
        ],
      ),
    );
  }
}
