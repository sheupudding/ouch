import 'package:flutter/material.dart';

class ListViewSearch extends StatefulWidget {
  _ListViewSearchState createState() => _ListViewSearchState();
}

class _ListViewSearchState extends State<ListViewSearch> {
  TextEditingController _textController = TextEditingController();

  final List<String> _listViewData = [
    "吉他",
    "遊戲",
    "嘟嘟嘟",
    "啵啵",
    "美麗好煩",
    "Ouch",
    "葛格",
    "abcd",
    "xyz",
  ];

  List<String> _newData = [];

  _onChanged(String value) {
    setState(() {
      _newData = _listViewData
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: <Widget>[
          // SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                // border: 
              ),
              onChanged: _onChanged,
            ),
          ),
          SizedBox(height: 20.0),
          _newData != null && _newData.length != 0
              ? Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(10.0),
                    children: _newData.map((data) {
                      return ListTile(title: Text(data));
                    }).toList(),
                  ),
                )
              : SizedBox(),
        ],
    );
  }
}