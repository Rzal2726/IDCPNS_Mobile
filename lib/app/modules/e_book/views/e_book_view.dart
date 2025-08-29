import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/e_book_controller.dart';

class EBookView extends GetView<EBookController> {
  const EBookView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EBookView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EBookView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
