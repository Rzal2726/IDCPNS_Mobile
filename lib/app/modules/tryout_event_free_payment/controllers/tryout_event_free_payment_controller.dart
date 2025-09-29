import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TryoutEventFreePaymentController extends GetxController {
  //TODO: Implement TryoutEventFreePaymentController

  final count = 0.obs;

  // Rx variables for selected image paths
  final RxString followImagePath = ''.obs;
  final RxString commentImagePath = ''.obs;
  final RxString repostImagePath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Method to pick image and save to temp storage
  Future<void> pickImage(String type) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Get temp directory
        final Directory tempDir = await getTemporaryDirectory();
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        final String tempPath = '${tempDir.path}/$fileName';

        // Copy the image to temp directory
        final File tempFile = File(tempPath);
        await tempFile.writeAsBytes(await image.readAsBytes());

        // Assign to the corresponding RxString
        switch (type) {
          case 'follow':
            followImagePath.value = tempPath;
            break;
          case 'comment':
            commentImagePath.value = tempPath;
            break;
          case 'repost':
            repostImagePath.value = tempPath;
            break;
        }
      }
    } catch (e) {
      // Handle error, perhaps show snackbar
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }
}
