import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/app_entry/auth/bloc/auth_bloc.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/section_header.dart';
import 'package:fiyoh/common_widgets/text_link_button.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/stats/widgets/transaction_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: DescriptiveText(
                    text: "Hello, ${state.user.firstName}!",
                    color: MyConstants.text100,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                );
              } else {
                context.read<AuthBloc>().add(RefreshState());
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MyConstants.colorGray100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DescriptiveText(
                  text: "Earnings",
                  color: MyConstants.text100,
                  // color: MyConstants.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DescriptiveText(
                          text: "₹ 12,10,000",
                          color: MyConstants.text100,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                        DescriptiveText(
                          text: "This Month",
                          color: MyConstants.text200,
                          // color: MyConstants.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ],
                    ),
                    TextLinkButton(
                      onPressed: () {},
                      text: "View Details",
                      color: MyConstants.text400,
                      bgColor: MyConstants.primary100,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const HomeInfoItem(
                  label: "Total Properties",
                  value: "10",
                ),
                const SizedBox(height: 10),
                const HomeInfoItem(
                  label: "Total Earnings",
                  value: "₹ 1,20,000",
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomeDetailShort(
                label: "Tenants",
                value: "123",
              ),
              SizedBox(
                width: 10,
              ),
              HomeDetailShort(
                label: "Rooms",
                value: "100",
              ),
            ],
          ),
          const SizedBox(height: 30),
          const SectionHeader(
            text: "Recent Transactions",
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return TransactionItem(isCredit: false);
              },
              itemCount: 8,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeDetailShort extends StatelessWidget {
  final String label;
  final String value;

  const HomeDetailShort({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // color: Colors.grey[100],
          color: MyConstants.colorGray100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DescriptiveText(
              text: value,
              color: MyConstants.text100,
              // color: MyConstants.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
            const SizedBox(height: 10),
            DescriptiveText(
              text: label,
              color: MyConstants.text200,
              // color: MyConstants.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const HomeInfoItem({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DescriptiveText(
          text: label,
          color: MyConstants.text100,
          // color: MyConstants.primaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        DescriptiveText(
          text: value,
          color: MyConstants.text100,
          // color: MyConstants.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ],
    );
  }
}
