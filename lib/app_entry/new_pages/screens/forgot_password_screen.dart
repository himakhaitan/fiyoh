import 'package:rentwise/services/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/layouts/auth/auth_layout.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/common_widgets/form_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushNamed(context, '/home');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: AuthLayout(
        title: "Forgot your Password?",
        description:
            "Please enter your registered email address to reset your password",
        container: ForgotPasswordOptions(
          emailController: emailController,
          formKey: _formKey,
        ),
        button: LongButton(
          text: "Reset Password",
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Handle password reset
              context.read<AuthBloc>().add(
                    ResetPasswordEvent(
                      email: emailController.text.trim(),
                    ),
                  );
            }
          },
          buttonColor: MyConstants.accentColor,
          textColor: MyConstants.whiteColor,
        ),
      ),
    );
  }
}

class ForgotPasswordOptions extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  const ForgotPasswordOptions(
      {super.key, required this.emailController, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // const SizedBox(height: 20),
          FormInput(
            labelText: "Email Address",
            hintText: "Enter Your Email Address",
            obscureText: false,
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
