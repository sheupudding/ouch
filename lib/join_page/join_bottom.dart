import 'package:flutter/material.dart';

class JoinBottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      labelStyle: TextStyle(
        fontSize: 10.0,
      ),
      tabs: [
        Tab(icon: new Icon(Icons.art_track), text: ('活動')),
        Tab(
          icon: Icon(Icons.payment),
          text: ('線上繳費'),
        ),
        Tab(
          icon: new Icon(Icons.filter_center_focus),
          text: ('活動代碼'),
        ),
        Tab(
          icon: new Icon(Icons.local_activity),
          text: ('報到'),
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
