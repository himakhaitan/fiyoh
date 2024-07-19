import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/header_text.dart';
import 'package:rentwise/common_widgets/progress_loader.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/layouts/detail/detail_layout.dart';
import 'package:rentwise/models/room.dart';
import 'package:rentwise/room/bloc/room_bloc.dart';
import 'package:rentwise/tenant/screens/tenant_detail_screen.dart';

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
  List<String> tenants = [];

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
              height: 40,
            ),
            const SectionHeader(text: "Tenants"),
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
                          return TenantItem(name: tenants[index]);
                        },
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
          DescriptiveText(
            text: name,
            color: MyConstants.accentColor,
          ),
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
