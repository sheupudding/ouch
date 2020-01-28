import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
// import './price_picker.dart';
// import 'registration_form.dart';
import '../home.dart';
import '../auth.dart';
import './google_maps.dart';

// String _currentIntValue = "0";
File _image;

String a = "0";
TextEditingController _activityTitleController = new TextEditingController();
TextEditingController _introController = new TextEditingController();

TextEditingController _addressController = new TextEditingController();
TextEditingController _addressCommentController = new TextEditingController();

TextEditingController _startTimeCommentController = new TextEditingController();
TextEditingController _endTimeCommentController = new TextEditingController();

TextEditingController _limitController = new TextEditingController();
TextEditingController _lineController = new TextEditingController();

int resCount = 1;
List resItem = ['姓名', '電話', 'Email', '身分證字號', '性別', '葷素', '備註'];

class BuildActivity extends StatefulWidget {
  BuildActivity(
      {Key key,
      this.address,
      this.userId,
      this.center,
      this.auth,
      this.locateArea,
      this.locateLocal})
      : super(key: key);
  final String userId;
  final String address;
  final LatLng center;
  final BaseAuth auth;
  final String locateArea;
  final String locateLocal;
  @override
  State<StatefulWidget> createState() {
    return BuildActivityState(
      address: address,
      userId: userId,
      center: center,
      auth: auth,
      locateArea: locateArea,
      locateLocal: locateLocal,
    );
  }
}

class BuildActivityState extends State<BuildActivity> {
  BuildActivityState(
      {this.address,
      this.userId,
      this.center,
      this.auth,
      this.locateArea,
      this.locateLocal});
  final String userId;
  final String address;
  final LatLng center;
  final BaseAuth auth;
  final String locateArea;
  final String locateLocal;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          centerTitle: true, title: new Text("Ouch!"), actions: <Widget>[]),
      body: BuildForm(
        address: address,
        userId: userId,
        center: center,
        auth: auth,
        locateArea: locateArea,
        locateLocal: locateLocal,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print('button click');
      //   },
      //   child: new Text('儲存', maxLines: 1),
      // ),
    );
  }
}

class BuildForm extends StatefulWidget {
  BuildForm(
      {this.address,
      this.userId,
      this.center,
      this.auth,
      this.locateArea,
      this.locateLocal});
  final LatLng center;
  final String userId;
  final String address;
  final BaseAuth auth;
  final String locateArea;
  final String locateLocal;
  @override
  State<StatefulWidget> createState() {
    return BuildState(address, userId, center, auth, locateArea, locateLocal);
  }
}

class BuildState extends State<BuildForm> {
  BuildState(this.address, this.userId, this.center, this.auth, this.locateArea,
      this.locateLocal);
  final String address;
  final String userId;
  final LatLng center;
  final BaseAuth auth;
  final String locateArea;
  final String locateLocal;
  String userName;
  String oldLocation;

  Future<void> getNickName() async {
    await Firestore.instance
        .collection("users")
        .where('userid', isEqualTo: userId)
        .limit(1)
        .getDocuments()
        .then((doc) {
      userName = doc.documents[0]['displayName'];
    });
    if (userName == null || userName == '') {
      setState(() {
        userName = 'QQ';
        print("沒有");
      });
    } else
      print('有！');
  }

  @override
  void initState() {
    super.initState();
    getNickName();
  }

  final _formKey = GlobalKey<FormState>();

  DateTime date1;
  DateTime date2;

  int _ticketCount = 1;

