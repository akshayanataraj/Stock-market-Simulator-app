// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class WatchlistTab extends StatefulWidget {
  const WatchlistTab({super.key});

  @override
  State<WatchlistTab> createState() => _WatchlistTabState();
}

class _WatchlistTabState extends State<WatchlistTab> {
  final ref = FirebaseDatabase.instance.ref('liveStockData');
  bool isPutSelected = true;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  Future<void> addToOrders(String stockName, bool isPutSelected) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      final userId = user.email;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();
      double curBalance = (userDoc['wallet']['balance'] ?? 0.0).toDouble();
      double price = double.parse(priceController.text.trim());
      double quantity = double.parse(quantityController.text.trim());
      double newBalance = curBalance - (price * quantity);
      if (newBalance > 0) {
        // Subtract the price from the balance
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'wallet.balance': newBalance});

        // Add the order to the orders collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('orders')
            .doc(stockName)
            .set({
          'price': price,
          'quantity': int.parse(quantityController.text.trim()),
          'option': isPutSelected ? 'PE' : 'CE',
        });

        // Add the transaction to the transactions collection
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
          'price': -price,
          'status': 'stock bought'
        });

        priceController.clear();
        quantityController.clear();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('orders')
            .doc('ORDERS')
            .delete();

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Stock bought Successfully!')));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Insufficient balance in your wallet.'),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(children: [
        Expanded(
          child: FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    child: ListTile(
                      tileColor: Colors.black,
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text(
                                'Buy Stock',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: priceController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white)),
                                          hintText: 'Enter price',
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                    ),
                                    TextField(
                                      controller: quantityController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white)),
                                          hintText: 'Enter quantity',
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                    ),
                                    Row(
                                      children: [
                                        const Text('PUT',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Radio<bool>(
                                          value: true,
                                          groupValue: isPutSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              isPutSelected = value!;
                                            });
                                          },
                                        ),
                                        const Text('CALL',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Radio<bool>(
                                          value: false,
                                          groupValue: isPutSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value != null) {
                                                isPutSelected = value;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  // ignore: prefer_const_constructors
                                  child: Text('Buy',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    addToOrders(
                                        snapshot.child('name').value.toString(),
                                        isPutSelected);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      title: Text(
                        snapshot.child('name').value.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      subtitle: Row(
                        children: [
                          (snapshot.child('comparison').value == 0)
                              ? Row(
                                  children: [
                                    Text(
                                      snapshot
                                          .child('percentageChange')
                                          .value
                                          .toString(),
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      snapshot
                                          .child('percentageChange')
                                          .value
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                    const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      trailing: Text(
                        snapshot.child('liveValue').value.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                );
              }),
        )
      ]),
    );
  }
}
