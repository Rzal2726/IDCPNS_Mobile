import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;

class TryoutEventFreePaymentController extends GetxController {
  //TODO: Implement TryoutEventFreePaymentController

  final restClient = RestClient();

  late String uuid;

  final count = 0.obs;

  // Rx variables for selected image paths
  final RxString followImagePath = ''.obs;
  final RxString commentImagePath = ''.obs;
  final RxString repostImagePath = ''.obs;
  RxMap<String, dynamic> dataTryout = <String, dynamic>{}.obs;

  RxBool loading = true.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    startInit();
    checkMaintenance();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }

  void increment() => count.value++;

  Future<void> startInit() async {
    uuid = await Get.arguments;
    await fetchDetailTryout();
    loading.value = false;
  }

  Future<void> fetchDetailTryout() async {
    try {
      final response = await restClient.getData(
        url: baseUrl + apiGetDetailTryoutEvent + uuid,
      );

      print("uuid : ${uuid}");
      final Map<String, dynamic> paket = Map<String, dynamic>.from(
        response['data'],
      );
      dataTryout.assignAll(paket);
    } catch (e) {
    } finally {}
  }

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

  void uploadPersyaratan() async {
    loading.value = true;
    if (followImagePath.value == '' ||
        commentImagePath.value == '' ||
        repostImagePath.value == '') {
      loading.value = false;
      return notifHelper.show('Semua bukti persyaratan wajib diisi', type: 2);
    } else {
      final payload = dio.FormData.fromMap({"tryout_id": dataTryout['id']});
      final response = await restClient.postData(
        url: baseUrl + apiPersyaratanUploadTryoutEvent,
        payload: payload,
      );

      if (response['status'] == 'error') {
        loading.value = false;
        notifHelper.show(response['message'], type: 2);
      } else {
        Get.offNamed("/pembayaran-berhasil");
      }
    }
  }
}
