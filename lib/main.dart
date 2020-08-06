
import 'package:flutter/material.dart';
import './screens/chat_screen.dart';
import './screens/auth_screen.dart';

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
      home: AuthScreen()
    );
  }
}

