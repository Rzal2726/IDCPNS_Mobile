import 'package:get/get.dart';

import '../controllers/pretest_ranking_controller.dart';

class PretestRankingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PretestRankingController>(
      () => PretestRankingController(),
    );
  }
}
