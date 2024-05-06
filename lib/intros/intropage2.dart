import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              'Learn, Practice',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
            ),
            const Text(
              'and Succeed in Virtual',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
            ),
            const Text(
              'Trading',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
            ),
            const SizedBox(
              height: 55,
            ),
            Lottie.network(
                'https://lottie.host/d7571088-6f25-4c20-b4ef-e0a49c19fdf2/xvCCOE6teo.json',
                width: 300,
                height: 200,
                fit: BoxFit.fill),
          ],
        ),
      ),
    );
  }
}
