import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:maxim_caht_firebase/widgets/chat/message_bubble.dart';

class Messages extends StatefulWidget {

//  Messages({this.currentUser});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    // TODO: implement initState
    getUserId();
    super.initState();
  }
  String currentUser="";
  Future<void> getUserId()async{
    currentUser=await FirebaseAuth.instance.currentUser.uid;
  }
  @override
  Widget build(BuildContext context) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapChats) {
            if (snapChats.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final snapChatsData = snapChats.data.docs;
            return ListView.builder(
                reverse: true,
                itemCount: snapChatsData.length,
                itemBuilder: (context, index) =>
                    MessageBubble(snapChatsData[index]["text"],snapChatsData[index]["userId"],snapChatsData[index]["userImage"],
                        snapChatsData[index]["userId"]==currentUser,snapChatsData[index]["userName"],));
          },
        );
     // },
   // );
  }
}
