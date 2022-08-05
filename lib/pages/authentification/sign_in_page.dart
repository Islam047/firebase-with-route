import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_one/pages/authentification/sign_up.dart';
import 'package:firebase_note_one/pages/services/authentification_service/auth_service.dart';
import 'package:firebase_note_one/pages/services/database_service/shared_preferances.dart';
import 'package:firebase_note_one/pages/services/utils_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  static const id = "/sign_in_page";

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void signIn() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Utils.fireSnackBar("All fields are required", context);
      return;
    }
    isLoading = true;
    setState(() {});
    AuthService.signInUser(context, email, password)
        .then((value) => _checkUser(value));
  }

  void _checkUser(User? user) async {
    if (user != null) {
      await DBService.saveUserId(user.uid);
      // if (mounted) Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireSnackBar("Please check your data", context);
    }
    isLoading = false;
    setState(() {});
  }

  void _goSignUp() {
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                    onPressed: signIn,
                    child: const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(
                          text: "Don't have an account?  ",
                        ),
                        TextSpan(
                          style: const TextStyle(color: Colors.blue),
                          text: "Sign up",
                          recognizer: TapGestureRecognizer()..onTap = _goSignUp,
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
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
