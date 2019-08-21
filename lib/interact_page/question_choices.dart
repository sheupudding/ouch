import 'package:flutter/material.dart';

var finalScore = 0;
var questionNumber = 0;
var quiz = new Quiz();


class Quiz {
  var choices = [
    ["Pizza", "燒肉", "拉麵", "土"],
  ];

  var correctAnswers = ["土"];
}

class Choices extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChoiceState();
  }
}

class ChoiceState extends State<Choices> {
  // final List _chosenColor = [Colors.blueGrey,Colors.orange];
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text(
            "我昨天吃什麼？",
            style: TextStyle(fontSize: 15),
          ),
          new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //button 1
                  new MaterialButton(
                    minWidth: 120.0,
                    color: Colors.blueGrey,
                    onPressed: () {
                      if (quiz.choices[questionNumber][0] ==
                          quiz.correctAnswers[questionNumber]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                    },
                    child: new Text(
                      quiz.choices[questionNumber][0],
                      style: new TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),

                  //button 2
                  new MaterialButton(
                    minWidth: 120.0,
                    color: Colors.blueGrey,
                    onPressed: () {
                      if (quiz.choices[questionNumber][1] ==
                          quiz.correctAnswers[questionNumber]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                    },
                    child: new Text(
                      quiz.choices[questionNumber][1],
                      style: new TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
              new Padding(padding: EdgeInsets.all(10.0)),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //button 3
                  new MaterialButton(
                    minWidth: 120.0,
                    color: Colors.blueGrey,
                    onPressed: () {
                      if (quiz.choices[questionNumber][2] ==
                          quiz.correctAnswers[questionNumber]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                    },
                    child: new Text(
                      quiz.choices[questionNumber][2],
                      style: new TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),

                  //button 4
                  new MaterialButton(
                    minWidth: 120.0,
                    color: Colors.blueGrey,
                    onPressed: () {
                      if (quiz.choices[questionNumber][3] ==
                          quiz.correctAnswers[questionNumber]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                    },
                    child: new Text(
                      quiz.choices[questionNumber][3],
                      style: new TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
