import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _amountController = TextEditingController();

  double _currentBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  void _fetchBalance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.email).get();
      Map<String, dynamic>? userData =
          snapshot.data() as Map<String, dynamic>?; // Explicit cast
      if (userData != null && userData.containsKey('wallet')) {
        // Convert balance to double explicitly
        double balance = (userData['wallet']['balance'] ?? 0).toDouble();
        setState(() {
          _currentBalance = balance;
        });
      }
    }
  }

  void _addMoney() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount > 0) {
      User? user = _auth.currentUser;
      if (user != null) {
        double newBalance = _currentBalance + amount;
        await _firestore.collection('users').doc(user.email).update({
          'wallet.balance': newBalance,
        });
        setState(() {
          _currentBalance = newBalance;
        });
        _amountController.clear();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Money added successfully!')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('W A L L E T', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your current balance:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Rs. $_currentBalance',
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Enter amount to add',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addMoney,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text(
                'Add Money',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
