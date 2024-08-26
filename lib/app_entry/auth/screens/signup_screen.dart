// Packages: Imports
import 'package:fiyoh/common_widgets/descriptive_text.dart';
import 'package:fiyoh/common_widgets/error_message.dart';
import 'package:fiyoh/common_widgets/form_input.dart';
import 'package:fiyoh/common_widgets/google_button.dart';
import 'package:fiyoh/common_widgets/phone_number_input.dart';
import 'package:fiyoh/common_widgets/progress_loader.dart';
import 'package:fiyoh/app_entry/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fiyoh/common_widgets/text_divider.dart';
import 'package:fiyoh/common_widgets/text_link_button.dart';
import 'package:fiyoh/layouts/auth/auth_layout.dart';
import 'package:fiyoh/common_widgets/long_button.dart';
import 'package:fiyoh/constants/colours.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A screen for handling the signup functionality.
class SignupScreen extends StatefulWidget {
  /// Creates a [SignupScreen] widget.
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

/// The state of the [SignupScreen] widget.
class _SignupScreenState extends State<SignupScreen> {
  /// Form key for the signup form.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the first name input field.
  final TextEditingController _firstNameController = TextEditingController();

  /// Controller for the last name input field.
  final TextEditingController _lastNameController = TextEditingController();

  /// Controller for the phone number input field.
  final TextEditingController _phoneNumberController = TextEditingController();

  /// Controller for the email input field.
  final TextEditingController _emailController = TextEditingController();

  /// Controller for the password input field.
  final TextEditingController _passwordController = TextEditingController();

  /// Controller for the confirm password input field.
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  /// Boolean to check if the signup process is loading.
  bool _isLoading = false;

  /// Error message to display if the signup process fails.
  String _error = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          /// If the signup event is successful, navigate to the home screen.
          setState(() {
            _isLoading = false;
          });
          if (state.user.userType == null) {
            Navigator.pushReplacementNamed(context, '/onboarding/user_type');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else if (state is AuthFailure) {
          /// If the signup event fails, show an error message.
          setState(() {
            _isLoading = false;
            _error = state.error;
          });
        } else if (state is AuthLoading) {
          /// If the signup event is loading, show a progress loader.
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: AuthLayout(
        title: "Create Your",
        subtitle: "RentWise Account!",
        container: SignUpOptions(
          formKey: _formKey,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          phoneNumberController: _phoneNumberController,
          emailController: _emailController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
        ),
        button: Column(
          children: [
            if (_error.isNotEmpty) ErrorMessage(message: _error),
            if (_error.isNotEmpty) const SizedBox(height: 10),
            _isLoading
                ? const ProgressLoader()
                : LongButton(
                    text: "Sign Up",

                    /// The onPressed function triggers the signup event.
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              SignUpEvent(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                firstName: _firstNameController.text.trim(),
                                lastName: _lastNameController.text.trim(),
                                phoneNumber: _phoneNumberController.text.trim(),
                              ),
                            );
                      }
                    },
                    buttonColor: MyConstants.primary100,
                    textColor: MyConstants.text400,
                  ),
            const SizedBox(height: 15),
            const TextDivider(),
            const SizedBox(height: 15),
            GoogleButton(
              text: "Sign Up with Google",
              onPressed: () {
                context.read<AuthBloc>().add(GoogleSignUpEvent());
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const DescriptiveText(
                  text: "Already have an account?",
                  color: MyConstants.text100,
                ),
                TextLinkButton(
                  /// Navigate to the sign up screen.
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  text: "Sign In",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that contains the input fields for the signup form.
class SignUpOptions extends StatelessWidget {
  /// The form key for the signup form.
  final GlobalKey<FormState> formKey;

  /// The controller for the first name input field.
  final TextEditingController firstNameController;

  /// The controller for the last name input field.
  final TextEditingController lastNameController;

  /// The controller for the phone number input field.
  final TextEditingController phoneNumberController;

  /// The controller for the email input field.
  final TextEditingController emailController;

  /// The controller for the password input field.
  final TextEditingController passwordController;

  /// The controller for the confirm password input field.
  final TextEditingController confirmPasswordController;

  /// Creates a [SignUpOptions] widget.
  ///
  /// The [formKey], [firstNameController], [lastNameController], [phoneNumberController],
  /// [emailController], [passwordController], and [confirmPasswordController] parameters are required.
  /// The [formKey], [firstNameController], [lastNameController], [phoneNumberController],
  /// [emailController], [passwordController], and [confirmPasswordController] parameters must not be null.
  /// The [formKey] parameter must be a [GlobalKey] of type [FormState].
  /// The [firstNameController], [lastNameController], [phoneNumberController],
  /// [emailController], [passwordController], and [confirmPasswordController] parameters must be of type [TextEditingController].
  const SignUpOptions({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneNumberController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FormInput(
                  labelText: "First Name",
                  hintText: "First Name",
                  obscureText: false,
                  icon: Icons.person_2_outlined,
                  controller: firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    if (value.length < 3) {
                      return 'First name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FormInput(
                  labelText: "Last Name",
                  hintText: "Last Name",
                  obscureText: false,
                  controller: lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    if (value.length < 3) {
                      return 'Last name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          PhoneNumberInput(
            labelText: "Phone Number",
            hintText: "Enter Your Phone Number",
            controller: phoneNumberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length != 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          FormInput(
            labelText: "Email",
            hintText: "Enter Your Email",
            obscureText: false,
            icon: Icons.alternate_email_outlined,
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
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
            hintText: "Make sure your password is strong",
            obscureText: true,
            icon: Icons.lock_clock_outlined,
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          FormInput(
            labelText: "Confirm Password",
            hintText: "Reconfirm your password",
            obscureText: true,
            icon: Icons.password_outlined,
            controller: confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
