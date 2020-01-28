import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth{
  Future<String> signInWithEamilAndPassword(String email,String password);
  Future<String> createUserWithEmailAndPassword(String email,String password,String displayName);
  Future<String> currentUserId();
  Future<FirebaseUser> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{
  Future<String> signInWithEamilAndPassword(String email,String password) async{
    FirebaseUser user = (await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: email, password: password))
              .user;
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email,String password, String displayName) async{
    FirebaseUser user = (await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: email, password: password))
              .user;
    Firestore.instance.collection('users').document().setData({ 'userid': user.uid, 'email': email, 'displayName': displayName });
    return user.uid;
  }

  Future<String> currentUserId() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<FirebaseUser> currentUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  Future<void> signOut() async{
    return FirebaseAuth.instance.signOut();
  }
}