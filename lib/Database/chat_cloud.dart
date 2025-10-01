
import 'package:firebase_database/firebase_database.dart';

final dbRef = FirebaseDatabase.instance.ref();
Future<void> sendMessage({required String uid1,required String uid2 , required String chatId,required String message}) async{
  dbRef.child('conversation').child(chatId).push().set({
    "senderId":uid1,
    "receiverId":uid2,
    "message":message,
    "timestamp":ServerValue.timestamp,

  });
  await dbRef.child("conversation").child(chatId).child("lastMessage").set({
    "text": message,
    "timestamp": ServerValue.timestamp,
    "senderId": uid1,
  });

}

Future<Map<String, dynamic>?> getUserById(String uid) async {
  final dbRef = FirebaseDatabase.instance.ref();
  try {
    final snapshot = await dbRef.child("users").child(uid).get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<DataSnapshot?> searchUserByMobile({required String mobile}) async {
  try {
    final snapshot = await dbRef.child("users").orderByChild("mobile").equalTo(mobile).get();
    if (snapshot.exists && snapshot.children.isNotEmpty) {
      return snapshot.children.first; // returns the first matched user
    } else {
      return null; // no user found
    }

  }catch (e){
    return null;
  }
}
Future<DataSnapshot?> searchUserByEmail({required String email}) async {
  try {
    final snapshot = await dbRef.child("users").orderByChild("email").equalTo(email).get();
    if (snapshot.exists && snapshot.children.isNotEmpty) {
      return snapshot.children.first; // returns the first matched user
    } else {
      return null; // no user found
    }

  }catch (e){
    return null;
  }
}