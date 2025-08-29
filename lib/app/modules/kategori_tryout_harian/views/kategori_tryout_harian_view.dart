import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/kategori_tryout_harian_controller.dart';

class KategoriTryoutHarianView extends GetView<KategoriTryoutHarianController> {
  const KategoriTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KategoriTryoutHarianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KategoriTryoutHarianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
