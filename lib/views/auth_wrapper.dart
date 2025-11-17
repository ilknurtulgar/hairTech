import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hairtech/core/base/providers/patient_home_provider.dart';
import 'package:hairtech/core/base/providers/user_provider.dart';
import 'package:hairtech/views/main_navigation_view.dart';
import 'package:hairtech/views/welcome_view.dart';
import 'package:provider/provider.dart';
// import 'package:hairtech/core/base/util/size_config.dart'; // <-- REMOVED

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. REMOVED the LayoutBuilder. We will initialize SizeConfig
    // inside WelcomeView and MainNavigationView instead.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final User? user = snapshot.data;

        if (user == null) {
          // --- Logic on Logout ---
          context.read<UserProvider>().clearUser();
          context.read<PatientHomeProvider>().clearData();
          return const WelcomeView();
        }

        // --- Your FutureBuilder Logic ---
        return FutureBuilder(
          future: Provider.of<UserProvider>(context, listen: false)
              .fetchUserData(user.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            // Once data is fetched, show the main app
            return const MainNavigationView();
          },
        );
      },
    );
  }
}