  List<String> tagList = [
    "運動",
    "音樂",
    "藝術",
    "知識",
    "飲食",
    "公益",
    "聚會",
    "會議",
    "旅遊",
    "展覽",
    "表演",
    "競賽",
    "社交"
  ];
  List<String> selectedTagList = List();
  _showTagDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("填寫項目"),
            content: MultiSelectChip(
              tagList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedTagList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("確認"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Widget _selectListItem() {
    return prefix0.Row(
      mainAxisAlignment: prefix0.MainAxisAlignment.center,
      children: List.generate(selectedTagList.length, (index) {
        return prefix0.Padding(
          padding: prefix0.EdgeInsets.only(right: 2),
          child: Text(selectedTagList[index].toString() + '/'),
        );
      }),
    );
  }

  Widget activityTitle() {
    return Column(
      children: <Widget>[
        new TextFormField(
          controller: _activityTitleController,
          style: TextStyle(fontSize: 20.0),
          decoration: InputDecoration(
            labelText: '活動名稱',
          ),
          validator: (value) => value.isEmpty ? '*活動名稱必填*' : null,
          onSaved: (value) => _activityTitleController.text = value,
        ),
        new TextFormField(
          controller: _introController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            labelText: '介紹',
            hintText: '介紹你的活動吧！',
          ),
          validator: (value) => value.isEmpty ? '*請填一些介紹吧*' : null,
          // onSaved: (value) => _titleController.text = value,
        ),
      ],
    );
  }

  Widget addressPicker() {
    return new Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '活動地點',
              style: TextStyle(fontSize: 15.0),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: new RaisedButton.icon(
                color: Colors.white,
                label: new Text("選取地址",
                    style: new TextStyle(
                      color: Colors.blueGrey,
                    )),
                icon: Icon(
                  Icons.search,
                  size: 15,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new GoogleMaps(userId)));
                },
              ),
            ),
          ],
        ),
        new MapWindow(),
        new TextFormField(
          maxLines: null,
          initialValue: address != null
              ? address
              : oldLocation == null ? '' : oldLocation,
          decoration: InputDecoration(
            labelText: '地址',
          ),
          validator: (value) => value.isEmpty ? '*請由地圖搜尋填入地址*' : null,
        ),
        new TextFormField(
          controller: _addressCommentController,
          maxLines: null,
          decoration: InputDecoration(
            labelText: '地點說明補充',
          ),
        ),
      ],
    );
  }

  Widget timePicker() {
    return Column(
      children: <Widget>[
        new Text(
          '活動時間',
          style: TextStyle(fontSize: 15.0),
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new DateTimeField(
                controller: _startTimeCommentController,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                format: DateFormat("'開始時間：' y/M/d - h:mma"),
                decoration: InputDecoration(
                    labelText: '活動開始時間', hasFloatingPlaceholder: false),
                validator: (value) => value == null ? '*請選擇時間*' : null,
                onChanged: (dt) {
                  setState(() => date1 = dt);
                  print('Selected date: $date1');
                },
              ),
              new DateTimeField(
                controller: _endTimeCommentController,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                validator: (value) => value == null ? '*請選擇時間*' : null,
                format: DateFormat("'結束時間：' y/M/d - h:mma"),
                decoration: InputDecoration(
                    labelText: '活動結束時間', hasFloatingPlaceholder: false),
                onChanged: (dt) {
                  setState(() => date2 = dt);
                  print('Selected date: $date2');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detail() {
    return Column(
      children: <Widget>[
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
                    controller: _limitController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '人數上限',
                    ),
                    onSaved: (value) => _limitController.text = value,
                    validator: (value) => value.isEmpty ? '*請填人數限制吧*' : null,
                  ),
                  new TextFormField(
                    controller: _lineController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Line 轉帳代碼',
                    ),
                    onSaved: (value) => _lineController.text = value,
                  ),
                ]))
      ],
    );
  }

  Widget tags() {
    return Column(
      children: <Widget>[
        new Text(
          '活動標籤',
          style: TextStyle(fontSize: 15.0),
        ),
        SizedBox(height: 10),
        new Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    splashColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Text("選取符合的活動標籤",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        )),
                    onPressed: () => _showTagDialog(),
                  ),
                  Container(
                    height: 50,
                    child: _selectListItem(),
                  ),
                ]))
      ],
    );
  }

  Widget createRegistration() {
    return Column(
      children: <Widget>[
        new Text(
          '製作一張報名表吧',
          style: TextStyle(fontSize: 15.0),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: resItem.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                title: Text(resItem[index]),
                value: resItem[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future clearSelection() async {
    setState(() {
      _image = null;
    });
  }

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
                    child: Stack(
                      children: <Widget>[
                        _image == null
                            ? new Center(
                                child: new IconButton(
                                  icon: new Icon(
                                    Icons.add_photo_alternate,
                                    size: 40.0,
                                    color: Colors.grey,
                                  ),
                                  onPressed: chooseFile,
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                height: 200,
                                child: Image.file(_image, fit: BoxFit.fitWidth),
                              ),
                        _image != null
                            ? Positioned(
                                top: 10,
                                right: 10,
                                child: new IconButton(
                                  icon: new Icon(
                                    Icons.cancel,
                                    size: 30.0,
                                    color: Colors.blue,
                                  ),
                                  onPressed: clearSelection,
                                ),
                              )
                            : SizedBox(),
                      ],
                    )),
                // _uploadedFileURL != null
                // ? Image.network(
                //     _uploadedFileURL,
                //     height: 150,
                //   )
                // : Container(),
                activityTitle(),
                new Container(
                  height: 20.0,
                ),
                addressPicker(),
                new Container(
                  height: 20.0,
                ),
                timePicker(),
                new Container(
                  height: 20.0,
                ),

                detail(),
                new Container(
                  height: 20.0,
                ),
                tags(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: RaisedButton(
                      child: Text('下一步',
                          style: new TextStyle(
                            color: Colors.white,
                          )),
                      color: Colors.blue,
                      splashColor: Colors.blueGrey,
                      onPressed: () async {
                        // bool complete = false;
                        // String postId = '';
                        _addressController.text = address;
                        if (_formKey.currentState.validate() &&
                            _image != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registration(
                                      userId: userId,
                                      userName: userName,
                                      title: _activityTitleController.text,
                                      intro: _introController.text,
                                      center: center,
                                      address: _addressController.text,
                                      addressComment:
                                          _addressCommentController.text,
                                      startTime: date1,
                                      endTime: date2,
                                      limit: _limitController.text,
                                      line: _lineController.text==null?'':_lineController.text,
                                      image: _image,
                                      auth: auth,
                                      locateArea: locateArea,
                                      locateLocal: locateLocal,
                                      selectedTagList: selectedTagList,
                                    )),
                          );
                          // }
                        } else {
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text('欄位未完成')));
                        }
                      },
                    ),
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
      hideHeader: true,
      title: new Text("票價"),
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        print(picker.getSelectedValues());
        a = picker.getSelectedValues().toString();
      }).showDialog(context);
}

