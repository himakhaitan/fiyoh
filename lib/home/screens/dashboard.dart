import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/home/screens/manage_screen.dart';
import 'package:rentwise/home/screens/rent_screen.dart';
import 'package:rentwise/home/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/home/widgets/custom_bottom_bar.dart';
import 'package:rentwise/home/widgets/custom_app_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstants.whiteColor,
      appBar: CustomAppBar(),
      drawer: const CustomDrawer(),
      body: PageView(
        controller: _pageController, 
        onPageChanged: onPageChanged,
        children: [
          Container(
            color: Colors.white,
            child: const Center(
              child: Text('Home'),
            ),
          ),
          const RentScreen(),
          // Container(
          //   color: Colors.white,
          //   child: const Center(
          //     child: Text('School'),
          //   ),
          // ),
         const ManageScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
