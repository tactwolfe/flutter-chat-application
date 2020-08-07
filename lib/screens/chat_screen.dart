//this widget will work as our chat screen



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widget/chat/messages.dart';
import '../widget/chat/new_message.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
   final fbm = FirebaseMessaging(); //instantiate our firebase cloud messaging
   fbm.requestNotificationPermissions(); //this has nothing to do with android we use this because flutter needs permissions to send notification in app to user
   fbm.configure(
     onMessage: (msg){ //app on foreground or open
       print(msg);
       return;
     },
     onLaunch: (msg){   //app terminated
        print(msg);
        return;
     },
     onResume: (msg){   //app on background
      print(msg);
       return;
     }
     );
    //  fbm.getToken(); //this token will be send to the server to store it in db  and anyone one who has this token can send notification to this device
    fbm.subscribeToTopic('chat'); //any notification send to this topic will reach this device and we can target this topic with firebase admin sdk too
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        actions: <Widget>[
          DropdownButton(
            underline: Container(), //to remove that ugly grey underline in navbar near dropdown button
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Logout"),
                      ],
                    ),
                  ),
                  value:
                      'logout', //this will give this dropdownmenu item and unique identifier
                )
              ],
              onChanged: (itemIdentifier) {
                //function that sign out the user
                if (itemIdentifier == "logout") {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages()
            ),
            NewMessage()
          ],
        ),
      ),
   
    );
  }
}
