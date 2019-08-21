import 'package:flutter/material.dart';

class JoinedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text('烤肉趴'),
      ),
      body: new MyTest(),
    );
  }
}

class MyTest extends StatefulWidget {
  MyTest({Key key}) : super(key: key);

  @override
  Test createState() => Test();
}

class Test extends State<MyTest> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // Process data.
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