// 報名表
TextEditingController _titleController = new TextEditingController();
TextEditingController _priceController = new TextEditingController();
TextEditingController _titleController2 = new TextEditingController();
TextEditingController _priceController2 = new TextEditingController();
TextEditingController _titleController3 = new TextEditingController();
TextEditingController _priceController3 = new TextEditingController();
TextEditingController _titleController4 = new TextEditingController();
TextEditingController _priceController4 = new TextEditingController();
TextEditingController _titleController5 = new TextEditingController();
TextEditingController _priceController5 = new TextEditingController();

String _uploadedFileURL;

class Registration extends StatefulWidget {
  Registration(
      {Key key,
      this.userId,
      this.userName,
      this.title,
      this.intro,
      this.center,
      this.address,
      this.addressComment,
      this.startTime,
      this.endTime,
      this.limit,
      this.line,
      this.image,
      this.auth,
      this.locateArea,
      this.locateLocal,
      this.selectedTagList})
      : super(key: key);
  final String userId;
  final String userName;
  final String title;
  final String intro;
  final LatLng center;
  final String address;
  final String addressComment;
  final DateTime startTime;
  final DateTime endTime;
  final String limit;
  final String line;
  final File image;
  final BaseAuth auth;
  final String locateArea;
  final String locateLocal;
  final List<String> selectedTagList;
  @override
  _RegistrationState createState() => new _RegistrationState(
        userId: userId,
        userName: userName,
        title: title,
        intro: intro,
        center: center,
        address: address,
        addressComment: addressComment,
        startTime: startTime,
        endTime: endTime,
        limit: limit,
        line: line,
        image: image,
        auth: auth,
        locateArea: locateArea,
        locateLocal: locateLocal,
        selectedTagList: selectedTagList,
      );
}

