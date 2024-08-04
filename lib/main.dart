import 'package:fiyoh/app_entry/auth/screens/check_user_type_screen.dart';
import 'package:fiyoh/app_entry/auth/screens/login_screen.dart';
import 'package:fiyoh/app_entry/new_pages/screens/welcome_screen.dart';
import 'package:fiyoh/app_entry/auth/screens/signup_screen.dart';
import 'package:fiyoh/auth_wrapper.dart';
import 'package:fiyoh/dashboard/screens/profile_screen.dart';
import 'package:fiyoh/property/bloc/property_bloc.dart';
import 'package:fiyoh/dashboard/screens/dashboard.dart';
import 'package:fiyoh/app_entry/auth/screens/forgot_password_screen.dart';
import 'package:fiyoh/property/screens/add_new_property_screen.dart';
import 'package:fiyoh/property/screens/add_new_tenant_screen.dart';
import 'package:fiyoh/app_entry/auth/bloc/auth_bloc.dart';
import 'package:fiyoh/tenant/bloc/tenant_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fiyoh/support/support_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Ensures that the Flutter binding system is fully set up before
  // any asynchronous operations that depend on it are performed
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // System Chrome Settings
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  // App Initialization
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fiyoh',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const LoginScreen(),
          ),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const SignupScreen(),
          ),
        );
      case '/forgot_password':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const ForgotPasswordScreen(),
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => PropertyBloc(),
              ),
              BlocProvider(
                create: (context) => AuthBloc(),
              ),
              BlocProvider(
                create: (context) => TenantBloc(),
              ),
            ],
            child: const Dashboard(),
          ),
        );
      case '/property/add':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => PropertyBloc(),
            child: const AddNewPropertyScreen(),
          ),
        );
      case '/tenant/add':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => PropertyBloc(),
            child: const AddNewTenantScreen(),
          ),
        );
      // case '/tenant/details':
      //   return MaterialPageRoute(
      //     builder: (context) => const TenantDetailScreen(),
      //   );
      case '/onboarding/user_type':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const CheckUserTypeScreen(),
          ),
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const ProfileScreen(),
          ),
        );
      case '/support':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const SupportScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
    }
  }
}
