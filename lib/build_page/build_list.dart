import 'package:flutter/material.dart';
import '../main.dart';
import '../bottom_part.dart';
import '../build_page/build_page.dart';
import './build_cell.dart';

class BuildList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: new Text("建立的活動"), actions: <Widget>[
        new TopBar(),
      ]),
      body: new BuildCell(),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('add');
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new BuildActivity(),
                ));
          },
          icon: new Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: new Text('建立', maxLines: 1),
        ),
      bottomNavigationBar: BottomAppBar(
        child: new BottomPart(),
      ),
    );
  }
}
