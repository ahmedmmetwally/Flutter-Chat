import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maxim_caht_firebase/widgets/chat/messages.dart';
import 'package:maxim_caht_firebase/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Flutter Chat"),
          actions: [
            DropdownButton(underline: Container(),icon: Icon(Icons.more_vert),items: [DropdownMenuItem(child: Container(child: Row(children: [
              Icon(Icons.logout),SizedBox(width: 10,),Text("logOut")
            ],),),value: "logOut")],
                onChanged: (itemIdentifier){if(itemIdentifier=="logOut"){FirebaseAuth.instance.signOut();}}),
          ],),
        body:Container(child:Column(children: [
          Expanded(child: Messages()),
          NewMessage(),
        ],)),
//        StreamBuilder(stream: FirebaseFirestore.instance
//            .collection("chat/mzexZ9lU1LgVnV7XMNLE/messages")
//            .snapshots() ,builder: ((context,streamSnap){
//              if(streamSnap.connectionState==ConnectionState.waiting){
//                return Center(child:CircularProgressIndicator());
//              }
//              final documents=streamSnap.data.docs;
//              return ListView.builder(itemCount: documents.length,itemBuilder: ((context,index)=>Text(documents[index]["text"])),);
//        }),),
//        floatingActionButton: FloatingActionButton(child: Icon(Icons.add,),onPressed: (){
//          FirebaseFirestore.instance.collection("chat/mzexZ9lU1LgVnV7XMNLE/messages").add({"text":"hello new addition"});
////        FirebaseFirestore.instance
////            .collection("chat/mzexZ9lU1LgVnV7XMNLE/messages")
////            .snapshots().listen((data){data.docs.forEach((element) {print(element['text']);});});
//        })
    );
  }
}
