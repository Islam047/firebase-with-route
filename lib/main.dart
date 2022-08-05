import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_note_one/pages/detail_page.dart';
import 'package:firebase_note_one/pages/home_page.dart';
import 'package:firebase_note_one/pages/services/database_service/shared_preferances.dart';
import 'package:flutter/material.dart';
import 'pages/authentification/sign_in_page.dart';
import 'pages/authentification/sign_up.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

  runApp(const MyFirebaseApp());
}

Widget _startPage() {
  return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          DBService.saveUserId(snapshot.data!.uid);
          return const HomePage();
        } else {
          DBService.removeUserId();
          return const SignInPage();
        }
      } );
}

class MyFirebaseApp extends StatelessWidget {

  const MyFirebaseApp({Key? key}) : super(key: key);
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Firebase app",
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],

      home: _startPage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        DetailPage.id: (context) => const DetailPage(),
      },
    );
  }
}
