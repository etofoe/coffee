import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading.dart';

class Register extends StatefulWidget {
  final  Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //Text field state

  String email = '';
  String name = '';
  String password = '';
  String passconfirm = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign Up'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: (){
            widget.toggleView();

            },
          )
        ]
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  CircleAvatar(radius: 40,
                    backgroundImage: AssetImage('assets/coffee.png'),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: textInputDecoration,
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val){
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    obscureText: false,
                    validator: (val) => val.isEmpty ? 'Enter your name' : null,
                    onChanged: (val){
                      setState(() => name = val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val.length < 8 ? 'Password should be at least 8 characters' : null,
                    onChanged: (val){
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Confirm Password'),
                    obscureText: true,
                    validator: (val) => val!=password  ? 'Passwords do not match' : null,
                    onChanged: (val){
                      setState(() => passconfirm= val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  ElevatedButton(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                       if(_formKey.currentState.validate()){
                         setState(() => loading = true);
                          dynamic result = await _auth.registerWithEmailandPassword(email, password, name);
                          if(result == null){
                            setState(() {
                              error = 'Please supply valid email';
                              loading = false;
                            });
                          }
                       }
                    },
                  ),
                  SizedBox(height: 12.0,),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
