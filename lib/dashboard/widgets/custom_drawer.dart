import 'package:fiyoh/property/bloc/property_bloc.dart';
import 'package:fiyoh/tenant/bloc/tenant_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/app_entry/auth/bloc/auth_bloc.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/dashboard/widgets/custom_drawer_header.dart';
import 'package:fiyoh/dashboard/widgets/custom_list_title.dart';
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
                    title: "Reports",
                    icon: Icons.table_chart_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, '/request/report');
                    },
                  ),
                  CustomListTitle(
                    title: "Support",
                    icon: Icons.support_agent_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, '/request/support');
                    },
                  ),
                  CustomListTitle(
                    title: "Sign Out",
                    icon: Icons.logout_outlined,
                    onTap: () {
                      // Set property state to Initial
                      context.read<PropertyBloc>().add(ResetPropertyState());
                      // Set Tenant state to Initial
                      context.read<TenantBloc>().add(ResetTenantState());

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
