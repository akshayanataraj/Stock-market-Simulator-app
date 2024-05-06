import 'package:equity_iq/components/drawer_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final void Function()? onProfileTap;
  final void Function()? onWalletTap;
  // ignore: use_key_in_widget_constructors
  const MyDrawer({Key? key, this.onProfileTap, this.onWalletTap});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 167, 166, 166),
      child: Column(
        children: [
          //app logo
          const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Icon(
              Icons.auto_graph,
              size: 50,
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: Colors.black),
          ),

          //profile list title
          MyDrawerTile(
            text: 'P R O F I L E',
            icon: Icons.person,
            onTap: widget.onProfileTap,
          ),
          //wallet list title
          MyDrawerTile(
            text: 'W A L L E T',
            icon: Icons.wallet,
            onTap: widget.onWalletTap,
          ),
          //settings list title
          MyDrawerTile(
            text: 'S E T T I N G S',
            icon: Icons.settings,
            onTap: () {},
          ),
          const Spacer(),
          //logout list title
          MyDrawerTile(
            text: 'L O G O U T',
            icon: Icons.logout,
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
