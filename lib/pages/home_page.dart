import 'package:equity_iq/components/drawer.dart';
import 'package:equity_iq/pages/nav_pages/wallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'nav_pages/orders.dart';
import 'nav_pages/profile.dart';
import 'nav_pages/transactions.dart';
import 'nav_pages/portfolio.dart';
import 'nav_pages/watchlist.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser!;

  int _selectedIndex = 0;

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const WatchlistTab();
      case 1:
        return const OrdersTab();
      case 2:
        return const PortfolioTab();
      case 3:
        return const TransactionTab();
      default:
        return Container();
    }
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  void goTowalletPage() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const WalletPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('E  q  u  i  t  y  IQ',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onWalletTap: goTowalletPage,
      ),

      body: _buildPage(_selectedIndex),

      //navbar

      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.watch,
                text: 'Watchlist',
              ),
              GButton(
                icon: Icons.add_to_queue_rounded,
                text: 'Orders',
              ),
              GButton(
                icon: Icons.book,
                text: 'Portfolio',
              ),
              GButton(
                icon: Icons.currency_exchange,
                text: 'Transactions',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
