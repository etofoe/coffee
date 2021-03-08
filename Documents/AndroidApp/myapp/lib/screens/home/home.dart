import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/User.dart';
import 'package:myapp/models/brew.dart';
import 'package:myapp/screens/authenticate/sign_in.dart';
import 'package:myapp/screens/home/brew_list.dart';
import 'package:myapp/screens/home/brew_tile.dart';
import 'package:myapp/screens/home/settings_form.dart';
import 'package:myapp/screens/home/view_all.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/loading.dart';
import 'package:provider/provider.dart';

// class Home extends StatelessWidget {
//
//   final AuthService _auth = AuthService();
//
//
//   @override
//
//   Widget build(BuildContext context) {
//
//     void _showSettingsPanel(){
//       showModalBottomSheet(context: context, builder: (context){
//         return Container(
//           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
//           child: SettingsForm(),
//         );
//       });
//     }
//
//     return StreamProvider<List<Brew>>.value(
//       value: DatabaseService().brews,
//       child: Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.brown[50],
//       appBar: AppBar(
//         title: Text('My App'),
//         backgroundColor: Colors.brown[400],
//         elevation: 0.0,
//         actions: <Widget>[
//           TextButton.icon(
//               icon: Icon(Icons.person),
//               label: Text('Logout'),
//               onPressed: () async {
//                 await _auth.signOut();
//                 }
//             ),
//           TextButton.icon(
//               icon: Icon(Icons.settings),
//               label: Text('settings'),
//               onPressed: () => _showSettingsPanel()
//           ),
//
//           TextButton.icon(
//               icon: Icon(Icons.search),
//               label: Text('View all'),
//               onPressed: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => ViewAll()),)
//           )
//
//          ],
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/coffee_bg.png'),
//               fit: BoxFit.cover
//             )
//           ),
//             child: BrewList()
//         ),
//       )
//     );
//   }
// }

//
class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final AuthService _auth = AuthService();
    final user = Provider.of<MyUser>(context);

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: SettingsForm(),
        );
      });
    }


    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                  title: Text('My App'),
                  backgroundColor: Colors.brown[400],
                  elevation: 0.0,
                  actions: <Widget>[
                    TextButton.icon(
                        icon: Icon(Icons.exit_to_app),
                        label: Text('Logout'),
                        onPressed: () async {
                          await _auth.signOut();
                          return SignIn();
                        }
                    ),
                    TextButton.icon(
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                        onPressed: () => _showSettingsPanel()
                    ),
                    TextButton.icon(
                        icon: Icon(Icons.search),
                        label: Text('View all'),
                        onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewAll()),)
                    )
                  ]
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/coffee_bg.png'),
                    fit: BoxFit.cover
                  )
                ),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 40,),
                          CircleAvatar(radius: 50,
                            backgroundColor: Colors.grey,
                            child:
                            Icon(
                              Icons.person,
                              color: Color(0xffCCCCCC),
                              size: 40,
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text(
                            'Welcome '+userData.name.toString(),
                            style: TextStyle(fontSize: 30, ),
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(
                              children: [
                                SizedBox(height: 30,),
                                Text('  Your current brew  ', style: TextStyle(fontSize: 20, ),),
                                SizedBox(height: 30,),
                                CircleAvatar(
                                  radius: 70,
                                  backgroundImage: AssetImage('assets/coffee_icon.png'),
                                  backgroundColor: Colors.brown[userData.strength],
                                ),
                                SizedBox(height: 20,),
                                Text('with '+userData.sugars+' sugar(s)'),
                                SizedBox(height: 30,),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

              )
          );
        }else{
          return Loading();
        }

      }
    );
  }
}
