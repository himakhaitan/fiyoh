import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/info_item.dart';
import 'package:fiyoh/constants/colours.dart';

class TenantTile extends StatelessWidget {

  const TenantTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyConstants.lightGreyColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MyConstants.primaryColor,
            ),
            child: const Icon(
              Icons.person_4_rounded,
              color: MyConstants.whiteColor,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              children: [
                InfoItem(
                  text: "Himanshu Khaitan",
                  icon: Icons.person_2_outlined,
                ),
                InfoItem(
                  text: "Room 101",
                  icon: Icons.meeting_room_outlined,
                ),
                InfoItem(
                  text: "Paid",
                  icon: Icons.currency_rupee_outlined,
                  color: MyConstants.successMetallic,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {
              Navigator.pushNamed(context, '/tenant/details', arguments: {});
            },
            icon: const Icon(Icons.navigate_next),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey[100]),
            ),
          ),
        ],
      ),
    );
  }
}
