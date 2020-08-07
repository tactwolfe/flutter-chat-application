//this widget will show messages from all the user on chat screen
import 'package:chat_app/widget/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder:(ctx ,futureSnapshot)
      { 
          if(futureSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
         }
        return StreamBuilder( //this class is used to get stream of data that changes in real time we use this to fetch realtime data from our database and load it into our screen to initiate the realtime chat
      
        //this agrument is used to get stream of data from our database
        stream: Firestore.instance.collection('chat').orderBy('createdAt',descending: true).snapshots(), //here we added the OrderBy constructor to fetch the message based on the time stamp they are created also makes decending true to fetch it from old to new message
        builder: (ctx , chatSnapshot) {
          if(chatSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          final chatDocs = chatSnapshot.data.documents;
          return   ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx , i)=> MessageBubble(
              chatDocs[i]['text'],
              chatDocs[i]['username'],
              chatDocs[i]['userImage'],
              chatDocs[i]['userId'] == futureSnapshot.data.uid,
              key : ValueKey(chatDocs[i].documentID), //here document id is a unique identifier associated with each document using this key avoid unneccessary rebuilding of our widget tree inside streambuilder
              
              ),
  
            );
          }
        );
      },
      
    );
  }
}