import 'package:flutter/material.dart';
import 'package:myapp/models/User.dart';
import 'package:myapp/screens/authenticate/authenticate.dart';
import 'package:myapp/screens/authenticate/sign_in.dart';
import 'package:myapp/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if(user == null){
      return Authenticate();
    }
    else{
      return Home();
    }
    //return Home or authenticate
  }
}
