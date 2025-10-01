import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance.ref();
  User? get user => _auth.currentUser;

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
    await _auth.signOut();
  }
}
