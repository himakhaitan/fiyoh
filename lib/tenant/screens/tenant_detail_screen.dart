import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/header_text.dart';
import 'package:fiyoh/common_widgets/section_header.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/layouts/detail/detail_layout.dart';
import 'package:fiyoh/tenant/widgets/transaction_tile.dart';

class TenantDetailScreen extends StatelessWidget {
  const TenantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailLayout(
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.transfer_within_a_station_outlined,
            color: MyConstants.primary100,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: MyConstants.dangerDarker,
            size: 30,
          ),
          onPressed: () {},
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MyConstants.brand400,
                  borderRadius: BorderRadius.circular(5),
                  // border: Border.all(
                  //   color: MyConstants.greyColor,
                  //   width: 1.5,
                  // ),
                ),
                child: const Icon(
                  Icons.person_outlined,
                  size: 40,
                  color: MyConstants.primary100,
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(
                      text: "Himanshu",
                      color: MyConstants.text100,
                      fontSize: 25,
                    ),
                    DescriptiveText(
                      text: "Khaitan",
                      color: MyConstants.text200,
                      fontSize: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400]!,
            thickness: 1,
            height: 30,
          ),
          const SectionHeader(text: "Details"),
          const SizedBox(height: 10),
          const InfoTag(
            item: "Room Number",
            value: "101",
          ),
          const InfoTag(
            item: "Phone Number",
            value: "6203059082",
          ),
          const InfoTag(
            item: "Joining Date",
            value: "21-04-2024",
          ),
          Divider(
            color: Colors.grey[400]!,
            thickness: 1,
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SectionHeader(text: "Transaction History"),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: MyConstants.primary100,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return TransactionTile();
              },
            ),
          )
        ],
      ),
    );
  }
}

class InfoTag extends StatelessWidget {
  final String item;
  final String value;
  const InfoTag({
    super.key,
    required this.item,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
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
            text: item,
            color: MyConstants.text200,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(width: 10),
          DescriptiveText(
            text: value,
            color: MyConstants.text100,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
