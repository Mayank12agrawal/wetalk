import "package:flutter/material.dart";
import 'package:we_talk/widgets/user_image_picker.dart';
import 'dart:io';

class AuthWidget extends StatefulWidget {
  final void Function(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) submitFn;
  bool isLoading;

  AuthWidget(this.submitFn, this.isLoading);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _password = '';
  File _userimagefile;
  void imagefn(File image) {
    _userimagefile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userimagefile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('please pick a image..'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _password.trim(), _userName.trim(),
          _userimagefile, _isLogin, context);
      print(_password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(imagefn),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please Enter a Valid Email Address';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return "Please enter at least 4 characters";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value;
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return "Password must be 7 character long";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    child: Text(_isLogin ? "Login" : "Sign Up"),
                    onPressed: _trySubmit,
                  ),
                if (!widget.isLoading)
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin ? "Create New Account" : "Login Here",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
