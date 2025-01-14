import 'package:fiyoh/common_widgets/info_item.dart';
import 'package:fiyoh/models/tenant.dart';
import 'package:fiyoh/utils/string_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/header_text.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/common_widgets/section_header.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/layouts/detail/detail_layout.dart';
import 'package:fiyoh/models/room.dart';
import 'package:fiyoh/room/bloc/room_bloc.dart';
import 'package:fiyoh/tenant/screens/tenant_detail_screen.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;
  final String propertyName;
  const RoomDetailScreen(
      {super.key, required this.room, required this.propertyName});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  bool _isLoading = false;
  String _error = "";
  List<Tenant> tenants = [];

  @override
  void initState() {
    super.initState();
    context.read<RoomBloc>().add(GetTenants(room: widget.room));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is RoomFailed) {
          setState(() {
            _isLoading = false;
            _error = state.error;
          });
        } else if (state is RoomLoaded) {
          setState(() {
            _isLoading = false;
            tenants = state.tenants;
          });
        }
      },
      child: DetailLayout(
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
                        text: widget.room.roomNumber,
                        color: MyConstants.accentColor,
                        fontSize: 35,
                      ),
                      DescriptiveText(
                        text: widget.propertyName,
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
            const SectionHeader(text: "Details"),
            const SizedBox(height: 10),
            Row(
              children: [
                InfoTag(
                  item: "Floor",
                  value: widget.room.floor.toString(),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: InfoTag(
                    item: "Occupancy",
                    value: widget.room.occupancy.toString(),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[400]!,
              thickness: 1,
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionHeader(text: "Tenants"),
                if (tenants.length < widget.room.occupancy)
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/tenant/add');
                    },
                    icon: const Icon(
                      Icons.add_circle_outline_outlined,
                      size: 25,
                    ),
                    color: MyConstants.primaryColor,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const ProgressLoader()
                : tenants.isEmpty
                    ? const DescriptiveText(
                        text: "No tenants found", color: MyConstants.greyColor)
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tenants.length,
                        itemBuilder: (context, index) {
                          return TenantItem(
                            tenant: tenants[index],
                            roomNumber: widget.room.roomNumber,
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}

class TenantItem extends StatelessWidget {
  final Tenant tenant;
  final String roomNumber;
  const TenantItem({
    super.key,
    required this.tenant,
    required this.roomNumber,
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
              color: MyConstants.accent100
            ),
            child:  Icon(
              tenant.gender == 'MALE' ? Icons.male : Icons.female,
              color: MyConstants.whiteColor,
            ),
          ),
          DescriptiveText(
            text: '${tenant.firstName} ${tenant.lastName}',
            color: MyConstants.accentColor,
          ),
          IconButton.filledTonal(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TenantDetailScreen(
                    tenant: tenant,
                    roomNumber: roomNumber,
                  ),
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
