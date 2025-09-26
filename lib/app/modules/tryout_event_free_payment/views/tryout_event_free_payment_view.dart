import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:idcpns_mobile/app/modules/tryout_event_free_payment/controllers/tryout_event_free_payment_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class TryoutEventFreePaymentView
    extends GetView<TryoutEventFreePaymentController> {
  const TryoutEventFreePaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            scrolledUnderElevation: 0,
            title: const Text(
              "Upload Persyaratan",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.teal,
                    ),
                    onPressed: () {
                      Get.to(() => const NotificationView());
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '9+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Paket Event Tryout Gratis",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),

                      // Persyaratan
                      const Text(
                        "Persyaratan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildRequirementItem(
                        context,
                        "Follow Account Instagram Berikut : ",
                        "@IDCPNS & @belajarpppk",
                        () async {
                          // Open Instagram accounts
                          const url = 'https://www.instagram.com/idcpns';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildRequirementItem(
                        context,
                        "Comment dan Tag 5 Teman Kamu di : ",
                        "Postingan Ini",
                        () async {
                          // Open Instagram app or web
                          const url = 'https://www.instagram.com';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildRequirementItem(
                        context,
                        "Upload/Repost ke Story Instagram Kamu : ",
                        "Postingan Ini",
                        () async {
                          // Open Instagram app or web
                          const url = 'https://www.instagram.com';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      // Upload Bukti
                      const Text(
                        "Upload Bukti Persyaratan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildUploadField(
                        context,
                        "Follow Account Instagram Berikut : ",
                        "@IDCPNS & @belajarpppk",
                        'follow',
                      ),
                      const SizedBox(height: 12),
                      _buildUploadField(
                        context,
                        "Comment dan Tag 5 Teman Kamu di : ",
                        "Postingan Ini",
                        'comment',
                      ),
                      const SizedBox(height: 12),
                      _buildUploadField(
                        context,
                        "Upload/Repost ke Story Instagram Kamu : ",
                        "Postingan Ini",
                        'repost',
                      ),
                      const SizedBox(height: 20),

                      // Kirim button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            // aksi kirim
                          },
                          child: const Text(
                            "Kirim",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem(
    BuildContext context,
    String title,
    String highlight,
    VoidCallback? onTap,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              text: title,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                if (onTap != null)
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: onTap,
                      child: Text(
                        highlight,
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )
                else
                  TextSpan(
                    text: highlight,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadField(
    BuildContext context,
    String title,
    String highlight,
    String type,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirementItem(context, title, highlight, null),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            controller.pickImage(type);
          },
          icon: const Icon(Icons.upload, color: Colors.black),
          label: const Text("Browse", style: TextStyle(color: Colors.black)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            side: const BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        // Show selected image path if any
        Obx(() {
          String path = '';
          switch (type) {
            case 'follow':
              path = controller.followImagePath.value;
              break;
            case 'comment':
              path = controller.commentImagePath.value;
              break;
            case 'repost':
              path = controller.repostImagePath.value;
              break;
          }
          return path.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Selected: ${path.split('/').last}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              )
              : const SizedBox.shrink();
        }),
      ],
    );
  }
}
