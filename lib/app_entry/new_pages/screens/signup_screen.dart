import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/phone_number_input.dart';
import 'package:rentwise/services/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/layouts/auth/auth_layout.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
        button: LongButton(
          text: "Sign Up",
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
          buttonColor: MyConstants.accentColor,
          textColor: MyConstants.whiteColor,
        ),
      ),
    );
  }
}

class SignUpOptions extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

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
          // const SizedBox(height: 20),
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
