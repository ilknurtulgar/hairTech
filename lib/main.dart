import 'package:flutter/material.dart';
import 'core/base/components/person_info_container.dart';
import 'core/base/components/result_information_container.dart';
import 'core/base/util/size_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hairtech App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Hides the debug banner
      home: const PersonInfoContainerTestView(), // Test view
    );
  }
}

class PersonInfoContainerTestView extends StatelessWidget {
  const PersonInfoContainerTestView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('PersonInfoContainer Test'),
      ),
      body:const SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:   // 4. ResultInformationContainer - Uzun text örneği
              const ResultInformationContainer(
                text:
                    "Randevunuz başarıyla oluşturuldu. Tarih: 15 Kasım 2025, Saat: 14:30. Berber: Mehmet De Lütfen randevu saatinden 10 dakika önce hazır olunuz",
              ),
        ),
      ),
    );
  }
}