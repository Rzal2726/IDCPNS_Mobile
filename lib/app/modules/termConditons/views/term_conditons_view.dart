import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/term_conditons_controller.dart';

class TermConditonsView extends GetView<TermConditonsController> {
  const TermConditonsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TermConditonsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TermConditonsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
