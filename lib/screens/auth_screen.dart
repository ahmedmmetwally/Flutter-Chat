import 'package:flutter/material.dart';
import "../widgets/auth_form.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:io";
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/AuthScreen";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading=false;

  void _submitAuthForm(String email, String password, String userName,File imgFile,
      bool isLogin, BuildContext con)
  async{
    UserCredential _userCredential;
    try{
      setState((){
        _isLoading=true;
      });
      if (isLogin) {
        _userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        _userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final Reference ref=FirebaseStorage.instance.ref().child("userImage").child(_userCredential.user.uid +".jpg");
        await ref.putFile(imgFile);
        final imgUrl=await ref.getDownloadURL();
        FirebaseFirestore.instance.collection("users").doc(_userCredential.user.uid)
        .set({"userName":userName,"email":email,"imgUrl":imgUrl});
        setState((){
          _isLoading=false;
        });
    }}on FirebaseAuthException catch(err){
        var _message="an error accurred ,pleaes check your email and password";
        if(err.message!=null){
          _message=err.message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:Text(_message),backgroundColor:Theme.of(con).errorColor
          ),
        );
        print(_message);
        setState((){
          _isLoading=false;
        });
    }catch(error){print (error); setState((){
      _isLoading=false;
    });}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      body: AuthForm(_submitAuthForm,_isLoading),
    );
  }
}