class _RegistrationState extends State<Registration> {
  int ticketCount = 1;
  _RegistrationState(
      {Key key,
      this.userId,
      this.userName,
      this.title,
      this.intro,
      this.center,
      this.address,
      this.addressComment,
      this.startTime,
      this.endTime,
      this.limit,
      this.line,
      this.image,
      this.auth,
      this.locateArea,
      this.locateLocal,
      this.selectedTagList});
  final String userId;
  final String userName;
  final String title;
  final String intro;
  final LatLng center;
  final String address;
  final String addressComment;
  final DateTime startTime;
  final DateTime endTime;
  final String limit;
  final String line;
  final File image;
  final BaseAuth auth;
  final String locateArea;
  final String locateLocal;
  final List<String> selectedTagList;

  String ticketStatus = '新增票券';

  List<String> selectList = ["性別", "身分證字號", "Email", "電話", "地址", "葷素", "備註"];

  List<String> selectedReportList = List();

  List tickets = [];
  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("填寫項目"),
            content: MultiSelectChip(
              selectList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("確認"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('為你的活動建立報名表'),
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  // Text(selectedReportList[0]),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '報名表',
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: '姓名',
                        hintText: '範例顯示',
                      ),
                    ),
                  ),
                  Container(
                    height: 65.0 * selectedReportList.length,
                    child: _selectListItem(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                    splashColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Text("其他填寫項目",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        )),
                    onPressed: () => _showReportDialog(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),

                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      '票券項目',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Container(
                      height: 65.0 * ticketCount,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ticketCount,
                        itemBuilder: (context, rownumber) {
                          return _buildItem(context, rownumber);
                        },
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                    splashColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Text(ticketStatus,
                        style: TextStyle(
                          color: Colors.blueGrey,
                        )),
                    onPressed: () {
                      setState(() {
                        if (ticketCount > 4) {
                          ticketStatus = '僅能擁有5種票券';
                        } else {
                          ticketCount++;
                          if (ticketCount > 4) {
                            ticketStatus = '僅能擁有5種票券';
                          }
                        }
                      });
                      // setState(() {
                      //   result.add({'title': '會眾票', 'price': 800});
                      //   // for (var i = 0; i < result.length; i++) {
                      //   //   print(result[i].title);
                      //   // }
                      // });
                      // print(result.length);
                      // print(result);
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Divider(),

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: new RaisedButton(
                        child: Text('建立活動',
                            style: new TextStyle(
                              color: Colors.white,
                            )),
                        color: Colors.blue,
                        splashColor: Colors.blueGrey,
                        onPressed: () async {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('上傳圖片中，請稍後...')));
                          bool complete = false;
                          String postId = '';
                          StorageReference storageReference = FirebaseStorage
                              .instance
                              .ref()
                              .child('activity/${Path.basename(image.path)}}');
                          StorageUploadTask uploadTask =
                              storageReference.putFile(image);
                          await uploadTask.onComplete;
                          print('File Uploaded');
                          _uploadedFileURL = await (await uploadTask.onComplete)
                              .ref
                              .getDownloadURL();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('建立活動中...')));
                          DocumentReference docRef = await Firestore.instance
                              .collection('activity')
                              .add({
                            'title': title,
                            'introduction': intro,
                            'latitude': center.latitude,
                            'longtitude': center.longitude,
                            'address': address,
                            'localityArea': locateArea,
                            'localityLocal': locateLocal,
                            'address_comment': addressComment,
                            'start_time': startTime,
                            'end_time': endTime,
                            'people_limit': limit,
                            'line_pay': line,
                            'creator': '$userId',
                            'creatorName': '$userName',
                            'image': _uploadedFileURL,
                            'tags': selectedTagList,
                          }).whenComplete(() {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('快完成了...')));
                            complete = true;
                          });

                          if (complete == true) {
                            setState(() {
                              postId = docRef.documentID;
                            });
                            for (var i = 0; i < selectedTagList.length; i++) {
                              await Firestore.instance
                                .collection('activity')
                                .document(postId)
                                .updateData({
                                  selectedTagList[i]: true,
                                });
                            }
                            await Firestore.instance
                                .collection('resForm')
                                .document()
                                .setData({
                              'form': selectedReportList,
                              'tickets': [
                                _titleController.text != ''
                                    ? {
                                        'title': _titleController.text,
                                        'price': _priceController.text
                                      }
                                    : null,
                                _titleController2.text != ''
                                    ? {
                                        'title': _titleController2.text,
                                        'price': _priceController2.text
                                      }
                                    : null,
                                _titleController3.text != ''
                                    ? {
                                        'title': _titleController3.text,
                                        'price': _priceController3.text
                                      }
                                    : null,
                                _titleController4.text != ''
                                    ? {
                                        'title': _titleController4.text,
                                        'price': _priceController4.text
                                      }
                                    : null,
                                _titleController5.text != ''
                                    ? {
                                        'title': _titleController5.text,
                                        'price': _priceController5.text
                                      }
                                    : null,
                              ],
                              'activityId': postId,
                            }).whenComplete(() {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('快完成了...')));
                              setState(() {
                                _image = null;
                                _activityTitleController.text = '';
                                _introController.text = '';
                                _addressController.text = '';
                                _addressCommentController.text = '';
                                _startTimeCommentController.text = '';
                                _endTimeCommentController.text = '';
                                _limitController.text = '';
                                _lineController.text='';
                                _titleController.text = '';
                                _priceController.text = '';
                                _titleController2.text = '';
                                _priceController2.text = '';
                                _titleController3.text = '';
                                _priceController3.text = '';
                                _titleController4.text = '';
                                _priceController4.text = '';
                                _titleController5.text = '';
                                _priceController5.text = '';
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          userId: userId,
                                          auth: auth,
                                        )),
                              );
                            });
                            // .whenComplete(() {
                            //   Scaffold.of(context)
                            //       .showSnackBar(SnackBar(content: Text('新增完成')));
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => Registration(userId: userId, intro:_introController.text)),
                            //   );});

                            // Scaffold.of(context)
                            //         .showSnackBar(SnackBar(content: Text('新增完成')));
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('activity/${Path.basename(image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    setState(() async {
      _uploadedFileURL =
          await (await uploadTask.onComplete).ref.getDownloadURL();
    });
    // storageReference.getDownloadURL().then((fileURL) {
    //   setState(() {
    //     _uploadedFileURL = fileURL;
    //   });
    // });
  }

  Widget _selectListItem() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: selectedReportList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: selectedReportList[index],
              hintText: '範例顯示',
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int itemIndex) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                '●',
                style: TextStyle(fontSize: 8),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: new TextFormField(
              controller: itemIndex == 0
                  ? _titleController
                  : itemIndex == 1
                      ? _titleController2
                      : itemIndex == 2
                          ? _titleController3
                          : itemIndex == 3
                              ? _titleController4
                              : _titleController5,
              decoration: InputDecoration(
                labelText: '票名',
              ),
              onSaved: (value) {},
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: itemIndex == 0
                  ? new PricePicker(_priceController)
                  : itemIndex == 1
                      ? new PricePicker(_priceController2)
                      : itemIndex == 2
                          ? new PricePicker(_priceController3)
                          : itemIndex == 3
                              ? new PricePicker(_priceController4)
                              : new PricePicker(_priceController5),
            ),
          ),
        ],
      ),
    );
  }

