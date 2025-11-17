import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairtech/core/base/controllers/auth_controller.dart';
import 'package:hairtech/core/base/util/size_config.dart';

class AuthWrapper extends GetView<AuthController> {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}