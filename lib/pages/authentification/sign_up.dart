import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_one/pages/services/authentification_service/auth_service.dart';
import 'package:firebase_note_one/pages/services/database_service/shared_preferances.dart';
import 'package:firebase_note_one/pages/services/utils_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  static const id = "/sign_up_page";

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  bool isLoading = false;

  void signUp() async {
    String name = fullNameController.text.trim();
    String password = passwordController.text.trim();
    String email = emailController.text.trim();
    if (name.isEmpty || password.isEmpty || email.isEmpty) {
      Utils.fireSnackBar("Please fill all gaps", context);
      return;
    }
    isLoading = true;
    setState(() {});
    AuthService.signUpUser(context, name, email, password)
        .then((value) => _checkNewUser(value));
  }

  void _checkNewUser(User? user) async {
    if (user != null) {
      await DBService.saveUserId(user.uid);
      if (mounted) Navigator.pushReplacementNamed(context, SignInPage.id);
    } else {
      Utils.fireSnackBar("Please check your entered data, Please try again!", context);
    }
    isLoading = false;
    setState(() {});
  }


  void _goSignIn() {
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(25),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // fullName
                  TextField(
                    controller: fullNameController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: "FullName",
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // #email
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                    onPressed: signUp,
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(
                          text: "Already have an account?  ",
                        ),
                        TextSpan(
                          style: const TextStyle(color: Colors.blue),
                          text: "Sign in",
                          recognizer: TapGestureRecognizer()..onTap = _goSignIn,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const Center(child: CircularProgressIndicator(),),
          )
        ],
      ),
    );
  }
}
