import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:idcpns_mobile/app/modules/tryout_event_free_payment/controllers/tryout_event_free_payment_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';

class TryoutEventFreePaymentView
    extends GetView<TryoutEventFreePaymentController> {
  const TryoutEventFreePaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leftType: AppBarLeftType.backWithTitle,
        title: 'Upload Persyaratan',
        showNotifIcon: true,
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
                            if (controller.loading.value) {
                              return;
                            }
                            controller.uploadPersyaratan();
                          },

                          child: Obx(() {
                            return controller.loading.value
                                ? Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  "Kirim",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                          }),
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
          icon: const Icon(Icons.upload, color: Colors.teal),
          label: const Text("Browse", style: TextStyle(color: Colors.teal)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            side: const BorderSide(color: Colors.teal),
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
              ? Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Border color
                    // width: 3.0, // Border width
                  ),
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ), // Optional: Rounded corners
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.image, color: Colors.teal, size: 24.0),
                        Text(
                          path.split('/').last,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        switch (type) {
                          case 'follow':
                            controller.followImagePath.value = '';
                            break;
                          case 'comment':
                            controller.commentImagePath.value = '';
                            break;
                          case 'repost':
                            controller.repostImagePath.value = '';
                            break;
                        }
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              )
              : const SizedBox.shrink();
        }),
      ],
    );
  }
}

// return path.isNotEmpty
//               ? Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Text(
//                   'Selected: ${path.split('/').last}',
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               )
//               : const SizedBox.shrink();
