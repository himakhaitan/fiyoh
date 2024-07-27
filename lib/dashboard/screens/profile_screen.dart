import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/app_entry/auth/bloc/auth_bloc.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/error_message.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/common_widgets/section_header.dart';
import 'package:fiyoh/common_widgets/text_link_button.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/layouts/detail/detail_layout.dart';
import 'package:fiyoh/constants/enums.dart';
import 'package:fiyoh/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DetailLayout(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            if (state.user.userType == null) {
              Navigator.of(context).pushNamed("/user-type");
            }
            return ProfileSection(user: state.user);
          } else if (state is AuthInitial) {
            context.read<AuthBloc>().add(RefreshState());
            return const ProgressLoader();
          } else if (state is AuthFailure) {
            return ErrorMessage(message: state.error);
          } else {
            return const ProgressLoader();
          }
        },
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final User user;
  const ProfileSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SectionHeader(
          text: "Profile",
          alignment: Alignment.center,
        ),
        const SizedBox(height: 20),
        // Circular Profile Picture from internet and Border
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: MyConstants.greyColor,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.profileUrl ??
                        "https://cdn.vectorstock.com/i/500p/45/59/profile-photo-placeholder-icon-design-in-gray-vector-37114559.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Name
        DescriptiveText(
          text: "${user.firstName} ${user.lastName}",
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: MyConstants.primaryColor,
        ),
        const SizedBox(height: 10),
        // Fed usertype in InfoItem
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MyConstants.blueMetallic.withOpacity(0.3),
          ),
          child: DescriptiveText(
            text: user.userType!.value,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(
          color: Colors.grey[400]!,
          thickness: 1,
          height: 30,
        ),
        ProfileDetailItem(
          item: "Email",
          value: user.email,
        ),
        Divider(
          color: Colors.grey[400]!,
          thickness: 1,
          height: 30,
        ),
        if (user.phoneNumber.isNotEmpty)
          ProfileDetailItem(
            item: "Phone Number",
            value: '${user.countryCode} ${user.phoneNumber}',
          ),
        if (user.phoneNumber.isNotEmpty)
          Divider(
            color: Colors.grey[400]!,
            thickness: 1,
            height: 30,
          ),
        ProfileDetailItem(
          item: "Properties",
          value: user.properties.length.toString(),
        ),
        Divider(
          color: Colors.grey[400]!,
          thickness: 1,
          height: 30,
        ),

        ProfileDetailItem(
          item: "Joined At",
          // Only pass date to the value
          value: user.joinedAt.toString().split(" ")[0],
        ),
        Divider(
          color: Colors.grey[400]!,
          thickness: 1,
          height: 30,
        ),
        ProfileDetailItem(
          item: "User ID",
          value: user.id,
        ),
        Divider(
          color: Colors.grey[400]!,
          thickness: 1,
          height: 30,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextLinkButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: user.id));
            },
            text: "Copy ID",
            color: MyConstants.primaryColor,
            bgColor: Colors.grey[100]!,
            fontSize: 14,
            icon: const Icon(
              Icons.copy,
              color: MyConstants.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileDetailItem extends StatelessWidget {
  const ProfileDetailItem({
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
