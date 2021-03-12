import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maxim_caht_firebase/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  bool _isLoading;

  AuthForm(this.submit, this._isLoading);

  final void Function(String email, String password, String userName,File imgFile,
      bool isLogin, BuildContext con) submit;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File userImageFile;

  void _checkImagPicked(File imgPick) {
    userImageFile = imgPick;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("please pick an image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submit(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_checkImagPicked),
                TextFormField(
                  key: ValueKey('email'),
                  autocorrect: false,
                  textCapitalization:TextCapitalization.none,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                  ),
                  onSaved: (value) {
                    _userEmail = value;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
                SizedBox(height: 12),
                if (widget._isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!widget._isLoading)
                  ElevatedButton(
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                    onPressed: _trySubmit,
                  ),
                ElevatedButton(
                  //textColor: Theme.of(context).primaryColor,
                  child: Text(_isLogin
                      ? 'Create new account'
                      : 'I already have an account'),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
