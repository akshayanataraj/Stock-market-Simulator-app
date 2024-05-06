import 'package:equity_iq/authentication/main_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intropage1.dart';
import 'intropage2.dart';
import 'intropage3.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  bool onLastPage = false;

  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: const [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
          ],
        ),
        Container(
            alignment: const Alignment(0, 0.80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(2);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontSize: 18),
                    )),

                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect:
                      const ExpandingDotsEffect(activeDotColor: Colors.black),
                  onDotClicked: (index) {},
                ),

                //next
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Mainpage();
                          }));
                        },
                        child: const Text(
                          'Start',
                          style: TextStyle(fontSize: 18),
                        ))
                    : GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(fontSize: 18),
                        ))
              ],
            )),
      ],
    ));
  }
}
