import 'package:fiyoh/models/tenant.dart';
import 'package:fiyoh/tenant/screens/tenant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/info_item.dart';
import 'package:fiyoh/constants/colours.dart';

class TenantTile extends StatelessWidget {
  final Tenant tenant;
  const TenantTile({super.key, required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyConstants.colorGray200,
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
              color: MyConstants.primary100,
            ),
            child: const Icon(
              Icons.person_4_rounded,
              color: MyConstants.primary400,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                InfoItem(
                  text: '${tenant.firstName} ${tenant.lastName}',
                  icon: Icons.person_2_outlined,
                ),
                InfoItem(
                  text: "Room 101",
                  icon: Icons.meeting_room_outlined,
                ),
                InfoItem(
                  text: "Paid",
                  icon: Icons.currency_rupee_outlined,
                  color: MyConstants.successLightest,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TenantDetailScreen(tenant: tenant),
                ),
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
