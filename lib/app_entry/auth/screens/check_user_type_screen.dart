import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/app_entry/auth/bloc/auth_bloc.dart';
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/error_message.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:fiyoh/constants/enums.dart';
import 'package:fiyoh/layouts/auth/auth_layout.dart';

class CheckUserTypeScreen extends StatefulWidget {
  const CheckUserTypeScreen({super.key});

  @override
  State<CheckUserTypeScreen> createState() => _CheckUserTypeScreenState();
}

class _CheckUserTypeScreenState extends State<CheckUserTypeScreen> {
  String _selectedUserType = UserType.owner.value;
  bool _isLoading = false;
  String _error = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else if (state is AuthFailure) {
          setState(() {
            _error = state.error;
            _isLoading = false;
          });
        } else if (state is AuthLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is AuthInitial) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: AuthLayout(
        showLeading: false,
        title: "You are almost there!",
        description: "Please select to complete the onboarding process",
        container: Column(
          children: [
            RadioListTile(
              fillColor: WidgetStateProperty.all(MyConstants.primary100),
              title: const DescriptiveText(text: "I am an Owner"),
              value: UserType.owner.value,
              groupValue: _selectedUserType,
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value!;
                });
              },
            ),
            RadioListTile(
              fillColor: WidgetStateProperty.all(MyConstants.primary100),
              title: const DescriptiveText(text: "I am a Manger"),
              value: UserType.manager.value,
              groupValue: _selectedUserType,
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value!;
                });
              },
            ),
            if (_error.isNotEmpty) ErrorMessage(message: _error),
          ],
        ),
        button: _isLoading
            ? const ProgressLoader()
            : LongButton(
                text: "Complete Onboarding",
                buttonColor: MyConstants.primary100,
                textColor: MyConstants.text400,
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(CheckUserTypeEvent(userType: _selectedUserType));
                },
              ),
      ),
    );
  }
}
