import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/error_message.dart';
import 'package:rentwise/common_widgets/info_item.dart';
import 'package:rentwise/common_widgets/progress_loader.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/models/rent_data.dart';
import 'package:rentwise/rent/bloc/rent_bloc.dart';
import 'package:rentwise/rent/screens/rent_detail_screen.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  String _selectedStatus = "";
  String _selectedPeriod = "";

  @override
  void initState() {
    super.initState();

    context.read<RentBloc>().add(GetRentData());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionHeader(text: "Filters"),
                IconButton.filledTonal(
                  onPressed: () {
                    // Perform search
                  },
                  icon: const Icon(Icons.search),
                  // Change tone color
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownInput(
                    labelText: "Period",
                    items: const ["Last Month", "Last 3 Months"],
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value;
                      });
                    },
                    starter: "Current Month",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownInput(
                    labelText: "Status",
                    items: const ["Paid", "Pending"],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    starter: "All",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SectionHeader(text: "Rent Details"),
            const SizedBox(height: 10),
            BlocBuilder<RentBloc, RentState>(
              builder: (context, state) {
                if (state is RentLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.rentDataList.length,
                    itemBuilder: (context, index) {
                      return RentRoomTile(rentData: state.rentDataList[index]);
                    },
                  );
                } else if (state is RentFailed) {
                  return ErrorMessage(message: state.error);
                } else if (state is RentLoading) {
                  return const ProgressLoader();
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RentRoomTile extends StatelessWidget {
  final RentData rentData;
  const RentRoomTile({
    super.key,
    required this.rentData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
              color: Colors.grey[200],
            ),
            child: Center(
              child: DescriptiveText(
                text: rentData.roomNumber,
                fontSize: 18,
                color: MyConstants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoItems(
                  text: rentData.propertyName,
                  icon: Icons.home_outlined,
                ),
                InfoItems(
                  text: "${rentData.tenants.length} Tenants",
                  icon: Icons.people_outline,
                ),
                InfoItems(
                  text: rentData.roomStatus,
                  icon: Icons.monetization_on_outlined,
                  color: (rentData.roomStatus == 'Pending')
                      ? MyConstants.errorMetallic
                      : MyConstants.successMetallic,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RentDetailScreen(),
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
