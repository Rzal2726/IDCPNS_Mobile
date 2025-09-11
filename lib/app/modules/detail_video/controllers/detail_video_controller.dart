import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailVideoController extends GetxController {
  final count = 0.obs;
  final restClient = RestClient();

  late final WebViewController webViewController;
  late YoutubePlayerController ytController;
  late RxMap<String, dynamic> videoData = <String, dynamic>{}.obs;
  final questionController = TextEditingController();
  RxList<Map<String, dynamic>> commentList = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> commentPageData = <String, dynamic>{}.obs;
  RxList<String> option = ["QnA", "Notes"].obs;
  RxMap<String, Color> categoryColor =
      <String, Color>{
        "CPNS": Colors.teal,
        "BUMN": Colors.blueAccent,
        "Kedinasan": Colors.orangeAccent,
        "PPPK": Colors.redAccent,
      }.obs;
  RxString selectedOption = "QnA".obs;

  // A variable for the total video duration.
  RxString duration = "00:00".obs;
  // A new variable for the current video time.
  RxString currentTime = "00:00".obs;
  RxBool isReady = false.obs;

  @override
  void onInit() async {
    super.onInit();
    initDetailVideo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    if (videoData['isyoutube'] == 1) {
      ytController.dispose();
    }
  }

  Future<void> initDetailVideo() async {
    isReady.value = false;
    videoData.value = await Get.arguments as Map<String, dynamic>;
    if (videoData['isyoutube'] == 1) {
      await initYoutube(videoData['video_url']);
    } else {
      await initWebController(videoData['video_url']);
    }
    await getTopic(videoData['uuid']);
    await getComments(videoData['uuid']);
    print("videoData: ${videoData}");
    isReady.value = true;
  }

  Future<void> initWebController(String uri) async {
    final String refererUrl = baseUrl; // Assuming this is defined correctly.
    webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'BunnyPlayerChannel',
            onMessageReceived: (JavaScriptMessage message) {
              print('Message from web view: ${message.message}');

              if (message.message.startsWith('duration:')) {
                final durationValue = message.message.split(':')[1];
                print('Video Duration: ${duration.value} seconds');
              } else if (message.message.startsWith('time:')) {
                final timeValue = message.message.split(':')[1];
                currentTime.value = timeValue; // posisi sekarang
                print('Current Time: ${currentTime.value} seconds');
                duration.value = formatDuration(int.parse(currentTime.value));
              }
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {},
              onPageFinished: (String url) async {
                final String javascript = """
    try {
      BunnyPlayerChannel.postMessage('JavaScript script started.');

      var checkInterval = setInterval(function() {
        var videoElement = document.querySelector('video');
        if (!videoElement) {
          return;
        }
        
        clearInterval(checkInterval);
        BunnyPlayerChannel.postMessage('Video element found. Starting listeners.');

        // Kirim durasi total setelah video siap
        videoElement.addEventListener('loadedmetadata', function() {
          BunnyPlayerChannel.postMessage('duration:' + videoElement.duration.toFixed(0));
        });

        // Kirim current time secara realtime
        videoElement.addEventListener('timeupdate', function() {
          BunnyPlayerChannel.postMessage('time:' + videoElement.currentTime.toFixed(0));
        });
      }, 500);
    } catch(e) {
      BunnyPlayerChannel.postMessage('JavaScript execution error: ' + e.message);
    }
  """;

                webViewController.runJavaScript(javascript);
              },

              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(headers: {"Referer": refererUrl}, Uri.parse(uri));
  }

  Future<void> initYoutube(String uri) async {
    final videoId = YoutubePlayer.convertUrlToId(uri);
    ytController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  Future<void> getTopic(uuid) async {
    final response = await restClient.getData(
      url: baseUrl + apiVideoTopicDetail + uuid,
    );
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    videoData.assignAll(data);
  }

  Future<void> getComments(uuid) async {
    final payload = {"perpage": "15", "uuid": uuid};
    final response = await restClient.postData(
      url: baseUrl + apiVideoTopicComments,
      payload: payload,
    );
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    Map<String, dynamic> pageData = Map<String, dynamic>.from(response['data']);
    commentList.assignAll(data);
    commentPageData.assignAll(pageData);
  }

  void increment() => count.value++;
  String formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String timeAgo(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} Hari yang lalu';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} Jam yang lalu';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} Menit yang lalu';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return dateTimeString; // fallback jika format datetime error
    }
  }
}
