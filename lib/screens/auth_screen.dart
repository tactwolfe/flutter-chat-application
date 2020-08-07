
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../widget/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance; //this will give us instance of firebaseauth object which will be used to login and signup user

  var _isLoading = false;
  
  
  void _submitAuthForm( //function that calls login and signup method
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
    ) async {

      AuthResult authResult;

  try{ //login method

      setState(() {
        _isLoading = true;
      });

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

        //this method will create and new bucket in our firebase storage with name user_image inside of which we can store our image with the name of our user id aith .jpg extention which is the default extensionm of all the image we take from our phone
        final ref = FirebaseStorage.instance.ref()
        .child('user_image')
        .child(authResult.user.uid +".jpg");

        await ref.putFile(image).onComplete;  //this will upload our image onto firebase storage

        final url = await ref.getDownloadURL(); //this will give url of our uploaded image in our firebase storage
        

        //this method is used to store extra user data inside a collection with a document having id same as user id & the info stored is username and email 
        await Firestore.instance.collection('users')
        .document(authResult.user.uid)
        .setData({
          'username':username,
          'email':email,
          'image_url':url,
        });
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

          setState(() {
            _isLoading = false;
          });
    }
    catch(err){
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:AuthForm(_submitAuthForm ,_isLoading),
      
    );
  }
}