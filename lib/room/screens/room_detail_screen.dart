import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/layouts/detail/detail_layout.dart';
import 'package:rentwise/tenant/screens/tenant_detail_screen.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
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
            thickness: 1,
            height: 40,
          ),
          SectionHeader(text: "Details"),
          const SizedBox(height: 10),

          Row(
            children: [
              InfoTag(
                item: "Floor",
                value: "1",
              ),
              const SizedBox(width: 5),
              Expanded(
                child: InfoTag(
                item: "Occupancy",
                value: "3",
              ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400]!,
            thickness: 1,
            height: 40,
          ),
          SectionHeader(text: "Tenants"),
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
