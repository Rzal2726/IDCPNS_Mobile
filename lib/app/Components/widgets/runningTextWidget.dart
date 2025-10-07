import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

class RunningTextBar extends StatelessWidget {
  RunningTextBar({super.key});

  // === Controller di dalam file yang sama ===
  final controller = Get.put(_AnnouncementController());

  bool _isTextTooLong(String text, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(
        text: _stripHtmlTags(text),
        style: const TextStyle(fontSize: 14),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);
    return painter.width > maxWidth * 0.9;
  }

  String _stripHtmlTags(String htmlText) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(regex, '');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      if (controller.isLoading.value || controller.htmlText.isEmpty) {
        return const SizedBox();
      }

      final shouldRun = _isTextTooLong(controller.htmlText.value, screenWidth);

      return Container(
        color: Colors.teal,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ), // jarak biar lega
        alignment: Alignment.center,
        child: Html(
          data: controller.htmlText.value,
          style: {
            "body": Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontSize: FontSize(14),
              color: Colors.white,
              textAlign: TextAlign.center,
              lineHeight: LineHeight(1.4),
            ),
            "a": Style(
              textDecoration: TextDecoration.none,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          },
          onLinkTap: (url, attributes, element) async {
            if (url != null) {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                debugPrint("Could not launch $url");
              }
            }
          },
        ),
      );
    });
  }
}

// === Controller lokal ===
class _AnnouncementController extends GetxController {
  final _restClient = RestClient();
  var htmlText = "".obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncement();
  }

  Future<void> fetchAnnouncement() async {
    try {
      final url = baseUrl + apiGetAnouncment;
      final result = await _restClient.getData(url: url);

      if (result["status"] == "success" && result["data"] != null) {
        // perhatikan key-nya sesuai contoh respon JSON kamu
        htmlText.value = result["data"]["message"] ?? "";
      } else {
        htmlText.value = "";
      }
    } catch (e) {
      debugPrint("Error fetch announcement: $e");
      htmlText.value = "";
    } finally {
      isLoading.value = false;
    }
  }
}
