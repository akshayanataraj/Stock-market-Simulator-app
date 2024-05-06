import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({
    super.key,
  });

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              'EquityIQ',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  color: Colors.black,
                  fontSize: 60,
                  height: 1.2),
            ),
            const SizedBox(
              height: 75,
            ),
            const Text(
              'Welcome to Your',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
            ),
            const Text(
              'Gateway to the Financial',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
            ),
            const Text(
              'world!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
            ),
            Lottie.network(
                'https://lottie.host/557f0f05-db56-4b15-add2-872c1c1bfb66/z1oTP2XX6I.json',
                width: 300,
                height: 300,
                fit: BoxFit.fill),
          ],
        ),
      ),
    );
  }
}
