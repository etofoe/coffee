import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/User.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading.dart';
import 'package:provider/provider.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];
  String _currentName;
  String _currentSugars;
  int _currentStrength;
  String _errorText;
  @override

  Widget build(BuildContext context) {

    final user = Provider.of<MyUser>(context);

          return StreamBuilder<UserData>(

            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, snapshot) {

              if(snapshot.hasData) {

                UserData userData = snapshot.data;

                return Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Text('Update your brew settings',
                        style: TextStyle(fontSize: 18),),
                      SizedBox(height: 20,),
                      SingleChildScrollView(
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Name'),
                          validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                          initialValue: userData.name,
                          onChanged: (val) {
                            setState(() => _currentName = val);
                          },
                        ),
                      ),
                      SizedBox(height: 20,),

                      DropdownButtonFormField(
                        value: _currentSugars ?? userData.sugars,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Select number of sugars'),
                        items: sugars.map((sugar) {
                          return DropdownMenuItem(
                            value: sugar,
                            child: Text('$sugar sugars'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _currentSugars = val);
                        },
                      ),

                      SizedBox(height: 20,),

                      Slider(
                        value: (_currentStrength ?? userData.strength).toDouble(),
                        activeColor: Colors.brown[_currentStrength ?? userData.strength],
                        inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                        min: 100.0,
                        max: 900.0,
                        divisions: 8,
                        onChanged: (val) =>
                            setState(() => _currentStrength = val.round()),
                      ),

                      SizedBox(height: 20,),

                      ElevatedButton(
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            await DatabaseService(uid: user.uid).updateUserData(
                                _currentSugars ?? userData.sugars,
                                _currentName ?? userData.name,
                                _currentStrength ?? userData.strength
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                );
              }else{
                return Loading();
              }
            }
          );
    }
  }