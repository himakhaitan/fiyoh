import 'package:flutter/material.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTabTapped,
      backgroundColor: MyConstants.primaryColor,
      enableFeedback: false,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyConstants.whiteColor,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(
        color: MyConstants.whiteColor,
        size: 25,
        opacity: 1,
        applyTextScaling: true,
        shadows: List.from(
          const [
            Shadow(
              color: MyConstants.tertiaryColor,
              offset: Offset(1, 1),
              blurRadius: 10,
            ),
          ],
        ),
      ),
      unselectedIconTheme: const IconThemeData(
        color: Colors.grey,
        size: 20,
        opacity: 0.5,
        applyTextScaling: true,
      ),
      selectedLabelStyle: GoogleFonts.poppins(
        color: MyConstants.whiteColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ),
      currentIndex: currentIndex,
      items: [
        _bottomNavigationBarItem(
          title: 'Home',
          icon: Icons.home_outlined,
        ),
        _bottomNavigationBarItem(
          title: 'Rooms',
          icon: Icons.meeting_room_outlined,
        ),
        _bottomNavigationBarItem(
          title: 'Tenants',
          icon: Icons.people_alt_outlined,
        ),
        _bottomNavigationBarItem(
          title: 'Manage',
          icon: Icons.home_work_outlined,
        ),
      ],
    );
  }

  // Define the named parameter title and icon
  BottomNavigationBarItem _bottomNavigationBarItem({
    required String title,
    required IconData icon,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: MyConstants.whiteColor,
      ),
      label: title,
    );
  }
}
