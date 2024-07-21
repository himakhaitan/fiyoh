import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/app_entry/auth/bloc/auth_bloc.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/dashboard/widgets/custom_drawer_header.dart';
import 'package:rentwise/dashboard/widgets/custom_list_title.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
      },
      child: Drawer(
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
                    title: "Profile",
                    icon: Icons.person_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  CustomListTitle(
                    title: "Support",
                    icon: Icons.support_agent_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, '/support');
                    },
                  ),
                  CustomListTitle(
                    title: "Sign Out",
                    icon: Icons.logout_outlined,
                    onTap: () {
                      context.read<AuthBloc>().add(SignOutEvent());
                      Navigator.pushNamed(context, '/');
                    },
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
      ),
    );
  }
}
