

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CHat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark, //to make any contrasting color in this accent color background a bright  colour since the accent color itself is a dark one
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pink, //to define color theme of the button
            textTheme: ButtonTextTheme.primary, //to define color of button text
            shape: RoundedRectangleBorder( //to define shape of the button
              borderRadius: BorderRadius.circular(20)
            )
        )
      ),
      home: StreamBuilder( //here stream builder help us to verify authentication state of the user and thus show appropriate screen to him/her this is possible by using firebase auth in firebase sdk which automatically manages the user token that allow us to auto login 
        stream:FirebaseAuth.instance.onAuthStateChanged, //this stream will check if user authentication state is change
        builder: (ctx ,userSnapshot){
          if(userSnapshot.connectionState == ConnectionState.waiting){
            return SplashScreen();
          }
          if(userSnapshot.hasData){  //if the user is authenticated then it will show the chat screen
            return ChatScreen();
          }
          return AuthScreen(); //if the user is not authenticated it will show the auth screen
        }
        
        )
    );
  }
}

