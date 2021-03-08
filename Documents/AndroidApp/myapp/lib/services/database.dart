
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/User.dart';
import 'package:myapp/models/brew.dart';
import 'package:flutter/material.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid  } );

  //Collection  reference
  final CollectionReference brewCollection  = FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name' : name,
      'strength' : strength
    });
  }

//brew list from snapshot

List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Brew(
        name: doc.data()['name']?? '',
        strength: doc.data()['strength'] ?? '',
        sugars: doc.data()['sugars'] ?? '0'
      );
    }).toList();
}

UserData _userDatafromSnaphot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      sugars: snapshot.data()['sugars'],
      strength: snapshot.data()['strength']
    );
}

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  Stream<UserData> get userData{
    return brewCollection.doc(uid).snapshots()
    .map(_userDatafromSnaphot);
  }
}