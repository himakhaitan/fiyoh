// Packages: Imports
import 'package:rentwise/app_entry/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/layouts/auth/auth_layout.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/common_widgets/form_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A screen for handling the forgot password functionality.
///
/// The [ForgotPasswordScreen] displays a form where the user can enter their
/// registered email address to reset their password. Upon submission, the
/// [AuthBloc] processes the reset password request.
///
/// Example usage:
/// ```dart
/// Navigator.push(
///     context,
///    MaterialPageRoute(builder: (context) => ForgotPasswordScreen())
/// );
/// ```
class ForgotPasswordScreen extends StatefulWidget {
  /// Creates a [ForgotPasswordScreen] Widget.
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

/// The state of the [ForgotPasswordScreen] widget.
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  /// Controller for the email input field.
  final TextEditingController emailController = TextEditingController();

  /// Form key for the forgot password form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          /// If the reset password event is successful, navigate to the home screen.
          Navigator.pushNamed(context, '/home');
        } else if (state is AuthFailure) {
          /// If the reset password event fails, show an error message.
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
          /// The onPressed function triggers the reset password event.
          onPressed: () {
            if (_formKey.currentState!.validate()) {
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

/// A widget that contains the input fields for the forgot password form.
///
/// The [ForgotPasswordOptions] widget provides a form with input fields
/// and validates the input.
///
/// Example usage:
/// ```dart
/// ForgotPasswordOptions(
///   emailController: emailController,
///   formKey: _formKey,
/// );
/// ```
class ForgotPasswordOptions extends StatelessWidget {
  /// The controller for the email input field.
  final TextEditingController emailController;

  /// The form key for the forgot password form.
  final GlobalKey<FormState> formKey;

  /// Creates a [ForgotPasswordOptions] widget.
  ///
  /// The [emailController] and [formKey] are required.
  /// The [emailController] must not be null.
  /// The [formKey] must not be null.
  /// The [formKey] must be a [GlobalKey] of type [FormState].
  /// The [emailController] must be a [TextEditingController].
  const ForgotPasswordOptions(
      {super.key, required this.emailController, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
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
