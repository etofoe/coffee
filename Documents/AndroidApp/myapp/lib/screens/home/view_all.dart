import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/User.dart';
import 'package:myapp/models/brew.dart';
import 'package:myapp/screens/home/brew_list.dart';
import 'package:myapp/screens/home/home.dart';
import 'package:myapp/screens/home/settings_form.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';


class ViewAll extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Brew>>.value(
        value: DatabaseService().brews,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.brown[50],
          appBar: AppBar(
            title: Text('My App'),
            backgroundColor: Colors.brown[400],
            elevation: 0.0,
            actions: <Widget>[

              TextButton.icon(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                  onPressed: () => _showSettingsPanel()
              ),
            ],
          ),
          body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/coffee_bg.png'),
                      fit: BoxFit.cover
                  )
              ),
              child: BrewList()
          ),
        )
    );
  }
}



