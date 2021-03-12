import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:maxim_caht_firebase/screens/chat_screen.dart';
import 'package:maxim_caht_firebase/screens/splash_screen.dart';
import "./screens/auth_screen.dart";
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
     super.initState();
    final FirebaseMessaging fcm=FirebaseMessaging.instance;
    fcm.requestPermission();



  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
            textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        buttonColor: Colors.pink)
      ),
      home:StreamBuilder(stream:FirebaseAuth.instance.idTokenChanges(),builder:((context,snapShot){
        if(snapShot.connectionState==ConnectionState.waiting){
         return SplashScreen();
        }
        if(snapShot.hasData){
          return ChatScreen();
        } return AuthScreen();
      }) ,),
    );
  }
}
