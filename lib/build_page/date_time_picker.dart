import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class TimePicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimePickerState();
  }
}

class TimePickerState extends State<TimePicker> {
  // DateTime selectedDate = DateTime.now();
  DateTime date1;
  DateTime date2;
  // Future<Null> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDatePickerMode: DatePickerMode.day,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new DateTimePickerFormField(
          inputType: InputType.both,
          format: DateFormat("'由' y/M/d ,EEEE  'at' h:mma "),
          editable: false,
          decoration:
              InputDecoration(labelText: '活動開始時間', hasFloatingPlaceholder: false),
          onChanged: (dt) {
            setState(() => date1 = dt);
            print('Selected date: $date1');
          },
        ),
        new DateTimePickerFormField(
          inputType: InputType.both,
          format: DateFormat("'至' y/M/d ,EEEE  'at' h:mma"),
          editable: false,
          decoration:
              InputDecoration(labelText: '活動結束時間', hasFloatingPlaceholder: false),
          onChanged: (dt) {
            setState(() => date1 = dt);
            print('Selected date: $date2');
          },
        ),
      ],
    );

    // new Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: <Widget>[
    //     Text("${selectedDate.toLocal()}"),
    //     new IconButton(
    //       icon: new Icon(Icons.calendar_today),
    //       onPressed: () => _selectDate(context),
    //     ),
    //   ],
    // );
  }
}
