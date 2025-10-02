import 'package:chat/Controllers/controllers.dart';
import 'package:chat/Database/authentication.dart';
import 'package:chat/Utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final ObsecureController controller1 = Get.put(ObsecureController());

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _mobileNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Registration")),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Let's Create Your Account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(
                  height: height * 0.55,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        customName(controller: _nameController),
                        customEmail(controller: _emailController),
                        customMobileNumber(controller: _mobileNumberController),
                        GetBuilder<ObsecureController>(
                          builder: (controller) => customPassword(
                            controller: _passwordController,
                            obscure: controller.obsecure,
                            title: "Password",
                            obsecureTap: () {
                              controller.updateObsecure();
                            },
                          ),
                        ),
                        GetBuilder<ObsecureController>(
                          builder: (controller) => customPassword(
                            controller: _confirmPasswordController,
                            obscure: controller.obsecure,
                            title: "Confirm Password",
                            obsecureTap: () {
                              controller.updateObsecure();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                customButton(
                  title: "Create Account",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_passwordController.text.trim() ==
                          _confirmPasswordController.text.trim()) {
                        bool auth = await Authentication().registration(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          mobileNumber: _mobileNumberController.text.trim(),
                          name: _nameController.text.trim().toUpperCase(),
                        );
                        if (auth) {
                          Authentication().AddObserver();

                          Get.offNamed("/");
                        } else {
                          Get.snackbar(
                            "Registration",
                            "Please check your email or password\nif you have already created account then go to login page",
                          );
                        }
                      } else {
                        Get.snackbar(
                          "Password",
                          "Password and confirm password does not match",
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    const Text("I have account?"),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed("/login");
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Icon(Icons.lock, color: Colors.grey.shade500),
                    Text(
                      "We'll never share your info",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
