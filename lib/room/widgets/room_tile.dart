import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/info_item.dart';
import 'package:rentwise/constants/colours.dart';

class RoomTile extends StatelessWidget {
  const RoomTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyConstants.greyColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyConstants.primaryColor.withOpacity(0.8),
            ),
            child: const Center(
              child: DescriptiveText(
                text: "101",
                fontSize: 18,
                color: MyConstants.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              children: [
                 InfoItem(
                  text: "Green Homes Platina",
                  icon: Icons.apartment_outlined,
                  
                ),
                InfoItem(
                  text: "Empty",
                  icon: Icons.king_bed_outlined,
                  color: MyConstants.successMetallic,
                ),
               
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/room/details',
                arguments: {}
              );
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
