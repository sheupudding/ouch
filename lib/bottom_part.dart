import 'package:flutter/material.dart';
// import './main.dart';
// import './build_page/build_list.dart';

class BottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      labelStyle: TextStyle(
        fontSize: 10.0,
      ),
      tabs: [
        Tab(icon: new Icon(Icons.home), text: ('首頁')),
        Tab(
          icon: Icon(Icons.local_activity),
          text: ('報名的活動'),
        ),
        Tab(
          icon: Icon(Icons.flag),
          text: ('建立的活動'),
        ),
        Tab(
          icon: new Icon(Icons.star),
          text: ('珍藏的活動'),
        ),
        Tab(
          icon: new Icon(Icons.perm_identity),
          text: ('個人'),
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
