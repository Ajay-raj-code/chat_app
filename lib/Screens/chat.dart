import 'package:chat/Controllers/controllers.dart';
import 'package:chat/Database/authentication.dart';
import 'package:chat/Database/chat_cloud.dart';
import 'package:chat/Utils/helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget{

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final args = Get.arguments as Map<String, dynamic>;
  final String uid1 = Authentication().user!.uid;
  final TextEditingController _controller = TextEditingController();
  final database = FirebaseDatabase.instance.ref();
  final SendController _sendController = Get.put(SendController());
  late String chatId;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    chatId = generateChatId(uid1: Authentication().user!.uid, uid2: args["user"]["uid"]);
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(top: false,child: Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(spacing: 10,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(50),

              ),
              child:const Icon(Icons.person, color: Colors.white,size: 35,),
            ),
            Text(args["user"]["username"], style:const TextStyle( fontWeight: FontWeight.bold),),
          ],

        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: StreamBuilder(stream: database.child("conversation").child(chatId).onValue, builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(),);
          }
          final messagesMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
          if(messagesMap == null){
            return const Center(child: Text("No Chat Available"),);
          }

          final messages = messagesMap.entries .where((e) {
            final msg = Map<String, dynamic>.from(e.value);
            return msg['delete'] == null || msg['delete'][uid1] != true;
          }).map((e) {
            final msg = Map<String, dynamic>.from(e.value);
            msg['key'] = e.key;

            return msg;
          },).toList();

          messages.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
          return ListView.builder(itemCount: messages.length-1,itemBuilder: (context, index) {
            final message = messages[messages.length - 1 - index]; // newest at bottom
            final isMe = message['senderId'] == uid1;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: PopupMenuButton<String>(

                icon: Align(
                  alignment: isMe ? Alignment.centerRight: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: isMe ? Radius.circular(10):Radius.zero,
                        topRight:!isMe ? Radius.circular(10):Radius.zero,
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),

                    ),
                    child: Text(message['message'] ?? '',),
                  ),
                ),
                onSelected: (value) async{
                  if(value== 'delete') {
                     final result = await database.child("conversation").child(chatId).child(message["key"]).child("delete").child(uid1).set(true);
                  }
                },
                itemBuilder: (context) =>  <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'delete',child: Text("Delete"),),
                ],),
            );
          },);

        },),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left: 10),

        child: Row(
         children: [
           Expanded(
             child: TextField(
               maxLines: 1,
               onChanged: (value) {
                 if(value.isNotEmpty){
                   _sendController.status.value = true;
                 }else{
                   _sendController.status.value = false;
                 }
               },
               controller: _controller,
               decoration:const InputDecoration(
                 hintText: "Type here...",
                 border: OutlineInputBorder(borderSide: BorderSide.none),
                 focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
               ),
             ),
           ),
           GestureDetector(

             onTap: _sendController.status.value ?() async {
               if(_controller.text.isNotEmpty){

                 sendMessage(uid1: uid1, uid2: args["user"]["uid"], chatId: chatId, message: _controller.text.trim());
                 _controller.clear();
               }
             }: null,
             child: Container(
                 height: 50,
                 width: 50,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(50),
                   color: _sendController.status.value ? Colors.blue:Colors.grey.shade500
                 ),
                 child: const Icon(Icons.send, color: Colors.white,)),
           )
         ],
        ),
      ),

    ));
  }
}