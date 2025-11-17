import 'package:flutter/material.dart';
import 'package:hairtech/core/base/providers/doctor_home_provider.dart';
import 'package:hairtech/core/base/providers/user_provider.dart';
import 'package:hairtech/core/base/service/auth_service.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/size_config.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:provider/provider.dart';
import 'package:hairtech/core/base/util/padding_util.dart'; // <-- 1. Import Padding

class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  State<PatientHomeView> createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  @override
  void initState() {
    super.initState();
    // Start fetching data as soon as this page loads
    final user = context.read<UserProvider>().user;
    if (user != null) {
      // Use read() here because we're in initState
      context.read<DoctorHomeProvider>().initStreams(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get the providers
    final userProvider = context.watch<UserProvider>();
    final authService = Provider.of<AuthService>(context, listen: false);

    // 2. Handle loading state
    if (userProvider.isLoading || userProvider.user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background, // Use background color
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 3. Get REAL data!
    final userName =
        "Dr. ${userProvider.user!.name}";

    // 4. REMOVED the AppBar
    return Scaffold(
      backgroundColor: AppColors.background, // Use light background
      // 5. ADD SafeArea to respect phone notches
      body: SafeArea(
        // 6. ADD Padding to wrap all content
        child: Padding(
          padding: ResponsePadding.page(), // <-- Use your static padding
          child: Column(
            children: [
              // 7. This Row re-creates your old AppBar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${ConstTexts.welcomeBack}\n$userName!",
                    style: TextUtility.getStyle(
                      fontSize: SizeConfig.responsiveWidth(36),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(AppIcons.logout,
                        color: AppColors.secondary, size: 30),
                    onPressed: () async {
                      // Implement Sign Out
                      context.read<UserProvider>().clearUser();
                      // Clear home page data on logout
                      context.read<DoctorHomeProvider>().clearData();
                      await authService.signOut();
                    },
                  ),
                ],
              ),
              // 8. This is the rest of your page body
              const Expanded(
                child: Center(
                  child: Text(""), // Placeholder for now
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}