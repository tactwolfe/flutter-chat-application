//this widget will be the textfield which will be used to send new messages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  var _enteredMessage = "";

  final _controller = new TextEditingController();

  //function to create new message
  void _sendMessage() async{
    FocusScope.of(context).unfocus(); //to change focus and close keyboard after typing
    final user = await FirebaseAuth.instance.currentUser(); //to get info about authenticated user
    
    final userData = await Firestore.instance.collection('users').document(user.uid).get();
    
    Firestore.instance.collection("chat").add({ //to add entered message into the server
      'text':_enteredMessage,
      'createdAt':Timestamp.now(), //this field will help us to fetch and display the messages in order of their time stamp
      'userId': user.uid,
      'username':userData['username'],
      'userImage' : userData['image_url']
    });
    _controller.clear(); //to clear the textfield after chat is pushed
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(top:8),
      padding: EdgeInsets.all(8),
      child: Row(children: <Widget>[
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Send a Message...."),
            onChanged: (value){
              setState(() {
                _enteredMessage = value;
              });
            },
          )
        ),
        IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.send),
          onPressed:  _enteredMessage.trim().isEmpty ? null : _sendMessage,
          
        )

      ],),
      
    );
  }
}