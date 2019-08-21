import 'package:flutter/material.dart';
import './activity_cell.dart';
// import './bottom_part.dart';
import './join_page/join_cell.dart';
import './build_page/build_page.dart';
import './build_page/build_cell.dart';
import './profile_page/profile_page.dart';
import './filter.dart';
import './collect_page/collect_cell.dart';
import './animated_bottombar.dart';

void main() => runApp(OuchApp());

class OuchApp extends StatefulWidget {
  final List<BarItem> barItems = [
    BarItem(
      text: "首頁",
      iconData: Icons.home,
      color: Colors.indigo,
    ),
    BarItem(
      text: "報名的活動",
      iconData: Icons.local_activity,
      color: Colors.pinkAccent,
    ),
    BarItem(
      text: "建立的活動",
      iconData: Icons.flag,
      color: Colors.yellow.shade900,
    ),
    BarItem(
      text: "珍藏的活動",
      iconData: Icons.star,
      color: Colors.teal,
    ),
    BarItem(
      text: "個人",
      iconData: Icons.perm_identity,
      color: Colors.teal,
    ),
  ];
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<OuchApp> with SingleTickerProviderStateMixin {
  int selectedBarIndex = 0;
  final List<Tab> myTabs = <Tab>[
    new Tab(
      child: new ActivityCell(),
    ),
    new Tab(
      child: new JoinCell(),
    ),
    new Tab(
      child: new BuildCell(),
    ),
    new Tab(
      child: new CollectCell(),
    ),
    new Tab(
      child: new ProfilePage(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: new Text("Ouch!"),
          actions: <Widget>[
            new TopBar(),
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () {
                  print('search');
                },
              );
            },
          ),
        ),
        body: AnimatedContainer(
          // color: widget.barItems[selectedBarIndex].color,
          duration: const Duration(milliseconds: 300),
          child: new Container(
            height: 1200,
            child: myTabs[selectedBarIndex],
          ),
        ),
        bottomNavigationBar: AnimatedBottomBar(
            barItems: widget.barItems,
            animationDuration: const Duration(milliseconds: 150),
            barStyle: BarStyle(fontSize: 10.0, iconSize: 25.0),
            onBarTap: (index) {
              setState(() {
                selectedBarIndex = index;
              });
            }),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      new Filter(),
      new IconButton(
        icon: new Icon(Icons.notifications),
        onPressed: () {
          print('oh!');
        },
      ),
    ]);
  }
}

class Floating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print('add');
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new BuildActivity()));
        });
  }
}

// class BottomBarNavigationPattern extends StatefulWidget {
//   final List<BarItem> barItems = [
//     BarItem(
//       text: "首頁",
//       iconData: Icons.home,
//       color: Colors.indigo,
//     ),
//     BarItem(
//       text: "報名的活動",
//       iconData: Icons.local_activity,
//       color: Colors.pinkAccent,
//     ),
//     BarItem(
//       text: "建立的活動",
//       iconData: Icons.flag,
//       color: Colors.yellow.shade900,
//     ),
//     BarItem(
//       text: "珍藏的活動",
//       iconData: Icons.star,
//       color: Colors.teal,
//     ),
//     BarItem(
//       text: "個人",
//       iconData: Icons.perm_identity,
//       color: Colors.teal,
//     ),
//   ];

//   @override
//   _BottomBarNavigationPatternState createState() =>
//       _BottomBarNavigationPatternState();
// }

// class _BottomBarNavigationPatternState
//     extends State<BottomBarNavigationPattern> {
//   int selectedBarIndex = 0;
//   final List<Tab> myTabs = <Tab>[
//     new Tab(child: new ActivityCell(),),
//     new Tab(child: new JoinCell(),),
//     new Tab(child: new BuildCell(),),
//     new Tab(child: new CollectCell(),),
//     new Tab(child: new ProfilePage(),),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//               centerTitle: true,
//               title: new Text("Ouch!"),
//               actions: <Widget>[
//                 new TopBar(),
//               ],
//               leading: Builder(
//                 builder: (BuildContext context) {
//                   return new IconButton(
//                     icon: new Icon(Icons.search),
//                     onPressed: () {
//                       print('search');

//                       // ListViewSearch();
//                     },
//                   );
//                 },
//               ),
//             ),
//       body: myTabs[selectedBarIndex],
//       bottomNavigationBar: AnimatedBottomBar(
//           barItems: widget.barItems,
//           animationDuration: const Duration(milliseconds: 150),
//           barStyle: BarStyle(
//             fontSize: 10.0,
//             iconSize: 25.0
//           ),
//           onBarTap: (index) {
//             setState(() {
//               selectedBarIndex = index;
//             });
//           }),
//     );
//   }
// }

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:
          AppBar(centerTitle: true, title: new Text("Ouch!"), actions: <Widget>[
        new IconButton(
            icon: new Icon(
              Icons.account_circle,
              size: 40.0,
            ),
            // icon: new Image.asset('images/icons/profile.png'),
            // tooltip: 'Closes application',
            onPressed: () {
              print('hello');
              // setState(() {
              // //  _isLoading = false;
              // });
            }),
      ]),
    );
  }
}
