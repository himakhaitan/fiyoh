import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/home/widgets/custom_drawer_header.dart';
import 'package:rentwise/home/widgets/custom_list_title.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[50],
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: CustomDrawerHeader(),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                CustomListTitle(
                  title: "Home",
                  icon: Icons.home,
                  onTap: () {},
                ),
                CustomListTitle(
                  title: "Profile",
                  icon: Icons.person,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const DescriptiveText(
            text: "Version 1.0.0",
            color: MyConstants.primaryColor,
            fontSize: 14,
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
