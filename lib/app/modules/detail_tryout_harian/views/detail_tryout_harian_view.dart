import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_tryout_harian_controller.dart';

class DetailTryoutHarianView extends GetView<DetailTryoutHarianController> {
  const DetailTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailTryoutHarianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailTryoutHarianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
