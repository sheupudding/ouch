import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class QrShow extends StatefulWidget {
  QrShow({this.post});
  final DocumentSnapshot post;
  @override
  _QrShowState createState() => _QrShowState(post: post);
}

class _QrShowState extends State<QrShow> {
  _QrShowState({this.post});
  final DocumentSnapshot post;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: new TabBar(
              labelStyle: TextStyle(
                fontSize: 15.0,
              ),
              tabs: <Widget>[
                Tab(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(
                          Icons.filter_center_focus,
                          color: Colors.black,
                        ),
                        new Text(
                          '報到代碼',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                ),
                Tab(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(
                          Icons.code,
                          color: Colors.black,
                        ),
                        new Text(
                          '活動代碼',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                ),
              ],
              indicatorWeight: 4,
              indicatorColor: Colors.grey,
            ),
          ),
          body: TabBarView(children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  QrImage(
                    data: post.documentID,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  Text('報到代碼'),
                  SizedBox(
                    height: 30,
                  ),
                  OutlineButton(
                    splashColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Text("儲存QRcode",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        )),
                    onPressed: _save,
                  ),
                ],
              ),
            ),
            Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        post.documentID,
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.content_copy,
                          size: 20,
                        ),
                        onPressed: () {
                          Clipboard.setData(
                              new ClipboardData(text: post.documentID));
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text('已複製活動代碼')));
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  '活動代碼能夠直接搜尋到你的活動\n宣傳時多多使用吧！',
                  textAlign: TextAlign.center,
                )
              ],
            )),
          ])),
    );
  }

  _save() async {
    Uint8List _qrImage = await scanner.generateBarCode(post.documentID);
    final result = await ImageGallerySaver.saveImage(_qrImage);
    if (result != null) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('已儲存圖片至相簿')));
    }
  }

  // Future _scanPhoto() async {
  //   String barcode = await scanner.scanPhoto();
  //   setState(() => this.barcode = barcode);
  // }

  // Future _generateBarCode() async {
  //   Uint8List result = await scanner.generateBarCode('activityID CheckIn');
  //   this.setState(() => this.bytes = result);
  // }
}
