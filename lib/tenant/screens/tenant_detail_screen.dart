import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/layouts/detail/detail_layout.dart';
import 'package:rentwise/tenant/widgets/transaction_tile.dart';

class TenantDetailScreen extends StatelessWidget {
  const TenantDetailScreen({super.key});

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
                  Icons.person_outlined,
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
                      text: "Himanshu",
                      color: MyConstants.accentColor,
                      fontSize: 25,
                    ),
                    DescriptiveText(
                      text: "Khaitan",
                      color: MyConstants.greyColor,
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
          SectionHeader(text: "Details"),
          const SizedBox(height: 10),
          InfoTag(
                item: "Room Number",
                value: "101",
              ),
              InfoTag(
                item: "Phone Number",
                value: "6203059082",
              ),
              InfoTag(
                item: "Joining Date",
                value: "21-04-2024",
              ),
         
          Divider(
            color: Colors.grey[400]!,
            thickness: 1,
            height: 30,
          ),
          SectionHeader(text: "Transaction History"),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 247, 247, 247),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        // border: Border(
        //   bottom: BorderSide(
        //     color: Colors.grey[100]!,
        //     width: 1.5,
        //   ),
        // ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DescriptiveText(
            text: item,
            color: MyConstants.accentColor,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(width: 10),
          DescriptiveText(
            text: value,
            color: MyConstants.greyColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
