// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'fogot_password.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        },
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        // Show alert box for incorrect password
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: const Text(
                "Incorrect Password",
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                "The password you entered is incorrect.",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        // Handle other FirebaseAuthExceptions
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: const Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "An error occurred during login: ${e.message}",
                style: const TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Handle other errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              "Error",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "An error occurred during login: $error",
              style: const TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('lib/images/logo.PNG', fit: BoxFit.fill),
              ),
              //hello

              const Text(
                'Hello Again!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Welcome back to EquityIQ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),

              //email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Password',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                  obscureText: true,
                ),
              ),

              const SizedBox(height: 10),

              //forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ForgotPasswordPage();
                        }));
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //not a member? register

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showRegisterPage,
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ))));
  }
}
