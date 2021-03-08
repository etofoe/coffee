import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/User.dart';
import 'package:myapp/services/database.dart';

class AuthService{


  //create user object based on Firebase user

  MyUser _userFromFirebaseUser(User user){
    return user != null ? MyUser(uid: user.uid): null;
  }



  //anon sign in

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //auth change user stream

  Stream<MyUser> get user {
   return _auth.authStateChanges()
       // .map((User user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser);
  }

  Future signInAnon() async{
    try{
        UserCredential result = await _auth.signInAnonymously();
        User user  = result.user;
        return _userFromFirebaseUser(user);
    } catch(e){
          print(e.toString());
          return null;
    }
}

  //sign in with email and password
  Future signInWithEmailandPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print('we had: '+e.toString());
       return null;
    }
  }

  //register with email and password
  Future registerWithEmailandPassword(String email, String password,String name) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      //create a new document for the user with uid
      await DatabaseService(uid: user.uid).updateUserData('0', name, 100);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }  catch(e){
      print(e.toString());
      return null;
    }
  }
}