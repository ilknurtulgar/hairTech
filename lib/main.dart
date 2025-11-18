import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hairtech/views/auth_wrapper.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/base/util/app_bindings.dart';
import 'firebase_options.dart';
import 'product/message/show/show_messages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('tr_TR', null);
  CameraDescription? frontCamera;
  try {
    final cameras = await availableCameras();
    frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
  } on CameraException catch (e) {
    ShowMessages.logError(e.code, e.description);
  }

  // 4. Run the App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. REMOVED MultiProvider
    // 6. CHANGED to GetMaterialApp
    return GetMaterialApp(
      title: 'Hairtech',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,

      // 7. Add Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
      ],
      locale: const Locale('tr', 'TR'),

      // 8. Add initial bindings
      // This tells GetX to run your AppBindings class
      // as soon as the app starts, loading all your controllers.
      initialBinding: AppBindings(),

      // 9. AuthWrapper is now the home page.
      // It will be simpler.
      home: const AuthWrapper(),
    );
  }
}
