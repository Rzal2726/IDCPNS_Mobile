import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
// import baseUrl, apiGetNotif, dan _restClient sesuai project-mu

class NotifIcon extends StatefulWidget {
  const NotifIcon({super.key});

  @override
  State<NotifIcon> createState() => _NotifIconState();
}

class _NotifIconState extends State<NotifIcon> {
  final _restClient = RestClient();
  final RxList<int> allUnreadData = <int>[].obs;

  @override
  void initState() {
    super.initState();
    getNotif(); // fetch sekali pas widget dipasang
  }

  Future<void> getNotif() async {
    try {
      final url = baseUrl + apiGetNotif;

      final result = await _restClient.getData(url: url);
      debugPrint("Notif result: ${result.toString()}");

      if (result["status"] == "success") {
        final data = result["data"] as List<dynamic>;

        // ambil notif yang belum dibaca
        final unread =
            data
                .where((item) => item["read"] == 0)
                .map<int>((item) => item["id"] as int)
                .toList();

        allUnreadData.assignAll(unread);
      }
    } catch (e) {
      debugPrint("Error fetch notif: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = allUnreadData.length;
      final hasUnread = count > 0;

      return Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: InkWell(
          onTap: () => Get.toNamed(Routes.NOTIFICATION),
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Icon(
                hasUnread ? Icons.notifications : Icons.notifications_none,
                color: Colors.teal,
              ),
              if (hasUnread)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
