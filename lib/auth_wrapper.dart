import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/app_entry/auth/bloc/auth_bloc.dart';
import 'package:rentwise/app_entry/new_pages/screens/welcome_screen.dart';
import 'package:rentwise/dashboard/screens/dashboard.dart';
import 'package:rentwise/property/bloc/property_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => PropertyBloc(),
              ),
              BlocProvider(
                create: (context) => AuthBloc(),
              ),
            ],
            child: const Dashboard(),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('An error occurred.'),
            ),
          );
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
