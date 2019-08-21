import 'package:flutter/material.dart';

var questionNumber = 0;
var quiz = new Quiz();

class Quiz {
  var choicespercent = [
    ["50%", "10%", "20%", "20%"],
    ["5人", "1人", "2人", "2人"],
  ];
  var correctAnswers = ["土"];
}

class EngagedInteract extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0.0,
        title: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                BackButton(),
                Text(quiz.choicespercent[0][0]),
                Text(quiz.choicespercent[1][0]),
              ],
            ),
            Divider(),
          ],
        ),
        content: new SingleChildScrollView(
            child: new Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: new Column(
            children: new List.generate(
                5,
                (index) => new Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.all(20),
                        child: new Text(
                          "data",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )),
          ),
        )));
  }
}
