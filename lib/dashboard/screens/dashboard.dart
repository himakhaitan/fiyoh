import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/app_entry/auth/bloc/auth_bloc.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/dashboard/screens/home_screen.dart';
import 'package:rentwise/dashboard/screens/manage_screen.dart';
import 'package:rentwise/dashboard/screens/rooms_screen.dart';
import 'package:rentwise/dashboard/screens/tenants_screen.dart';
import 'package:rentwise/dashboard/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/dashboard/widgets/custom_bottom_bar.dart';
import 'package:rentwise/dashboard/widgets/custom_app_bar.dart';
import 'package:rentwise/property/bloc/property_bloc.dart';

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
          BlocProvider(
            create: (context) => AuthBloc(),
            child: const HomeScreen(),
          ),
          BlocProvider(
            create: (context) => PropertyBloc(),
            child: const RoomsScreen(),
          ),
          BlocProvider(
            create: (context) => PropertyBloc(),
            child: const TenantsScreen(),
          ),
          BlocProvider(
            create: (context) => PropertyBloc(),
            child: const ManageScreen(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
