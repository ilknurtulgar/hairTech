import 'package:flutter/material.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'core/base/components/question_container.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.background),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // QuestionContainer örnekleri
              QuestionContainer(
                questionNumber: 1,
                questionText: 'Ailenizde saç dökülmesi sorunu var mı?',
                onAnswerChanged: (answer) {
                  print('Soru 1 cevap: ${answer == true ? "Evet" : "Hayır"}');
                },
              ),
              const SizedBox(height: 20),
              
              QuestionContainer(
                questionNumber: 2,
                questionText: 'Düzenli ilaç kullanıyor musunuz?',
                onAnswerChanged: (answer) {
                  print('Soru 2 cevap: ${answer == true ? "Evet" : "Hayır"}');
                },
              ),
              const SizedBox(height: 20),
              
              QuestionContainer(
                questionNumber: 3,
                questionText: 'Stresli bir dönem geçiriyor musunuz?',
                onAnswerChanged: (answer) {
                  print('Soru 3 cevap: ${answer == true ? "Evet" : "Hayır"}');
                },
              ),
              const SizedBox(height: 20),
              
              QuestionContainer(
                questionNumber: 4,
                questionText: 'Saç bakım ürünleri kullanıyor musunuz?',
                onAnswerChanged: (answer) {
                  print('Soru 4 cevap: ${answer == true ? "Evet" : "Hayır"}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}