import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseView<T extends GetxController> extends StatefulWidget {
  final T controller;
  final void Function(T controller)? onModelReady;
  final Widget Function(BuildContext context, T controller) buildPage;

  const BaseView({
    super.key,
    required this.controller,
    this.onModelReady,
    required this.buildPage
  });

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends GetxController> extends State<BaseView<T>> {
  @override
  void initState() {
    super.initState();
    widget.controller.onInit();
    if (widget.onModelReady != null) {
      widget.onModelReady!(widget.controller);
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: widget.buildPage(context,widget.controller));
  }
}

