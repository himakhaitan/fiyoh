// Packages: Imports
import 'package:rentwise/common_widgets/duotone_text.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/constants/colours.dart';
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
            'assets/images/welcome_image.png',
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
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 20),
                  child: DuoToneText(
                      firstPart: 'Effortlessly Manage Your ',
                      highlightedPart: 'PG Properties',
                      lastPart: ' Anytime, Anywhere',
                      primaryColor: MyConstants.primaryColor,
                      secondaryColor: MyConstants.secondaryColor),
                ),
              ],
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
                  /// Navigate to the login screen.
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
