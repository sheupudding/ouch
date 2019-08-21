import 'package:flutter/material.dart';

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
          new TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: '輸入你的答案',
            ),
          ),
        ],
      ),
    );
  }
}
