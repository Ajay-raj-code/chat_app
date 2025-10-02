import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Authentication with WidgetsBindingObserver{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance.ref();
  User? get user => _auth.currentUser;

  AddObserver(){
    WidgetsBinding.instance.addObserver(this);
    _setOnline();

  }

  void _setOnline() async{
    final uid= user?.uid;
    if(uid != null){
      await database.child('users').child(uid).update({
        "isOnline":true,
        "lastSeen":ServerValue.timestamp,
      });
    }
  }
  void _setOffline() async{
    final uid= user?.uid;
    if(uid != null){
      await database.child('users').child(uid).update({
        "isOnline":false,
        "lastSeen":ServerValue.timestamp,
      });
    }

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      _setOnline();
    }else {
      _setOffline();
    }
  }

  void disposeObserver(){
    WidgetsBinding.instance.removeObserver(this);
    _setOffline();
  }
  Future<bool> registration({
    required String email,
    required String password,
    required String mobileNumber,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.toLowerCase(),
            password: password,
          );
      User? user = userCredential.user;
      if (user != null) {
        user.sendEmailVerification();
        await database.child('users').child(user.uid).set({
          'email': email.toLowerCase(),
          'username': name,
          'mobile': mobileNumber,
          'uid': user.uid,
        });
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
      } else {}
      return false;
    }
  }

  Future<bool> loginWithEmail({required String email, required String password}) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email.toLowerCase(), password: password);
      return true;
    } on FirebaseAuthException catch (e){
      return false;
    }
  }

  Future<void> signOut() async {
    disposeObserver();
    await _auth.signOut();
  }
}
