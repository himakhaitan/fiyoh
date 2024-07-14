import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/text_link_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/tenant/widgets/tenant_tile.dart';

class TenantsScreen extends StatelessWidget {
  const TenantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              DropdownInput(
                labelText: "Property",
                items: ["Green Homes Platina", "Krishna Kunj"],
                onChanged: (value) {},
                starter: "Select Property",
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownInput(
                      labelText: "Period",
                      items: const ["Current Month", "Last Month"],
                      onChanged: (value) {},
                      starter: "Select Period",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownInput(
                      labelText: "Payment Status",
                      items: const ["All", "Paid", "Unpaid"],
                      onChanged: (value) {},
                      starter: "Select Status",
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextLinkButton(
                  bgColor: Colors.grey[200]!,
                  color: MyConstants.primaryColor,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search_outlined,
                    color: MyConstants.primaryColor,
                  ),
                  text: "Search",
                ),
              ),
            ],
          ),
        ),
        Expanded(child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const TenantTile();
          },
        )),
      ],
    );
  }
}

