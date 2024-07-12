// Packages: Imports
import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/error_message.dart';
import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/google_button.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/common_widgets/progress_loader.dart';
import 'package:rentwise/common_widgets/text_divider.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/layouts/auth/auth_layout.dart';
import 'package:rentwise/app_entry/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/text_link_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A screen for handling the login functionality.
///
/// The [LoginScreen] displays a form where the user can enter their
/// email and password to login in to their account. It uses [AuthBloc] to handle
/// the authentication process.
///
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => LoginScreen())
/// );
/// ```
class LoginScreen extends StatefulWidget {
  /// Creates a [LoginScreen] widget.
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// The state of the [LoginScreen] widget.
class _LoginScreenState extends State<LoginScreen> {
  /// Form key for the login form.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the email input field.
  final TextEditingController _emailController = TextEditingController();

  /// Controller for the password input field.
  final TextEditingController _passwordController = TextEditingController();

  /// Boolean to check if the login process is loading.
  bool _isLoading = false;

  /// Error message to display if the login process fails.
  String _error = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          /// If the login event is successful, navigate to the home screen.
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(context, '/home');
        } else if (state is AuthFailure) {
          /// If the login event fails, show an error message.
          setState(() {
            _isLoading = false;
            print(state.error);
            _error = state.error;
          });
        } else if (state is AuthLoading) {
          /// If the login event is loading, show a progress loader.
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: AuthLayout(
        title: "Log in to Your",
        subtitle: "RentWise Account!",
        container: SignInOptions(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
        ),
        button: Column(
          children: [
            if (_error.isNotEmpty) ErrorMessage(message: _error),
            if (_error.isNotEmpty) const SizedBox(height: 10),
            _isLoading
                ? const ProgressLoader()
                : LongButton(
                    text: "Log In",

                    /// The onPressed function triggers the login event.
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              SignInEvent(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                    buttonColor: MyConstants.accentColor,
                    textColor: MyConstants.whiteColor,
                  ),
            const SizedBox(height: 15),
            const TextDivider(),
            const SizedBox(height: 15),
            GoogleButton(
              text: "Login with Google",
              onPressed: () {
                context.read<AuthBloc>().add(GoogleSignInEvent());
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const DescriptiveText(
                  text: "Don't have an account?",
                  color: MyConstants.primaryColor,
                ),
                TextLinkButton(
                  /// Navigate to the sign up screen.
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  text: "Sign Up",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that contains the input fields for the login form.
class SignInOptions extends StatelessWidget {
  /// The form key for the login form.
  final GlobalKey<FormState> formKey;

  /// The controller for the email input field.
  final TextEditingController emailController;

  /// The controller for the password input field.
  final TextEditingController passwordController;

  /// Creates a [SignInOptions] widget.
  ///
  /// The [formKey], [emailController], and [passwordController] are required.
  /// The [formKey], [emailController], and [passwordController] must not be null.
  /// The [formKey] must be a [GlobalKey] of type [FormState].
  /// The [emailController] and [passwordController] must be of type [TextEditingController].
  const SignInOptions({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // const SizedBox(height: 20),
          FormInput(
            labelText: "Email",
            hintText: "Enter Your Email",
            obscureText: false,
            icon: Icons.person_2_outlined,
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              bool isValid =
                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
              if (!isValid) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          FormInput(
            labelText: "Password",
            hintText: "Enter Your Password",
            obscureText: true,
            icon: Icons.password_outlined,
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              return null;
            },
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextLinkButton(
              /// Navigate to the forgot password screen.
              onPressed: () {
                Navigator.pushNamed(context, '/forgot_password');
              },
              text: "Forgot Password?",
            ),
          ),
        ],
      ),
    );
  }
}
