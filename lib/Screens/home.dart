import 'package:chat/Database/authentication.dart';
import 'package:chat/Utils/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Database/chat_cloud.dart';

class HomePage extends StatelessWidget{
  final TextEditingController _searchController = TextEditingController();
  final database = FirebaseDatabase.instance.ref();
  final String uid1 = Authentication().user!.uid;


  @override
  Widget build(BuildContext context) {
    return SafeArea( top: false ,child: Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: customSearch(controller: _searchController),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if(value== 'searchScreen'){
                Get.toNamed('/searchScreen');
              }
              else if(value == 'logout'){
                Authentication().signOut();
                Get.toNamed('/login');
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'searchScreen',child: Text("Search User"),),
            const PopupMenuItem<String>(value: 'logout',child: Text("Logout"),),
          ],)
        ],
      ) ,
      body: Padding(
        padding: EdgeInsets.all(10),
        child:             StreamBuilder(stream: database.child("conversation").onValue, builder: (context, snapshot) {
          if(!snapshot.hasData || snapshot.data!.snapshot.value == null){
            return Center(child: Text("No conversations"),);
          }

          final allChats = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> myChats= [];
          allChats.forEach((id, value) async {
            if(id.toString().contains(uid1)){
              final lastMessage = Map<String, dynamic>.from(value["lastMessage"] ?? {});
              final otherUid = id.toString().split("_").first == id
                  ? id.toString().split("_")[0]
                  : id.toString().split("_")[1];
              myChats.add({
                "chatId": id,
                "otherUid": otherUid,
                "lastMessage": lastMessage,
              });


            }
          },);
          myChats.sort((a, b) => (b['lastMessage']['timestamp'] ?? 0)
              .compareTo(a['lastMessage']['timestamp'] ?? 0));
          return ListView.builder( itemCount:  myChats.length,itemBuilder: (context, index) {

            return FutureBuilder(
              future: database.child("users").child(myChats[index]["otherUid"]).get(),
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData || !asyncSnapshot.data!.exists) {
                  return SizedBox();
                }

                final user = Map<String, dynamic>.from(asyncSnapshot.data!.value as Map);
                return Padding(

                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    onTap: () {
                      Get.toNamed("/chat", arguments: {'user': user});
                    },
                    tileColor: Colors.white,
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        borderRadius: BorderRadius.circular(50),

                      ),
                      child:const Icon(Icons.person, color: Colors.white,size: 35,),
                    ),
                    title: Text(user["username"], style: const TextStyle( fontWeight: FontWeight.bold),),
                    subtitle: Text(myChats[index]["lastMessage"]["text"] ?? "", style: TextStyle(color: Colors.grey.shade500),),
                    trailing: Text("Online", style:const TextStyle(color: Colors.green),),
                  ),
                );
              }
            );
          },);

        },),

      ),

    ));
  }
  }