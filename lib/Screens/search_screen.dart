import 'package:chat/Database/chat_cloud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/controllers.dart';
import '../Utils/widgets.dart';

class SearchScreen extends StatelessWidget{
  final SearchFilterController searchController= Get.put(SearchFilterController());
  final SearchListController searchListController= Get.put(SearchListController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return SafeArea(top: false,child: Scaffold(
      appBar: AppBar(
        title: Text("Search User"),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("Search By "),
                Obx(() {
                  return Radio<String>(value: "number", groupValue: searchController.groupValue.value, onChanged: (value) {
                    searchController.groupValue.value = value!;

                  },);
                },),
                Text("Mobile Number"),
                Obx(() {
                  return Radio<String>(value: "email", groupValue: searchController.groupValue.value, onChanged: (value) {
                    searchController.groupValue.value = value!;
                  },);
                },),
                Text("Email"),

              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Obx(() {
                    return searchController.groupValue.value == "number"? customMobileNumber(controller: _mobileNumberController):customEmail(controller: _emailController);

                  },),
                ),
                GestureDetector(onTap: () async {
                 if(searchController.groupValue.value == "number"){
                   final result =await searchUserByMobile(mobile: _mobileNumberController.text.trim());
                   if(result !=null){
                     searchListController.searchResult.addAll(Map<String, dynamic>.from(result.value as Map));
                   }
                 }else {
                   final result =await searchUserByEmail(email: _emailController.text.trim());
                   if(result !=null){
                     searchListController.searchResult.addAll(Map<String, dynamic>.from(result.value as Map));
                   }
                 }
                }, child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue,
                  ),
                  child: Icon(Icons.search, size: 30, color: Colors.white,),
                ),),
              ],
            ),
            SizedBox(height: 10,),
            Obx(() {

              return searchListController.searchResult.isEmpty? Text("No User found"): ListTile(
                  onTap: () {
                    Get.toNamed("/chat", arguments: {"user": searchListController.searchResult});
                  },
                  tileColor: Colors.white,
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(50),

                    ),
                    child: Icon(Icons.person, color: Colors.white,size: 35,),
                  ),
                  title: Text(searchListController.searchResult["username"], style: TextStyle( fontWeight: FontWeight.bold),),
                  subtitle: Text(searchListController.searchResult["mobile"], style: TextStyle(color: Colors.grey.shade500),),
                  trailing: Text("Online", style: TextStyle(color: Colors.green),));
            },
            )
          ],
        ),
      ),
    ));
  }
  
}