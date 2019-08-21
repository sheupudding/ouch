import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../build_page/engaged_interact.dart';

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
                  new FlatButton(
                    padding: EdgeInsets.all(0),
                    child: new LinearPercentIndicator(
                      width: 140.0,
                      lineHeight: 37.0,
                      percent: 0.5,
                      center: Text(quiz.choices[questionNumber][0],
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.white)),
                      linearStrokeCap: LinearStrokeCap.butt,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blueGrey,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        child: EngagedInteract(),
                      );
                    },
                  ),
                  //button 1
                  new FlatButton(
                    padding: EdgeInsets.all(0),
                    child: new LinearPercentIndicator(
                      width: 140.0,
                      lineHeight: 37.0,
                      percent: 0.1,
                      center: Text(quiz.choices[questionNumber][1],
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.white)),
                      linearStrokeCap: LinearStrokeCap.butt,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blueGrey,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              new Padding(padding: EdgeInsets.all(10.0)),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new FlatButton(
                    padding: EdgeInsets.all(0),
                    child: new LinearPercentIndicator(
                      width: 140.0,
                      lineHeight: 37.0,
                      percent: 0.2,
                      center: Text(quiz.choices[questionNumber][2],
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.white)),
                      linearStrokeCap: LinearStrokeCap.butt,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blueGrey,
                    ),
                    onPressed: () {},
                  ),
                  //button 1
                  new FlatButton(
                    padding: EdgeInsets.all(0),
                    child: new LinearPercentIndicator(
                      width: 140.0,
                      lineHeight: 37.0,
                      percent: 0.2,
                      center: Text(quiz.choices[questionNumber][3],
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.white)),
                      linearStrokeCap: LinearStrokeCap.butt,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blueGrey,
                    ),
                    onPressed: () {},
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
