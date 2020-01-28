import 'package:flutter/material.dart';

class BuildBottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      labelStyle: TextStyle(
        fontSize: 10.0,
      ),
      tabs: [
        Tab(icon: new Icon(Icons.dashboard), text: ('活動')),
        Tab(
          icon: Icon(Icons.insert_chart),
          text: ('情況掌握'),
        ),
        Tab(
          icon: Icon(Icons.perm_contact_calendar),
          text: ('報名篩選'),
        ),
        Tab(
          icon: new Icon(Icons.filter_center_focus),
          text: ('活動代碼'),
        ),
        Tab(
          icon: Icon(Icons.photo),
          text: ('相簿'),
        ),
      ],
      labelColor: Colors.amber[800],
      unselectedLabelColor: Colors.blue,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Colors.red,
    );
  }
}
