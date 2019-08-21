import 'package:flutter/material.dart';
import 'dart:async';

// class Filter extends StatefulWidget{
//   @override
//   _FilterState createState() => _FilterState();
  
// }

// enum Answer{Yes,No,Maybe}

// class _FilterState extends State<Filter>{
//   String _answer ='';
//   void SetAnswer(String value){
//     setState(() {
//       _answer = value;
//     });
//   }

//   Future<Null> _askuser() async{
//     switch(
//       await showDialog(
//         context: context, child: new SimpleDialog(
//           title: new Text('Test SimpleDialog'),
//           children: <Widget>[
//             new SimpleDialogOption(
//               onPressed: (){Navigator.pop(context,Answer.Yes);},
//               child: const Text('OhYa!'),
//             ),
//             new SimpleDialogOption(
//               onPressed: (){Navigator.pop(context,Answer.No);},
//               child: const Text('OhNo!'),
//             ),
//             new SimpleDialogOption(
//               onPressed: (){Navigator.pop(context,Answer.Maybe);},
//               child: const Text('...Um...'),
//             ),
//           ],
//         )
//       )){
//       case Answer.Yes:
//         SetAnswer('yes');
//         break;
//       case Answer.No:
//         SetAnswer('no');
//         break;
//       case Answer.Maybe:
//         SetAnswer('maybe');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return null;
//   }
// }

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

enum Answer { Yes, No, Maybe }

class _FilterState extends State<Filter> {
  String _answer = '';
  void SetAnswer(String value) {
    setState(() {
      _answer = value;
    });
  }

  Future<Null> _askuser() async {
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('Test SimpleDialog'),
          children: <Widget>[
            new 
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Answer.Yes);
              },
              child: const Text('OhYa!'),
            ),
            new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Answer.No);
              },
              child: const Text('OhNo!'),
            ),
            new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Answer.Maybe);
              },
              child: const Text('...Um...'),
            ),
          ],
        ))) {
      case Answer.Yes:
        SetAnswer('yes');
        break;
      case Answer.No:
        SetAnswer('no');
        break;
      case Answer.Maybe:
        SetAnswer('maybe');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(Icons.format_align_left),
      onPressed: () {
        print('tagss');
        _askuser();
      },
    );
  }
}