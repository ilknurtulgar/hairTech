import 'package:flutter/material.dart';
import 'package:hairtech/core/base/components/evaluation_item_container.dart';
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
      home: const EvaluationItemContainerTestView(),
    );
  }
}

class EvaluationItemContainerTestView extends StatelessWidget {
  const EvaluationItemContainerTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Evaluation Item Container Test'),
        backgroundColor: AppColors.dark,
        foregroundColor: AppColors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
            ],
          ),
        ),
      ),
    );
  }
}

