
import 'package:chat/Utils/constant.dart';
import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/material.dart';

Widget customEmail({required TextEditingController controller}){
  return TextFormField(
      controller:controller ,
      maxLines: 1,
      validator: (value) {
        if(value== null || value.isEmpty){
          return "Email cannot empty!";
        }
        if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
          return "Enter a valid email address";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "example@gmail.com",
        filled: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        border: ConstantStyles.border,
        focusedBorder: ConstantStyles.focusedBorder,
    label: Text("Email", style: TextStyle(color: Colors.black),),

    errorBorder: ConstantStyles.errorBorder,
  ),

  );
}
Widget customName({required TextEditingController controller}){
  return TextFormField(
    controller: controller,
    maxLines: 1,
    validator: (value) {
      if(value == null || value.isEmpty){
        "Name cannot empty!";
      }
      return null;
    },
    decoration: InputDecoration(
      hintText: "Ajay kumar",
      label: Text("Name", style: TextStyle(color: Colors.black),),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      border: ConstantStyles.border,
      focusedBorder: ConstantStyles.focusedBorder,
      errorBorder: ConstantStyles.errorBorder,

    ),
  );
}

Widget customPassword({required TextEditingController controller, required bool obscure, required String title,required VoidCallback obsecureTap}){
  return TextFormField(
    controller: controller,
    maxLines: 1,
    validator: (value) {
      if(value == null || value.isEmpty){
        "Password is required!";
      }
      return null;
    },

    obscureText: obscure,
    decoration: InputDecoration(
      hintText: title.toLowerCase(),
      label: Text(title, style: const TextStyle(color: Colors.black),),
        contentPadding:const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      border: ConstantStyles.border,
      focusedBorder: ConstantStyles.focusedBorder,
      errorBorder: ConstantStyles.errorBorder,

      suffixIcon: IconButton(onPressed: obsecureTap, icon: Icon(obscure?Icons.visibility_off:Icons.visibility))
    ),
  );
}

Widget customMobileNumber({required TextEditingController controller}){
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      label: Text("Mobile Number", style: TextStyle( color: Colors.black),),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      border: ConstantStyles.border,
      focusedBorder: ConstantStyles.focusedBorder,
      errorBorder: ConstantStyles.errorBorder,
      prefixIcon: CountryCodePicker(
        mode: CountryCodePickerMode.dialog,
        initialSelection: "IN",
        showFlag: true,
        onChanged: (value) {

        },
        showDropDownButton: true,
      )

    ),
  );
}

Widget customButton({required String title, required VoidCallback onTap}){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 55,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue,
      ),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
    ),
  );
}

Widget customSearch({required TextEditingController controller}){
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: "Search",
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),

      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500,)
    ),
    
  );
}

