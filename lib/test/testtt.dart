// import 'package:flutter/material.dart';

// class PositionedTiles extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => PositionedTilesState();
// }

// class PositionedTilesState extends State<PositionedTiles> {
//   List<Widget> tiles = [
//     StatelessColorfulTile(),
//     StatelessColorfulTile(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(children: tiles),
//       floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.sentiment_very_satisfied), onPressed: swapTiles),
//     );
//   }

//   swapTiles() {
//     setState(() {
//       tiles.insert(1, tiles.removeAt(0));
//     });
//   }
// }

// class StatelessColorfulTile extends StatelessWidget {
//   Color myColor;
//   @override
//   void initState() {
//     super.initState();
//     myColor = UniqueColorGenerator.getColor();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: myColor,
//         child: Padding(
//           padding: EdgeInsets.all(70.0),
//         ));
//   }
// }
