import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tryout_harian_controller.dart';

class TryoutHarianView extends GetView<TryoutHarianController> {
  const TryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TryoutHarianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TryoutHarianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
