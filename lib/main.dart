import 'package:chat/Database/authentication.dart';
import 'package:chat/Screens/chat.dart';
import 'package:chat/Screens/home.dart';
import 'package:chat/Screens/login.dart';
import 'package:chat/Screens/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Screens/search_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}
String route() {
  if(Authentication().user != null){
    return "/";
  }else{
    return "/login";
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp (
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: route(),
      getPages: [
        GetPage(name: "/registration", page:() =>  Registration(),),
        GetPage(name: "/login", page:() =>  Login(),),
        GetPage(name: "/", page:() =>  HomePage(),),
        GetPage(name: "/chat", page:() =>  ChatPage(),),
        GetPage(name: "/searchScreen", page:() =>  SearchScreen(),),
      ],
    );
  }
}

