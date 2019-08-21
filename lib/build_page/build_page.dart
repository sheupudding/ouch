import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import './date_time_picker.dart';
import './google_maps.dart';
import './price_picker.dart';
import './test_googlemaps.dart';

String _currentIntValue = "0";
String a = "0";

class BuildActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          centerTitle: true, title: new Text("Ouch!"), actions: <Widget>[]),
      body: BuildForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('button click');
        },
        child: new Text('SAVE', maxLines: 1),
      ),
    );
  }
}

class BuildForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuildState();
  }
}

class BuildState extends State<BuildForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _intro = '';
  String _limit = '';
  String _price = '';

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: 1,
      itemBuilder: (context, rownumber) {
        return new Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(1.0),
                  width: 500.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                  ),
                  child: new Center(
                    child: new IconButton(
                      icon: new Icon(
                        Icons.add_a_photo,
                        size: 40.0,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                new TextFormField(
                  style: TextStyle(fontSize: 30.0),
                  decoration: InputDecoration(
                    labelText: '活動名稱',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '*必填* 請輸入文字';
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                ),
                new TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: '介紹',
                    hintText: '介紹你的活動吧！',
                  ),
                  onSaved: (value) {
                    setState(() {
                      _intro = value;
                    });
                  },
                ),
                new Container(
                  height: 20.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      '活動地點',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: new IconButton(
                        icon: Icon(Icons.map),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new PlaceMarkerPage()));
                        },
                      ),
                    ),
                  ],
                ),
                // new PlaceMarkerPage(),
                new Container(
                  height: 20.0,
                ),
                new Text(
                  '活動時間',
                  style: TextStyle(fontSize: 15.0),
                ),
                new Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: TimePicker(),
                ),
                new Container(
                  height: 20.0,
                ),
                new Text(
                  '活動細節',
                  style: TextStyle(fontSize: 15.0),
                ),
                new Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '人數上限',
                        ),
                        // validator: (value) {
                        //   if (value.isEmpty) {
                        //     return '';
                        //   }
                        // },
                        onSaved: (value) {
                          setState(() {
                            _limit = value;
                          });
                        },
                      ),
                      // new TextFormField(
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     labelText: '票價',
                      //   ),
                      //   // validator: (value) {
                      //   //   if (value.isEmpty) {
                      //   //     return '';
                      //   //   }
                      //   // },
                      //   onSaved: (value) {
                      //     setState(() {
                      //       _price = value;
                      //     });
                      //   },
                      // ),
                      new PricePicker(),
                      new RaisedButton(
                        child: new Text("$a 元"),
                        onPressed: () {
                          showPickerNumber(context);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    child: Text('ACTIVE',
                        style: new TextStyle(
                          color: Colors.white,
                        )),
                    color: Colors.blue,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

showPickerNumber(BuildContext context) {
  new Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          begin: 0,
          end: 99,
          columnFlex: 1,
        ),
        NumberPickerColumn(begin: 00, end: 99, columnFlex: 3),
      ]),
      columnPadding: EdgeInsets.all(8),
      // delimiter: [
      //   PickerDelimiter(
      //       child: Container(
      //     width: 15.0,
      //     alignment: Alignment.center,
      //     child: Text(','),
      //   ))
      // ],
      hideHeader: true,
      title: new Text("票價"),
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        print(picker.getSelectedValues());
        a = picker.getSelectedValues().toString();
      }).showDialog(context);
      
}