//   Widget _buildItem(BuildContext context, int itemIndex) {
//     return Padding(
//       padding: EdgeInsets.only(left: 20, right: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: EdgeInsets.only(top: 15),
//               child: Text(
//                 '●',
//                 style: TextStyle(fontSize: 8),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: new TextFormField(
//               decoration: InputDecoration(
//                 labelText: '票名',
//               ),
//               onSaved: (value) {
//                 // _titleController.text = value;
//                 // setState(() {
//                 //   a.title = value;
//                 // });
//               },
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: EdgeInsets.only(top: 15),
//               child: new PricePicker(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class PricePicker extends StatefulWidget {
  PricePicker(this.controller);
  final TextEditingController controller;
  @override
  State<StatefulWidget> createState() {
    return PricePickerState(controller);
  }
}

class PricePickerState extends State<PricePicker> {
  PricePickerState(this.controller);
  final TextEditingController controller;
  String _price = "選擇票價";

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      // color: Colors.white,
      child: new Text(
        _price,
        style: TextStyle(fontSize: 17, color: Colors.blue),
      ),
      onPressed: () {
        showPickerDialog(context, controller);
      },
    );
  }

  showPickerDialog(BuildContext context, TextEditingController controller) {
    new Picker(
        columnFlex: [14, 5, 5, 14],
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerData), isArray: true),
        hideHeader: true,
        title: new Text("請選擇價錢"),
        onConfirm: (Picker picker, List value) {
          // print(value.toString());
          // print(picker.getSelectedValues());
          List result = picker.getSelectedValues();
          List num = picker.selecteds;
          setState(() {
            if (result[1] == "\/") {
              result[1] = "";
            }
            if (result[2] == "00" && result[1] == "") {
              _price = "免費";
              int money = 0;
              print("\$ $money");
              controller.text = money.toString();
              print(_priceController.text);
            } else {
              _price =
                  result[0] + "  " + result[1] + result[2] + "  " + result[3];
              int money = getPrice(
                  int.parse(num[1].toString()), int.parse(num[2].toString()));
              print("\$ $money");
              controller.text = money.toString();
              print(_priceController.text);

              // print(result[1]);
              // print(result[1].toString());
              // print(num[1].toString());
            }
          });
        }).showDialog(context);
  }
}

