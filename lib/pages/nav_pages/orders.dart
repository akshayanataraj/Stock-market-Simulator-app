// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  late final FirebaseAuth auth;
  User? user;

  @override
  void initState() {
    super.initState();
    // Initialize FirebaseAuth instance
    auth = FirebaseAuth.instance;
    // Get the current user
    user = auth.currentUser;
  }

  double truncateToDecimals(double value, int numberOfDecimalPlaces) {
    final fac = pow(10, numberOfDecimalPlaces);
    return (value * fac).roundToDouble() / fac;
  }

  Future<void> deleteOrder(String stockName, double price) async {
    final userId = user!.email;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(stockName)
        .delete();
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
        .set({
      'stockName': stockName,
      'price': price,
      'status': 'order cancelled'
    });
  }

  Future<void> addToPortfolio(
      String stockName, double price, int quantity, String option) async {
    try {
      final userId = user!.email;

      // Listen for live value changes
      FirebaseDatabase.instance
          .ref()
          .child('liveStockData')
          .child(stockName)
          .child('liveValue')
          .onValue
          .listen((event) {
        final liveValue = event.snapshot.value as double?;
        if (liveValue != null && (liveValue >= price)) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('portfolio')
              .doc(stockName)
              .set({
            'price': price,
            'quantity': quantity,
            'total': truncateToDecimals(price * quantity, 2),
            'option': option,
          });

          deleteOrder(stockName, price);
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content:
                    Text('Stock price has not reached your purchase amount!'),
              );
            },
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add to portfolio')),
      );
    }
  }

  Future<void> refundWallet(
      String stockName, double price, int quantity) async {
    try {
      final userId = user!.email;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      double curBalance = (userDoc['wallet']['balance'] ?? 0.0).toDouble();
      double newBalance = curBalance + (price * quantity);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'wallet.balance': newBalance});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order refunded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to refund order')),
      );
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
            .collection('orders')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final order = snapshot.data!.docs[index];
              final stockSymbol = order.id;
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  tileColor: Colors.black,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    '$stockSymbol ${order['option']}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  subtitle: StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .ref()
                        .child('liveStockData')
                        .child(stockSymbol)
                        .child('liveValue')
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
                      final comparison = snapshot.data!.snapshot.value;
                      final icon = (comparison == 0)
                          ? const Icon(Icons.arrow_downward, color: Colors.red)
                          : const Icon(Icons.arrow_upward, color: Colors.green);
                      final liveValue =
                          snapshot.data!.snapshot.value as double?;
                      return Row(
                        children: [
                          Text(
                            '$liveValue',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          icon,
                        ],
                      );
                    },
                  ),
                  trailing: Text(
                    'Quantity: ${order['quantity']}\nPrice: ${order['price']}',
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
                              'Confirm purchase?',
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
                                child: const Text('Add to Portfolio',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  addToPortfolio(stockSymbol, order['price'],
                                      order['quantity'], order['option']);
                                  Navigator.pop(
                                      currentContext); // Use the captured context here
                                },
                              ),
                              TextButton(
                                  onPressed: () async {
                                    refundWallet(stockSymbol, order['price'],
                                        order['quantity']);
                                    deleteOrder(stockSymbol, order['price']);
                                    addTotransaction(
                                        stockSymbol, order['price']);
                                    Navigator.pop(currentContext);
                                  },
                                  child: const Text('Delete order',
                                      style: TextStyle(color: Colors.white)))
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
