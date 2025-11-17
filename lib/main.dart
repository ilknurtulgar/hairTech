import 'package:flutter/material.dart';
import 'package:hairtech/core/base/providers/patient_home_provider.dart';
import 'package:hairtech/core/base/providers/user_provider.dart';
import 'package:hairtech/core/base/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:hairtech/views/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // 1. Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. Provide all your services/providers to the entire app
    return MultiProvider(
      providers: [
        // Services (plain classes)
        Provider<AuthService>(create: (context) => AuthService()),
        
        // State Notifiers (ChangeNotifier)
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PatientHomeProvider()),
      ],
      child: MaterialApp(
        title: 'Hairtech',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Inter', // Sets the default font for the whole app
        ),
        debugShowCheckedModeBanner: false,
        
        // 5. AuthWrapper handles all auth state and SizeConfig initialization
        home: const AuthWrapper(),
      ),
    );
  }
}