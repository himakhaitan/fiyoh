import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/layouts/detail/detail_layout.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailLayout(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MyConstants.purpleMetallic,
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(
                    //   color: MyConstants.greyColor,
                    //   width: 1.5,
                    // ),
                  ),
                  child: const Icon(
                    Icons.apartment_outlined,
                    size: 40,
                    color: MyConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: "101",
                        color: MyConstants.accentColor,
                        fontSize: 35,
                      ),
                      DescriptiveText(
                        text: "Green Homes Platina",
                        color: MyConstants.greyColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 2,
              height: 40,
            ),
            const HeaderText(
              text: "Details",
              color: MyConstants.accentColor,
              fontSize: 18,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 1.5,
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DescriptiveText(
                        text: "Floor",
                        color: MyConstants.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: 10),
                      HeaderText(
                        text: "2",
                        color: MyConstants.accentColor,
                        fontSize: 25,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DescriptiveText(
                          text: "Occupancy",
                          color: MyConstants.accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(width: 10),
                        HeaderText(
                          text: "3",
                          color: MyConstants.accentColor,
                          fontSize: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 2,
              height: 40,
            ),
            const HeaderText(
              text: "Tenants",
              color: MyConstants.accentColor,
              fontSize: 18,
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              children: const [
                TenantItem(name: "Himanshu Khaitan"),
                TenantItem(name: "Ritesh Raj Sharma"),
                TenantItem(name: "Kalyan Chowbey"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TenantItem extends StatelessWidget {
  final String name;
  const TenantItem({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MyConstants.primaryColor,
            ),
            child: Icon(
              Icons.person_4_rounded,
              color: MyConstants.whiteColor,
            ),
          ),
          DescriptiveText(text: name, color: MyConstants.accentColor),
          IconButton.filledTonal(
            onPressed: () {},
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
