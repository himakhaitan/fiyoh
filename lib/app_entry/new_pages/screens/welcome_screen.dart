// Packages: Imports
import 'package:fiyoh/common_widgets/duotone_text.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:flutter/material.dart';

/// A screen for welcoming users to the app.
class WelcomeScreen extends StatelessWidget {
  /// Creates a [WelcomeScreen] widget.
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/app.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.2),
                ],
                stops: const [0.3, 0.9],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DuoToneText(
                    firstPart: 'Effortlessly Manage Your ',
                    highlightedPart: 'PG Properties',
                    lastPart: ' Anytime, Anywhere',
                    primaryColor: MyConstants.accent100,
                    secondaryColor: MyConstants.brand100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: LongButton(
                  text: "Get Started",
                  buttonColor: MyConstants.bg400,
                  textColor: MyConstants.text100,
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
