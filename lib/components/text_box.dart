import 'package:flutter/material.dart';

class MyTextBox extends StatefulWidget {
  const MyTextBox({super.key, required this.text, required this.sectionName});

  final String text;
  final String sectionName;

  @override
  State<MyTextBox> createState() => _MyTextBoxState();
}

class _MyTextBoxState extends State<MyTextBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.sectionName,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          Text(
            widget.text,
            style: const TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }
}
