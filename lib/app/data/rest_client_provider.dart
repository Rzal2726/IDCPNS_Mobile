import 'package:get/get.dart';

class RestClientProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://idcpns.com/api/v1';
  }
}
