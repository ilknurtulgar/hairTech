import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/view/base_view.dart';

class ExampleViewModel extends GetxController {
  RxInt number = 0.obs;
  RxInt givenNumber = 2.obs;

  @override
  void onInit() {
    super.onInit();
    number.value = 53;
  }

  void increment() => number += 5;
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ExampleViewModel>(
      controller: ExampleViewModel(),
      onModelReady: (controller) {
        controller.givenNumber.value = 373;
      },
      buildPage: (context, controller) {
        return Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
              child: Column(
            children: [
              Obx(() => Text(controller.number.toString())),
              Text(controller.givenNumber.toString()),
              InkWell(
                onTap: () => controller.increment(),
                child: Container(
                  color: Colors.pink,
                  height: 100,
                  width: 100,
                ),
              )
            ],
          )),
        );
      },
    );
  }
}
