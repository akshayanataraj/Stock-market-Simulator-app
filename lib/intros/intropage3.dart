import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
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
              'No risk, all',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
            ),
            const Text(
              'reward - Start Trading',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
            ),
            const Text(
              'with play money!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
            ),
            const SizedBox(
              height: 47,
            ),
            Lottie.network(
              'https://lottie.host/03c6d089-ebe0-4437-b8ef-43943d92bf6d/hssXqoap5V.json',
              width: 300,
              height: 200,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