int getPrice(int hundreds, int change) {
  int price = hundreds * 100 + change;
  return price;
}

const PickerData = '''
[
    [
      "\$"
    ],
    [
        "\/",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "1\,0",
        "1\,1",
        "1\,2",
        "1\,3",
        "1\,4",
        "1\,5",
        "1\,6",
        "1\,7",
        "1\,8",
        "1\,9",
        "2\,0",
        "2\,1",
        "2\,2",
        "2\,3",
        "2\,4",
        "2\,5",
        "2\,6",
        "2\,7",
        "2\,8",
        "2\,9",
        "3\,0",
        "3\,1",
        "3\,2",
        "3\,3",
        "3\,4",
        "3\,5",
        "3\,6",
        "3\,7",
        "3\,8",
        "3\,9",
        "4\,0",
        "4\,1",
        "4\,2",
        "4\,3",
        "4\,4",
        "4\,5",
        "4\,6",
        "4\,7",
        "4\,8",
        "4\,9",
        "5\,0",
        "5\,1",
        "5\,2",
        "5\,3",
        "5\,4",
        "5\,5",
        "5\,6",
        "5\,7",
        "5\,8",
        "5\,9",
        "6\,0",
        "6\,1",
        "6\,2",
        "6\,3",
        "6\,4",
        "6\,5",
        "6\,6",
        "6\,7",
        "6\,8",
        "6\,9",
        "7\,0",
        "7\,1",
        "7\,2",
        "7\,3",
        "7\,4",
        "7\,5",
        "7\,6",
        "7\,7",
        "7\,8",
        "7\,9",
        "8\,0",
        "8\,1",
        "8\,2",
        "8\,3",
        "8\,4",
        "8\,5",
        "8\,6",
        "8\,7",
        "8\,8",
        "8\,9",
        "9\,0",
        "9\,1",
        "9\,2",
        "9\,3",
        "9\,4",
        "9\,5",
        "9\,6",
        "9\,7",
        "9\,8",
        "9\,9"
    ],
    [
        "00",
        "01",
        "02",
        "03",
        "04",
        "05",
        "06",
        "07",
        "08",
        "09",
        "10",
        "11",
        "12",
        "13",
        "14",
        "15",
        "16",
        "17",
        "18",
        "19",
        "20",
        "21",
        "22",
        "23",
        "24",
        "25",
        "26",
        "27",
        "28",
        "29",
        "30",
        "31",
        "32",
        "33",
        "34",
        "35",
        "36",
        "37",
        "38",
        "39",
        "40",
        "41",
        "42",
        "43",
        "44",
        "45",
        "46",
        "47",
        "48",
        "49",
        "50",
        "51",
        "52",
        "53",
        "54",
        "55",
        "56",
        "57",
        "58",
        "59",
        "60",
        "61",
        "62",
        "63",
        "64",
        "65",
        "66",
        "67",
        "68",
        "69",
        "70",
        "71",
        "72",
        "73",
        "74",
        "75",
        "76",
        "77",
        "78",
        "79",
        "80",
        "81",
        "82",
        "83",
        "84",
        "85",
        "86",
        "87",
        "88",
        "89",
        "90",
        "91",
        "92",
        "93",
        "94",
        "95",
        "96",
        "97",
        "98",
        "99"
    ],
    [
      "元"
    ]
]
    ''';
