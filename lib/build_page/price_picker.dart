import 'dart:async';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class PricePicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PricePickerState();
  }
}

class PricePickerState extends State<PricePicker> {
  String _ticket = "";
  int _currentIntValue = 0;
  NumberPicker pricePicker;

  @override
  Widget build(BuildContext context) {
    // pricePicker = new NumberPicker.integer(
    //   minValue: 0,
    //   maxValue: 100,
    //   step: 10,
    //   initialValue: _currentIntValue,
    //   infiniteLoop: true,
    // );

    return new Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: new TextFormField(
            decoration: InputDecoration(
              labelText: '票名',
            ),
            onSaved: (value) {
              setState(() {
                _ticket = value;
              });
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: new RaisedButton(
            color: Colors.purple[50],
            textColor: Colors.purple,
            onPressed: () => _showPriceDialog(),
            child: new Text("票價\$ $_currentIntValue"),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(),
        ),
      ],
    );
  }

  Future _showPriceDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 100,
          step: 10,
          initialIntegerValue: _currentIntValue,
          infiniteLoop: true,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => _currentIntValue = value);
        pricePicker.animateInt(value);
      }
    });
  }
}

//   Future _showPriceDialog() async {
//     await showDialog<double>(
//       context: context,
//       builder: (BuildContext context) {
//         return new NumberPicker.decimal(
//           initialValue: 0,
//           minValue: 0,
//           maxValue: 15,
//           decimalPlaces: 2,
//           onChanged: (value) => setState(() => _currentIntValue = value),
//         );
//       },
//     ).then((num value) {
//       if (value != null) {
//         setState(() => _currentIntValue = value);
//         pricePicker.animateInt(value);
//       }
//     });
//   }
// }
