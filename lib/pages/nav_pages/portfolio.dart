import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioTab extends StatefulWidget {
  const PortfolioTab({super.key});

  @override
  State<PortfolioTab> createState() => _PortfolioTabState();
}

class _PortfolioTabState extends State<PortfolioTab> {
  late final FirebaseAuth auth;
  late User? user;

  @override
  void initState() {
    super.initState();
    // Initialize FirebaseAuth instance
    auth = FirebaseAuth.instance;
    // Get the current user
    user = auth.currentUser;
  }

  void updateFirestoreDocument(String stockSymbol, double newTotal) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .collection('portfolio')
        .doc(stockSymbol)
        .update({
      'newTotal': newTotal,
    });
  }

  double truncateToDecimals(double value, int numberOfDecimalPlaces) {
    final fac = pow(10, numberOfDecimalPlaces);
    return (value * fac).roundToDouble() / fac;
  }

  Future<void> addTotransaction(String stockName, double price) async {
    final userId = user!.email;
    QuerySnapshot transactionQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .get();
    int transactionCount = transactionQuery.size;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc('ID $transactionCount')
        .set({'stockName': stockName, 'price': price, 'status': 'order sold'});
  }

  Future<void> updateWallet(
      String stockSymbol, double newTotal, double price) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();

      if (userDoc.exists) {
        double curBalance = (userDoc['wallet']['balance'] ?? 0.0).toDouble();
        double updatedBalance = newTotal + curBalance;

        // Update the wallet balance in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .update({
          'wallet.balance': updatedBalance,
        });
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('portfolio')
          .doc(stockSymbol)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.email)
            .collection('portfolio')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Portfolio is empty.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final portfolioItem = snapshot.data!.docs[index];
              final stockSymbol = portfolioItem.id;
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  tileColor: Colors.black,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    '$stockSymbol ${portfolioItem['option']}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  subtitle: StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .ref()
                        .child('liveStockData')
                        .child(stockSymbol)
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData ||
                          snapshot.data!.snapshot.value == null ||
                          snapshot.data!.snapshot.value == "Empty") {
                        return const Text(
                          'MARKET IS CLOSED',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        );
                      }
                      final liveData = snapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;
                      final liveValue =
                          double.tryParse(liveData['liveValue'].toString());
                      final percentageChange =
                          liveData['percentageChange'].toString();
                      final newTotal = liveValue! * portfolioItem['quantity'];
                      final roundedNewTotal = truncateToDecimals(newTotal, 2);
                      updateFirestoreDocument(stockSymbol, newTotal);
                      final comparison = liveData['comparison'] as int?;
                      final icon = (comparison == 0)
                          ? Row(
                              children: [
                                Text(
                                  '($percentageChange)',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                                const Icon(Icons.arrow_downward,
                                    color: Colors.red),
                              ],
                            )
                          : Row(
                              children: [
                                Text(
                                  '($percentageChange)',
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 14),
                                ),
                                const Icon(Icons.arrow_upward,
                                    color: Colors.green),
                              ],
                            );
                      return Row(
                        children: [
                          Text(
                            'Rs.$liveValue \nValue: Rs.$roundedNewTotal  ',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          icon,
                        ],
                      );
                    },
                  ),
                  trailing: Text(
                    'Quantity: ${portfolioItem['quantity']}\nPrice: ${portfolioItem['price']}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onTap: () {
                    final currentContext = context; // Capture the context
                    showDialog(
                        context: currentContext,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.black,
                            title: const Text(
                              'Ready to sell?',
                              style: TextStyle(color: Colors.white),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  Navigator.pop(
                                      currentContext); // Use the captured context here
                                },
                              ),
                              TextButton(
                                child: const Text('Sell',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  updateWallet(
                                      stockSymbol,
                                      portfolioItem['newTotal'],
                                      portfolioItem['price']);
                                  addTotransaction(
                                      stockSymbol, portfolioItem['price']);
                                  Navigator.pop(currentContext);
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
