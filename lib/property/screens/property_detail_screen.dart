import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/common_widgets/tag_item.dart';
import 'package:rentwise/common_widgets/text_link_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/constants/enums.dart';
import 'package:rentwise/layouts/detail/detail_layout.dart';
import 'package:rentwise/models/property.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DetailLayout(
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.ios_share_outlined,
            color: MyConstants.primaryColor,
          ),
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
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
                  ),
                  child: const Icon(
                    Icons.apartment_outlined,
                    size: 40,
                    color: MyConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: widget.property.propertyName,
                        color: MyConstants.accentColor,
                        fontSize: 20,
                      ),
                      DescriptiveText(
                        text:
                            '${widget.property.city}, ${widget.property.state}',
                        color: MyConstants.greyColor,
                        fontSize: 16,
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
            const DescriptiveText(
              text: 'Address',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 10),
            DescriptiveText(
              text:
                  '${widget.property.streetAddress}, ${widget.property.city}, ${widget.property.state}, India, ${widget.property.pincode}',
              color: MyConstants.greyColor,
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 1,
              height: 30,
            ),
            PropertyDetailItem(
              item: "Property Type",
              value: widget.property.propertyType.value,
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 1,
              height: 30,
            ),
            PropertyDetailItem(
              item: "Rooms",
              value: widget.property.totalRooms.toString(),
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 1,
              height: 30,
            ),
            PropertyDetailItem(
              item: "Tenants",
              value: widget.property.totalTenants.toString(),
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 1,
              height: 30,
            ),
            if (widget.property.managerId != null)
              PropertyDetailItem(
                item: "Manager",
                value: widget.property.managerId!,
              ),
            if (widget.property.managerId != null)
              Divider(
                color: Colors.grey[400]!,
                thickness: 1,
                height: 30,
              ),
            PropertyDetailItem(
                item: "Created At",
                value: widget.property.createdAt.toString().split(" ")[0]),
            Divider(
              color: Colors.grey[400]!,
              thickness: 1,
              height: 30,
            ),
            const DescriptiveText(
              text: 'Facilities',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                if (widget.property.facilities['is_cctv'] != null &&
                    widget.property.facilities['is_cctv'] == true)
                  const TagItem(
                      text: "CCTV", color: MyConstants.lightGreyColor),
                if (widget.property.facilities['is_cleaning'] != null &&
                    widget.property.facilities['is_cleaning'] == true)
                  const TagItem(
                      text: "Cleaning", color: MyConstants.lightGreyColor),
                if (widget.property.facilities['is_common_area'] != null &&
                    widget.property.facilities['is_common_area'] == true)
                  const TagItem(
                      text: "Common Area", color: MyConstants.lightGreyColor),
                if (widget.property.facilities['is_food'] != null &&
                    widget.property.facilities['is_food'] == true)
                  const TagItem(
                      text: "Food", color: MyConstants.lightGreyColor),
                if (widget.property.facilities['is_gym'] != null &&
                    widget.property.facilities['is_gym'] == true)
                  const TagItem(text: "Gym", color: MyConstants.lightGreyColor),
                if (widget.property.facilities['is_laundry'] != null &&
                    widget.property.facilities['is_laundry'] == true)
                  const TagItem(
                      text: "Laundry", color: MyConstants.lightGreyColor),
                if (widget.property.facilities['is_parking'] != null &&
                    widget.property.facilities['is_parking'] == true)
                  const TagItem(
                      text: "Parking", color: MyConstants.lightGreyColor),
                if (widget.property.facilities['is_power_backup'] != null &&
                    widget.property.facilities['is_power_backup'] == true)
                  const TagItem(
                      text: "Parking", color: MyConstants.lightGreyColor),
                if (widget.property.facilities['is_security'] != null &&
                    widget.property.facilities['is_security'] == true)
                  const TagItem(
                      text: "Security", color: MyConstants.lightGreyColor),
                if (widget.property.facilities['is_wifi'] != null &&
                    widget.property.facilities['is_wifi'] == true)
                  const TagItem(
                      text: "Wi-Fi", color: MyConstants.lightGreyColor),
              ],
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 1,
              height: 30,
            ),
            const DescriptiveText(
              text: 'Amenities',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                if (widget.property.amenities['is_ac'] != null &&
                    widget.property.amenities['is_ac'] == true)
                  const TagItem(
                      text: "Air Conditioner",
                      color: MyConstants.lightGreyColor),
                if (widget.property.amenities['is_chair'] != null &&
                    widget.property.amenities['is_chair'] == true)
                  const TagItem(
                      text: "Chair", color: MyConstants.lightGreyColor),
                if (widget.property.amenities['is_fridge'] != null &&
                    widget.property.amenities['is_fridge'] == true)
                  const TagItem(
                      text: "Fridge", color: MyConstants.lightGreyColor),
                if (widget.property.amenities['is_geyser'] != null &&
                    widget.property.amenities['is_geyser'] == true)
                  const TagItem(
                      text: "Geyser", color: MyConstants.lightGreyColor),
                if (widget.property.amenities['is_mattress'] != null &&
                    widget.property.amenities['is_mattress'] == true)
                  const TagItem(
                      text: "Mattress", color: MyConstants.lightGreyColor),
                if (widget.property.amenities['is_table'] != null &&
                    widget.property.amenities['is_table'] == true)
                  const TagItem(
                      text: "Table", color: MyConstants.lightGreyColor),
                if (widget.property.amenities['is_tv'] != null &&
                    widget.property.amenities['is_tv'] == true)
                  const TagItem(
                      text: "Television", color: MyConstants.lightGreyColor),
                if (widget.property.amenities['is_wardrobe'] != null &&
                    widget.property.amenities['is_wardrobe'] == true)
                  const TagItem(
                      text: "Wardrobe", color: MyConstants.lightGreyColor),
                if (widget.property.amenities['is_washing_machine'] != null &&
                    widget.property.amenities['is_washing_machine'] == true)
                  const TagItem(
                      text: "Washing Machine",
                      color: MyConstants.lightGreyColor),
              ],
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 1,
              height: 30,
            ),
            const DescriptiveText(
              text: 'Accepted Payment Methods',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                if (widget.property.paymentOptions['is_bank_transfer'] !=
                        null &&
                    widget.property.paymentOptions['is_bank_transfer'] == true)
                  const TagItem(
                      text: "Bank Transfer", color: MyConstants.lightGreyColor),
                if (widget.property.paymentOptions['is_cash'] != null &&
                    widget.property.paymentOptions['is_cash'] == true)
                  const TagItem(
                      text: "Cash", color: MyConstants.lightGreyColor),
                if (widget.property.paymentOptions['is_credit_card'] != null &&
                    widget.property.paymentOptions['is_credit_card'] == true)
                  const TagItem(
                      text: "Credit Card", color: MyConstants.lightGreyColor),
                if (widget.property.paymentOptions['is_debit_card'] != null &&
                    widget.property.paymentOptions['is_debit_card'] == true)
                  const TagItem(
                      text: "Debit Card", color: MyConstants.lightGreyColor),
                if (widget.property.paymentOptions['is_upi'] != null &&
                    widget.property.paymentOptions['is_upi'] == true)
                  const TagItem(text: "UPI", color: MyConstants.lightGreyColor),
              ],
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 1,
              height: 30,
            ),
            if (widget.property.rules.isNotEmpty)
              const DescriptiveText(
                text: 'Rules',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            if (widget.property.rules.isNotEmpty) const SizedBox(height: 10),
            if (widget.property.rules.isNotEmpty)
              for (String rule in widget.property.rules)
                RuleItem(rule: rule),
            if (widget.property.rules.isNotEmpty)
              Divider(
                color: Colors.grey[400]!,
                thickness: 1,
                height: 30,
              ),
            if (widget.property.managerId == null)
              LongButton(
                text: "Assign Manager",
                onPressed: () {},
                textColor: MyConstants.whiteColor,
                buttonColor: MyConstants.primaryColor,
              ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: TextLinkButton(
                onPressed: () {},
                text: "Delete Property",
                color: MyConstants.redColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RuleItem extends StatelessWidget {
  final String rule;

  const RuleItem({
    super.key,
    required this.rule,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.circle_outlined,
          size: 10,
          color: MyConstants.primaryColor,
        ),
        const SizedBox(width: 10),
        DescriptiveText(
          text: rule,
          color: MyConstants.greyColor,
        ),
      ],
    );
  }
}

class PropertyDetailItem extends StatelessWidget {
  const PropertyDetailItem({
    super.key,
    required this.item,
    required this.value,
  });

  final String item, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DescriptiveText(
          text: item,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(width: 10),
        DescriptiveText(
          text: value,
          color: MyConstants.greyColor,
        ),
      ],
    );
  }
}
