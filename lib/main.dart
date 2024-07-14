import 'package:rentwise/app_entry/auth/screens/login_screen.dart';
import 'package:rentwise/app_entry/new_pages/screens/welcome_screen.dart';
import 'package:rentwise/app_entry/auth/screens/signup_screen.dart';
import 'package:rentwise/property/bloc/property_bloc.dart';
import 'package:rentwise/dashboard/screens/dashboard.dart';
import 'package:rentwise/app_entry/auth/screens/forgot_password_screen.dart';
import 'package:rentwise/property/screens/add_new_property_screen.dart';
import 'package:rentwise/property/screens/add_new_tenant_screen.dart';
import 'package:rentwise/app_entry/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentwise/room/screens/room_detail_screen.dart';
import 'package:rentwise/tenant/screens/tenant_detail_screen.dart';
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
      title: 'Rentwise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
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
      case '/room/details':
        return MaterialPageRoute(
          builder: (context) => const RoomDetailScreen(),
        );
      case '/tenant/details':
        return MaterialPageRoute(
          builder: (context) => const TenantDetailScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
    }
  }
}
