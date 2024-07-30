import 'package:fiyoh/app_entry/auth/bloc/auth_bloc.dart';
import 'package:fiyoh/common_widgets/bottom_modal.dart';
import 'package:fiyoh/common_widgets/header_text.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ListItem {
  final String title;
  final IconData icon;
  final String onTap;

  ListItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final List<ListItem> items = [
  // ListItem(
  //   title: 'Add new Property',
  //   icon: Icons.add_circle_outline_outlined,
  //   onTap: '/property/add',
  // ),
  // ListItem(
  //   title: 'Add new Tenant',
  //   icon: Icons.add_circle_outline_outlined,
  //   onTap: '/tenant/add',
  // ),
  // ];

  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          final user = state.user;
          final List<ListItem> items = [
            if (user.userType != UserType.manager)
              ListItem(
                title: 'Add new Property',
                icon: Icons.add_circle_outline_outlined,
                onTap: '/property/add',
              ),
            ListItem(
              title: 'Add new Tenant',
              icon: Icons.add_circle_outline_outlined,
              onTap: '/tenant/add',
            ),
          ];

          return AppBar(
            backgroundColor: MyConstants.whiteColor,
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu_outlined,
                    color: MyConstants.accentColor,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            centerTitle: true,
            title: Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline_outlined,
                  color: MyConstants.accentColor,
                  size: 30,
                ),
                onPressed: () {
                  showBottomModal(
                    context,
                    [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                          color: MyConstants.primary100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(2),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: MyConstants.brand400,
                              width: 2,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          top: 30.0,
                          bottom: 20.0,
                        ),
                        child: const HeaderText(
                          text: "Choose an option",
                          color: MyConstants.whiteColor,
                          fontSize: 16.0,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return OptionListItem(item: items[index]);
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ],
          );
        } else if (state is AuthInitial) {
          context.read<AuthBloc>().add(RefreshState());
        }
        return AppBar(
          backgroundColor: MyConstants.whiteColor,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu_outlined,
                  color: MyConstants.accentColor,
                  size: 30,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class OptionListItem extends StatelessWidget {
  const OptionListItem({
    super.key,
    required this.item,
  });

  final ListItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: MyConstants.whiteColor.withOpacity(0.2),
        highlightColor: MyConstants.whiteColor.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: MyConstants.brand400.withOpacity(0.2),
              ),
            ),
          ),
          child: ListTile(
            title: Text(
              item.title,
              style: GoogleFonts.poppins(
                color: MyConstants.whiteColor,
                fontSize: 16,
              ),
            ),
            leading: Icon(
              item.icon,
              color: MyConstants.brand400,
            ),
            onTap: () {
              Navigator.pushNamed(context, item.onTap);
            },
          ),
        ),
      ),
    );
  }
}
