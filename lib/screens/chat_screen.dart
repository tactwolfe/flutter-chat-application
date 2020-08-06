//this widget will work as our chat screen

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        actions: <Widget>[
          DropdownButton(
            icon:Icon(Icons.more_vert ,color:Theme.of(context).primaryIconTheme.color ,) ,
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8,),
                    Text("Logout"),
                  ],),
                ),
                value: 'logout', //this will give this dropdownmenu item and unique identifier
              )
            ], 
            onChanged: (itemIdentifier){ //function that sign out the user
              if(itemIdentifier == "logout"){
                  FirebaseAuth.instance.signOut();
              }
            }
            )
        ],
        
        ),
      body: StreamBuilder(  //this class is used to get stream of data that changes in real time we use this to fetch realtime data from our database and load it into our screen to initiate the realtime chat
          stream: Firestore.instance //this agrument is used to get stream of data from our database
              .collection('chats/qmQgG0lgDfmNAPebNkbe/messages')
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if(streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            final documents = streamSnapshot.data.documents;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, i) => Container(
                padding: EdgeInsets.all(8),
                child: Text(documents[i]['text']),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance.collection('chats/qmQgG0lgDfmNAPebNkbe/messages').add({
            'text' : "This was added by clicking the button"
          });
        },
      ),
    );
  }
}
