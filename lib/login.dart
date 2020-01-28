import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'auth.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _displayName;
  bool _formType = true;
  bool _userNotFound = false;
  bool _userPasswordNotFound = false;
  bool _userRepeated = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    _userNotFound = false;
    _userPasswordNotFound = false;
    if (validateAndSave()) {
      try {
        if (_formType) {
          String userId =
              await widget.auth.signInWithEamilAndPassword(_email, _password);
          print('Signed in: $userId');
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password, _displayName);
          print('Registered in: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        if (e.toString().startsWith('PlatformException(ERROR_USER_NOT_FOUND')) {
          setState(() {
            _userNotFound = true;
          });
        } else if (e
            .toString()
            .startsWith('PlatformException(ERROR_EMAIL_ALREADY_IN_USE')) {
          setState(() {
            _userRepeated = true;
          });
        } else {
          setState(() {
            _userPasswordNotFound = true;
          });
        }

        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    _userRepeated = false;
    formKey.currentState.reset();
    setState(() {
      _formType = false;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    _userNotFound = false;
    _userPasswordNotFound = false;
    setState(() {
      _formType = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        color: Colors.white,
        child: Center(
            child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _formType ? _logoAndLoginInputs()+_buttons() : _logoAndCreateInputs()+_buttons(),
          ),
        )),
      ),
    );
  }

  List<Widget> _logoAndLoginInputs() {
    return [
      Image(image: AssetImage("images/icons/LOGO.png"), height: 100.0),
      SizedBox(height: 50),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'Email',
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
            !EmailValidator.validate(value, true) ? '請輸入有效的Email' : null,
        // validator: (value) => value.isEmpty ? '請輸入有效Email' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return '請輸入6個字以上的密碼';
          } else {
            return null;
          }
        },
        onSaved: (value) => _password = value,
      ),
      SizedBox(height: 50),
    ];
  }

  List<Widget> _logoAndCreateInputs() {
    return [
      Image(image: AssetImage("images/icons/LOGO.png"), height: 100.0),
      SizedBox(height: 50),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'Nickname',
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value.isEmpty ? '請輸入匿名' : null,
        onSaved: (value) => _displayName = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'Email',
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
            !EmailValidator.validate(value, true) ? '請輸入有效的Email' : null,
        // validator: (value) => value.isEmpty ? '請輸入有效Email' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return '請輸入6個字以上的密碼';
          } else {
            return null;
          }
        },
        onSaved: (value) => _password = value,
      ),
      SizedBox(height: 50),
    ];
  }

  List<Widget> _buttons() {
    if (_formType) {
      return [
        OutlineButton(
          splashColor: Colors.blueGrey,
          onPressed: validateAndSubmit,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Colors.grey),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '登入',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          height: 20,
          child: _userNotFound
              ? Text(
                  '無此使用者',
                  style: TextStyle(fontSize: 15, color: Colors.redAccent),
                )
              : _userPasswordNotFound
                  ? Text(
                      '密碼錯誤',
                      style: TextStyle(fontSize: 15, color: Colors.redAccent),
                    )
                  : null,
        ),
        new FlatButton(
          child: new Text(
            '沒有帳號嗎？ 點此註冊',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        OutlineButton(
          splashColor: Colors.grey,
          onPressed: validateAndSubmit,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Colors.blue),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '註冊',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          height: 20,
          child: _userRepeated
              ? Text(
                  '帳號已被註冊',
                  style: TextStyle(fontSize: 15, color: Colors.redAccent),
                )
              : null,
        ),
        new FlatButton(
          child: new Text(
            '已有帳號嗎？ 點此登入',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}
