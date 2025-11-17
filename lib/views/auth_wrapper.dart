import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hairtech/core/base/providers/user_provider.dart';
import 'package:hairtech/views/main_navigation_view.dart';
import 'package:hairtech/views/welcome_view.dart';
import 'package:provider/provider.dart';
import 'package:hairtech/core/base/util/size_config.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // --- THIS IS THE NEW, ROBUST FIX ---
    // We use a LayoutBuilder. This 'builder' function is
    // guaranteed to run *after* the Scaffold/MaterialApp
    // has a valid size and context.
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. Initialize SizeConfig here, using the
        // context from the LayoutBuilder.
        SizeConfig.init(context);

        // 2. Now that SizeConfig is ready, build the
        // rest of your app (the StreamBuilder).
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // 1. Check for connection state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final User? user = snapshot.data;

            // 2. If user is LOGGED OUT
            if (user == null) {
              return const WelcomeView();
            }

            // 3. If user is LOGGED IN
            // Use a FutureBuilder to fetch their data
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
      },
    );
  }
}