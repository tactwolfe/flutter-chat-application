
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance; //this will give us instance of firebaseauth object which will be used to login and signup user

  void _submitAuthForm( 
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
    ) async {

      AuthResult authResult;

  try{    //login method
      if(isLogin){ 
       authResult= await _auth.signInWithEmailAndPassword(
         email: email, 
         password: password
        );
      }

      //signup method
      else{
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
      }
    }on PlatformException catch (err){ //platformexception error are authentication error
      var message = "An Error occurred ,please check ypur credentials";

      if(err.message != null){ //if error exist
        message = err.message;
      }

      //to show a snackbar with error message if some error occurred
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.black,
          ));
    }
    catch(err){
      print(err);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:AuthForm(_submitAuthForm),
      
    );
  }
}