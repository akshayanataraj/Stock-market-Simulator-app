import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionTab extends StatefulWidget {
  const TransactionTab({super.key});

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  late final FirebaseAuth auth;
  late User? user;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.email)
            .collection('transactions')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No transactions yet.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final transaction = snapshot.data!.docs[index];
              final stockName = transaction['stockName'];
              final price = transaction['price'];
              final status = transaction['status'];
              final isPositive = price >= 0;

              // Add a plus symbol if the price is positive
              final formattedPrice = isPositive
                  ? '+${price.toStringAsFixed(2)}'
                  : '${price.toStringAsFixed(2)}';
              final color = price < 0 ? Colors.red : Colors.green;

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  tileColor: Colors.black,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(stockName,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                  subtitle: Text('$status',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                  trailing: Text(formattedPrice,
                      style: TextStyle(color: color, fontSize: 14)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
