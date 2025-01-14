import 'package:fiyoh/payments/bloc/payment_bloc.dart';
import 'package:fiyoh/tenant/bloc/tenant_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/app_entry/auth/bloc/auth_bloc.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/dashboard/screens/home_screen.dart';
import 'package:fiyoh/dashboard/screens/manage_screen.dart';
import 'package:fiyoh/dashboard/screens/rooms_screen.dart';
import 'package:fiyoh/dashboard/screens/tenants_screen.dart';
import 'package:fiyoh/dashboard/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:fiyoh/dashboard/widgets/custom_bottom_bar.dart';
import 'package:fiyoh/dashboard/widgets/custom_app_bar.dart';
import 'package:fiyoh/property/bloc/property_bloc.dart';

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
      backgroundColor: MyConstants.bg400,
      appBar: CustomAppBar(),
      drawer: const CustomDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          BlocProvider(
            create: (context) => PaymentBloc(),
            child: const HomeScreen(),
          ),
          const RoomsScreen(),
          const TenantsScreen(),
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
