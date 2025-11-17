import 'package:flutter/material.dart';
import 'package:hairtech/core/base/components/appointment_informant_container.dart';
import 'package:hairtech/core/base/components/graphic_container.dart';
import 'package:hairtech/core/base/components/new_scheduled_appointments.dart';
import 'package:hairtech/core/base/providers/patient_home_provider.dart'; // <-- 1. Import
import 'package:hairtech/core/base/providers/user_provider.dart';
import 'package:hairtech/core/base/service/auth_service.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/const_texts.dart';
import 'package:hairtech/core/base/util/icon_utility.dart';
import 'package:hairtech/core/base/util/text_utility.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  State<PatientHomeView> createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  @override
  void initState() {
    super.initState();
    // 3. Start fetching data as soon as this page loads
    // We use read() here because we're in initState
    final user = context.read<UserProvider>().user;
    if (user != null) {
      context.read<PatientHomeProvider>().initStreams(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4. Get the providers
    final userProvider = context.watch<UserProvider>();
    final homeProvider = context.watch<PatientHomeProvider>(); // <-- 5. Watch new provider
    final authService = Provider.of<AuthService>(context, listen: false);

    // 6. Handle loading state
    if (userProvider.isLoading ||
        userProvider.user == null ||
        homeProvider.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 7. Get REAL data!
    final String patientName = userProvider.user!.name;
    final activeAppointment = homeProvider.activeAppointments.isNotEmpty
        ? homeProvider.activeAppointments.first
        : null;
    // 6. Get REAL data!
    final String patientFullName =
        "${userProvider.user!.name} ${userProvider.user!.surname}"; // <-- Updated

    // 8. Create Date Formatters
    final DateFormat scheduleFormat = DateFormat('dd/MM/yyyy, EEEE, HH.mm', 'tr_TR');
    final DateFormat commentFormat = DateFormat('dd/MM/yyyy - EEEE', 'tr_TR');
    final DateFormat uploadFormat = DateFormat('dd/MM/yyyy, EEEE', 'tr_TR');
    // Placeholder date, replace with user.lastUpdate
    final String nextUploadDate =
        uploadFormat.format(userProvider.user!.lastUpdate.toDate());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false, // Remove back button
        title: Text(
          "${ConstTexts.welcomeBack} $patientName!", // <-- Now shows full name
          style: TextUtility.getStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(AppIcons.logout, color: AppColors.secondary, size: 30),
            onPressed: () async {
              // --- 9. Implement Sign Out ---
              context.read<UserProvider>().clearUser();
              context.read<PatientHomeProvider>().clearData(); // <-- Clear new data
              await authService.signOut();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Graph Container
            /*const GraphicContainer(
                // You'll pass real data to this
                ),*/
            const SizedBox(height: 24),

            // 2. Info Cards (Sıradaki Yükleme & Doktoru Ara)
            /*Row(
              children: [
                Expanded(
                  child: AppointmentInformantContainer(
                    date: nextUploadDate, // <-- 10. Use real data
                    day: 11,
                    time: 
                    icon: AppIcons.uploadCheck,
                    text: ConstTexts.nextPhotoUpload,
                    backgroundColor: AppColors.informantCard,
                  ),
                ),
                const SizedBox(width: 16),
                _buildCallDoctorCard(),
              ],
            ),
            const SizedBox(height: 16),

            // 11. Aktif Randevu (Only show if one exists)
            if (activeAppointment != null)
              NewScheduledAppointments(
                date: scheduleFormat.format(activeAppointment.dateTime
                    .toDate()), // <-- 11. Use real data
                backgroundColor: AppColors.secondary,
                onTap: () {},
              ),
            if (activeAppointment != null) const SizedBox(height: 24),

            // 12. Doktorundan Son Yorumlar
            Text(
              ConstTexts.lastReviewsFromDoctor,
              style: TextUtility.getStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            // 13. Last Comment (Only show if one exists)
            if (lastComment != null)
              PatientProcessContainer(
                date: commentFormat
                    .format(lastComment.date.toDate()), // <-- 13. Use real data
                note: lastComment.doctorNote, // <-- 13. Use real data
                imagePaths: lastComment.imageURLs, // <-- 13. Use real data
                onTap: () {},
              )
            else
              const Center(child: Text("Henüz bir yorum bulunmuyor.")),
            */
            const SizedBox(height: 80), // Space for the bottom nav bar
          ],
        ),
      ),
    );
  }

  // Helper widget for the "Call Doctor" card
  Widget _buildCallDoctorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(AppIcons.call, color: AppColors.green, size: 30),
          const SizedBox(height: 8),
          Text(
            ConstTexts.callDoctor,
            style: TextUtility.getStyle(
              color: AppColors.green,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}