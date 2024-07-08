import 'package:rentwise/common_widgets/dropdown.dart';
import 'package:rentwise/common_widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/text_link_button.dart';
import 'package:rentwise/constants/colours.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  String _selectedStatus = "";

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
                // TextLinkButton(onPressed: () {}, text: "Search"),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: Icon(Icons.search),
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
                    onChanged: (value) {},
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
            const SizedBox(height: 10),
            const SectionHeader(text: "Rent Details"),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}

/*

  Details that need to be displayed in the RoomTile:
  Header: Property Name
  - Room Number
  - Tenants List
    - Bed Status (Empty, Paid, Pending)
    
  - Status of Payment for everyone in the room
  - Button to Add Rent Payment


*/