import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailVideoController extends GetxController {
  //TODO: Implement DetailVideoController

  final count = 0.obs;
  late final WebViewController webViewController;
  final questionController = TextEditingController();
  RxList<String> option = ["QnA", "Notes"].obs;
  RxString selectedOption = "QnA".obs;

  final html = """
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          margin: 0;
          padding: 0;
          background-color: black;
          overflow: hidden;
        }
        iframe {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          border: none;
        }
      </style>
    </head>
    <body>
      <iframe src="https://iframe.mediadelivery.net/embed/271527/4fd62463-ca78-4e67-80d8-6f655a83ec0c?preload=true&responsive=true" allowfullscreen></iframe>
    </body>
    </html>
    """;

  // Load HTML custom
  @override
  void onInit() {
    super.onInit();
    webViewController =
        WebViewController()
          ..setJavaScriptMode(
            JavaScriptMode.unrestricted,
          ) // Wajib agar player bisa jalan
          ..loadHtmlString(html);
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
}
