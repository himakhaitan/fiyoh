import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

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
  final List<ListItem> items = [
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

  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
      // centerTitle: true,
      // title: Text(
      //   'Welcome! Himanshu',
      //   style: GoogleFonts.roboto(
      //     color: MyConstants.accentColor,
      //     fontSize: 20,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: MyConstants.accentColor,
            size: 30,
          ),
          onPressed: () {
            showBottomModal(context);
          },
        ),
      ],
    );
  }

  Future<dynamic> showBottomModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: MyConstants.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(2),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: MyConstants.tertiaryColor,
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
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: MyConstants.whiteColor.withOpacity(0.2),
                        highlightColor: MyConstants.whiteColor.withOpacity(0.1),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    MyConstants.tertiaryColor.withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              items[index].title,
                              style: GoogleFonts.poppins(
                                color: MyConstants.whiteColor,
                                fontSize: 16,
                              ),
                            ),
                            leading: Icon(
                              items[index].icon,
                              color: MyConstants.tertiaryColor,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, items[index].onTap);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
