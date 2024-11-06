import 'package:fiyoh/common_ui/alert_dialoge.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/models/tenant.dart';
import 'package:fiyoh/payments/bloc/payment_bloc.dart';
import 'package:fiyoh/payments/screens/add_payment_screen.dart';
import 'package:fiyoh/property/bloc/property_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/header_text.dart';
import 'package:fiyoh/common_widgets/section_header.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/layouts/detail/detail_layout.dart';
import 'package:fiyoh/tenant/widgets/transaction_tile.dart';
import 'package:fiyoh/utils/date_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TenantDetailScreen extends StatefulWidget {
  final Tenant tenant;
  final String? roomNumber;
  const TenantDetailScreen({super.key, required this.tenant, this.roomNumber});

  @override
  State<TenantDetailScreen> createState() => _TenantDetailScreenState();
}

class _TenantDetailScreenState extends State<TenantDetailScreen> {
  String _error = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyBloc, PropertyState>(
      listener: (context, state) {
        if (state is PropertyAPICompleted) {
          Navigator.popAndPushNamed(context, '/home');
        } else if (state is PropertyFailed) {
          setState(() {
            _error = state.error;
            isLoading = false;
          });
        } else if (state is PropertyLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: DetailLayout(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: MyConstants.dangerDarker,
              size: 30,
            ),
            onPressed: () {
              showAlertDialog(
                context: context,
                title: 'Remove Tenant',
                content: 'Are you sure you want to remove this tenant?',
                okayAction: () {
                  context
                      .read<PropertyBloc>()
                      .add(RemoveTenant(booking: widget.tenant.activeBooking));
                  // Navigator.pop(context);
                },
                okayText: 'Remove',
              );
            },
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: widget.tenant.firstName,
                        color: MyConstants.text100,
                        fontSize: 25,
                      ),
                      DescriptiveText(
                        text: widget.tenant.lastName,
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
            if (widget.roomNumber != null)
              InfoTag(
                item: "Room Number",
                value: widget.roomNumber!,
              ),
            InfoTag(
              item: "Phone Number",
              value: widget.tenant.phoneNumber,
            ),
            // Only show date of joining
            InfoTag(
              item: "Joining Date",
              value: formatDate(widget.tenant.activeBooking.checkInDate!),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => PaymentBloc(),
                          child: AddPaymentScreen(
                            bookingID: widget.tenant.activeBooking.id,
                            propertyID: widget.tenant.activeBooking.propertyId,
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: MyConstants.primary100,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (widget.tenant.activeBooking.transactions.isEmpty)
              const DescriptiveText(
                text: "No transactions yet",
                color: MyConstants.text200,
              ),
            isLoading
                ? const ProgressLoader()
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          widget.tenant.activeBooking.transactions.length,
                      itemBuilder: (context, index) {
                        return TransactionTile(
                          transaction:
                              widget.tenant.activeBooking.transactions[index],
                        );
                      },
                    ),
                  )
          ],
        ),
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
