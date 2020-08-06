import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {

  final void Function(
    String email , 
    String password , 
    String username ,
    bool isLogin,
    BuildContext ctx,
    ) submitFn; //another way of declaring a function that will have some argument and return type

  AuthForm(this.submitFn);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>(); //key of form that get us access to form state

  //----------------------these 3 are used to store user inputted values------------------------//
  
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  //----------------------these 3 are used to store user inputted values------------------------//

  var _isLogin = true;

//method that is used to save the inputted form value and authenticate them
  void _trySubmit(){
    final isValid =_formKey.currentState.validate(); //to validate the inputs in form when the submit button is pressed
    FocusScope.of(context).unfocus(); //to close the softkeyboard as soon as we submit the form

    if(isValid){
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(), //this trim constructor will remove any extra white spaces from front and back of our inputted info , we did this because without this some error will be thrown by firebase while authenticating and thus it will leads to a bad user experience
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        context
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ) ,
        elevation: 10,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, //to make sure the column only take min height it needed not all the available height
                children: <Widget>[

                  //for email
                  TextFormField(
                    key: ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ),
                    validator: (inputValue) {
                      if(inputValue.isEmpty || !inputValue.contains("@")) {
                        return 'Please Enter a Valid Email Address.';
                      }
                      return null;
                    },
                    onSaved: (inputValue){
                      _userEmail = inputValue;
                    },
                  ),

                  if(!_isLogin)
                  //for username
                  TextFormField(
                    key: ValueKey("username"),
                    decoration: InputDecoration(
                      labelText: "UserName"
                    ),
                    validator: (inputValue){
                      if(inputValue.isEmpty || inputValue.length < 4){
                        return 'Please enter atleast 4 character.';
                      }
                      return null;
                    },
                    onSaved: (inputValue){
                      _userName = inputValue;
                    },
                   
                  ),

                  //for password
                  TextFormField(
                    key: ValueKey("password"), //provide this key argumentt to remove input bug that occurs since we are adding and removing username textfromfield dynamically based on boolean value thus flutter get confused and add the value of password in username in signup mode thus we use this key argument to uniquely identify each textformfield
                    decoration: InputDecoration(
                      labelText: "Password"
                    ),
                    obscureText: true, //this will hide the text inputted by the user
                    validator:(inputValue){
                      if(inputValue.isEmpty || inputValue.length < 7){
                        return 'Password must be atleast 7 character long.';
                      }
                      return null;
                    },
                    onSaved: (inputValue){
                      _userPassword = inputValue;
                    }, 
                  ),

                  SizedBox(height: 12,),

                  //login and signup button
                  RaisedButton(
                    child: Text(_isLogin ? "Login" : "SignUp" ),
                    onPressed: (){
                      _trySubmit();
                    }
                  ),

                  //auth switch button
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_isLogin ? "Create New Account" : "I Already Have an Account" ),
                    onPressed: (){
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                      

                    }, 
                    )
                ],)
              ),
          ),
        ),
      ),
    );
  }
}
