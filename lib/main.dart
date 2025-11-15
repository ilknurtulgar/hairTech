import 'package:flutter/material.dart';
import 'package:hairtech/core/base/components/evaluation_bar.dart';
import 'package:hairtech/core/base/util/app_colors.dart';
import 'package:hairtech/core/base/util/size_config.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      title: 'Hairtech App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.background),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const EvaluationBarTestView(),
    );
  }
}

class EvaluationBarTestView extends StatelessWidget {
  const EvaluationBarTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Evaluation Bar Test'),
        backgroundColor: AppColors.dark,
        foregroundColor: AppColors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                EvaluationBar(
                  title: 'Uzama',
                
                  onValueChanged: (value) {
                    print('Uzama: $value');
                  },
                ),
                const SizedBox(height: 30),
                EvaluationBar(
                  title: 'Yoğunluk',
                   onValueChanged: (value) {
                    print('Yoğunluk: $value');
                  },
                ),
                const SizedBox(height: 30),
                EvaluationBar(
                  title: 'Doğallık',
               
                  onValueChanged: (value) {
                    print('Doğallık: $value');
                  },
                ),
                const SizedBox(height: 30),
                EvaluationBar(
                  title: 'Sağlık',
               
                  onValueChanged: (value) {
                    print('Sağlık: $value');
                  },
                ),
                const SizedBox(height: 30),
                EvaluationBar(
                  title: 'Genel',
                 
                  onValueChanged: (value) {
                    print('Genel: $value');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

