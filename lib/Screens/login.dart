import 'package:chat/Controllers/controllers.dart';
import 'package:chat/Database/authentication.dart';
import 'package:chat/Utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget{

  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController= TextEditingController();
  final ObsecureController controller = Get.put(ObsecureController());

  final TextEditingController _passwordController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
@override
  void dispose() {
    // TODO: implement dispose
  controller.dispose();
  _emailController.dispose();
  _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final height = Get.height;
   return SafeArea(
top:  false,
     child: Scaffold(
       appBar: AppBar(
         title: const Text("Login"),
       ),
       body: Padding(
         padding:const EdgeInsets.all(10),
         child: Column(
           children: [
             Expanded(child: const Image(image: AssetImage("assets/chat.jpg"))),
             SizedBox(
               height: height*0.3,
               child: Form(
                   key: _formKey,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                     children: [
                 customEmail(controller: _emailController),
                GetBuilder<ObsecureController>(builder: (controller) =>                customPassword(controller: _passwordController, obscure: controller.obsecure, title: "Password", obsecureTap: () {
                  controller.updateObsecure();
                } ),
                    ),
               ],)),
             ),
             customButton(title: "Login", onTap: () async{
                if(_formKey.currentState!.validate()){
                  bool auth = await Authentication().loginWithEmail(email: _emailController.text.trim(), password: _passwordController.text.trim());
                  if(auth){
                    Authentication().AddObserver();

                    Get.offNamed('/');
                  }else{
                    Get.snackbar("Login", "Check your email and password");
                  }
                }
             },),
             const SizedBox(height: 20,),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               spacing: 10,
               children: [
                 const Text("I don't have an account?"),
                 GestureDetector(
                 onTap: () {
                   Get.offNamed("/registration");
                 }

                 ,child: const Text("Registration", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),))
               ],
             ),
             const SizedBox(height: 10,),

           ],
         ),
       ),
     ),
   );
  }
}