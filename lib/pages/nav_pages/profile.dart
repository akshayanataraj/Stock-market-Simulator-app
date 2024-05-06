import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: const Text('P R O F I L E',
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser?.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;

                return ListView(
                  children: [
                    const SizedBox(height: 15),
                    const Icon(
                      Icons.person,
                      size: 72,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentUser!.email!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    MyTextBox(
                        text: userData['First Name'] +
                            ' ' +
                            userData['Last Name'],
                        sectionName: 'User'),
                    const Divider(),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('error'),
                );
              }

              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }));
  }
}
