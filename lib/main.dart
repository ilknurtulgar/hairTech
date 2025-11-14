import 'package:flutter/material.dart';
import 'core/base/components/person_info_container.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Basit (tıklanamaz, arrow yok)
            const PersonInfoContainer(
              title: 'Ahmet Yılmaz',
              subtitle: 'Müşteri',
            ),
            const SizedBox(height: 20),
            
            // 2. Tıklanabilir + Arrow
            PersonInfoContainer(
              title: 'Mehmet Demir',
              subtitle: 'Berber',
              showArrow: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mehmet Demir tıklandı!')),
                );
              },
            ),
            const SizedBox(height: 20),
            
            // 3. Tıklanabilir ama arrow yok
            PersonInfoContainer(
              title: 'Ayşe Kaya',
              subtitle: 'Randevu: 14:30',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ayşe Kaya tıklandı!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}