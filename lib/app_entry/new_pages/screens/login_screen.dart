import 'package:rentwise/common_widgets/descriptive_text.dart';
import 'package:rentwise/common_widgets/form_input.dart';
import 'package:rentwise/common_widgets/long_button.dart';
import 'package:rentwise/constants/colours.dart';
import 'package:rentwise/layouts/auth/auth_layout.dart';
import 'package:rentwise/services/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rentwise/common_widgets/text_link_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        title: "Log in to Your",
        subtitle: "RentWise Account!",
        container: SignInOptions(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
        ),
        button: Column(
          children: [
            LongButton(
              text: "Log In",
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const DescriptiveText(
                  text: "Don't have an account?",
                  color: MyConstants.primaryColor,
                ),
                TextLinkButton(
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

class SignInOptions extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

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
