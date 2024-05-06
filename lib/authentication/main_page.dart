import 'package:equity_iq/authentication/auth_page.dart';
import 'package:equity_iq/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Homepage();
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}
