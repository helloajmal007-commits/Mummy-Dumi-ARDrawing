import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/localization/locale_controller.dart';

class LocaleRebuilder extends StatelessWidget {
  final WidgetBuilder builder;

  const LocaleRebuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocaleController>().currentLocale.value;
      return builder(context);
    });
  }
}
