import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enterMessage = "";
  final _controller=TextEditingController();
  void sendMessage()async{
    FocusScope.of(context).unfocus();
    final userId=await FirebaseAuth.instance.currentUser;
    final userData=await FirebaseFirestore.instance.collection("users").doc(userId.uid).get();
    FirebaseFirestore.instance.collection("chats").add({
    "createdAt":Timestamp.now(),
      "text":_enterMessage,
      "userId":userId.uid,
      "userName":userData["userName"],
      "userImage":userData["imgUrl"],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _controller,
            autocorrect: true,
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: "enter message"),
            onChanged: (value) {
              setState(() {
                _enterMessage = value.trim();
              });
            },
          ),
        ),
        IconButton(color: Theme.of(context).primaryColor,icon: Icon(Icons.send), onPressed:_enterMessage.isEmpty?null:
            sendMessage)
      ],),);
  }
}
