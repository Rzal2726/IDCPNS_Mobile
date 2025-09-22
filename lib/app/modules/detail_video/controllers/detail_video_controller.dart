import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:rich_editor/rich_editor.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:path_provider/path_provider.dart';

class DetailVideoController extends GetxController {
  final count = 0.obs;
  final restClient = RestClient();

  late WebViewController webViewController;
  late YoutubePlayerController ytController;
  late String uuid;
  final questionController = TextEditingController();
  final dio = Dio();
  final questionReplyController = TextEditingController();
  final GlobalKey<RichEditorState> keyEditor = GlobalKey<RichEditorState>();
  final GlobalKey<RichEditorState> keyEditEditor = GlobalKey<RichEditorState>();

  RxMap<String, dynamic> videoData = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> commentList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> noteList = <Map<String, dynamic>>[].obs;
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
  RxString nextTopic = "".obs;
  RxString prevTopic = "".obs;

  // A variable for the total video duration.
  RxString duration = "00:00".obs;
  // A new variable for the current video time.
  RxString currentTime = "00:00".obs;
  RxBool isReady = false.obs;
  RxBool isInit = false.obs;
  RxBool isNote = false.obs;
  RxInt detik = 0.obs;
  RxInt totalComment = 0.obs;
  RxInt perPage = 5.obs;
  RxInt totalPage = 1.obs;
  RxInt currentPage = 1.obs;

  var expandedReplies = <int>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    initDetailVideo();
    checkMaintenance();
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
    uuid = await Get.arguments;

    await loadTopic(uuid ?? videoData['uuid']);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Editor sudah selesai dirender di layar
      keyEditor.currentState?.clear();
      print("RichEditor siap digunakan!");
    });
    isInit.value = true;
  }

  Future<void> initWebController(String uri) async {
    final String refererUrl = baseUrl;

    // Jangan gunakan pengecekan `if (isInit.value && webViewController != null)`
    // karena akan skip re-init yang menyebabkan error.
    webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'BunnyPlayerChannel',
            onMessageReceived: (JavaScriptMessage message) {
              print('Message from web view: ${message.message}');

              if (message.message.startsWith('duration:')) {
                final durationValue = message.message.split(':')[1];
                print('Video Duration: $durationValue seconds');
              } else if (message.message.startsWith('time:')) {
                final timeValue = message.message.split(':')[1];
                currentTime.value = timeValue;
                detik.value = int.parse(timeValue);
                duration.value = formatDuration(detik.value);
              }
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) async {
                const String javascript = """
            try {
              BunnyPlayerChannel.postMessage('JavaScript script started.');

              var checkInterval = setInterval(function() {
                var videoElement = document.querySelector('video');
                if (!videoElement) {
                  return;
                }
                
                clearInterval(checkInterval);
                BunnyPlayerChannel.postMessage('Video element found. Starting listeners.');

                videoElement.addEventListener('loadedmetadata', function() {
                  BunnyPlayerChannel.postMessage('duration:' + videoElement.duration.toFixed(0));
                });

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
            ),
          )
          ..loadRequest(Uri.parse(uri), headers: {"Referer": refererUrl});
  }

  Future<void> initYoutube(String uri) async {
    final videoId = YoutubePlayer.convertUrlToId(uri);
    ytController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
    // Listener untuk cek durasi video
    ytController.addListener(() {
      if (ytController.value.isReady) {
        final totalDuration = ytController.value.position;
        duration.value = formatytDuration(totalDuration);
        detik.value = totalDuration.inSeconds;
        print("Total Video Duration: ${duration.value}");
      }
    });
  }

  Future<void> loadTopic(String uuid) async {
    detik.value = 0;
    isReady.value = false;

    // 🔹 Bersihkan controller sebelumnya
    if (videoData['isyoutube'] == 1 && ytController.value.isPlaying) {
      ytController.pause();
      ytController.dispose();
    }

    // Reset webViewController jika sebelumnya WebView
    if (videoData['isyoutube'] == 0 && webViewController != null) {
      webViewController.clearCache();
    }

    // Fetch data terbaru
    await getTopic(uuid);
    await getComments(uuid);
    await getNotes(uuid);

    // 🔹 Inisialisasi sesuai tipe video
    if (videoData['isyoutube'] == 1) {
      await initYoutube(videoData['video_url']);
    } else {
      await initWebController(videoData['video_url']);
    }

    isReady.value = true;
  }

  Future<void> getTopic(uuid) async {
    final response = await restClient.getData(
      url: baseUrl + apiVideoTopicDetail + uuid,
    );
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    videoData.assignAll(data);
    nextTopic.value = data['next_topic']?['uuid'] ?? "";
    prevTopic.value = data['previous_topic']?['uuid'] ?? "";
  }

  Future<void> getComments(uuid) async {
    final payload = {"uuid": uuid};
    final response = await restClient.postData(
      url:
          baseUrl +
          apiVideoTopicComments +
          "?page=" +
          currentPage.value.toString(),
      payload: payload,
    );
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    Map<String, dynamic> pageData = Map<String, dynamic>.from(response['data']);
    commentList.assignAll(data);
    commentPageData.assignAll(pageData);
    totalComment.value = pageData['total'];
    totalPage.value = (totalComment.value / perPage.value as double).ceil();
  }

  Future<void> getNotes(uuid) async {
    final response = await restClient.getData(
      url: baseUrl + apiVideoTopicGetNotes + uuid,
    );
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    noteList.assignAll(data);
  }

  Future<void> addComments({required Map<String, dynamic> payload}) async {
    /* {
          comment: string; 
          video_topic_id: number; 
          parent_id: number; 
          parameter: string 
        }
    */
    final response = await restClient.postData(
      url: baseUrl + apiVideoTopicAddComments,
      payload: payload,
    );
    if (response['status'] == "success") {
      Get.snackbar(
        "Berhasil",
        "Berhasil membuat komentar",
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
      getComments(videoData['uuid']);
      questionReplyController.text = "";
      questionController.text = "";
    } else {
      Get.snackbar(
        "Gagal",
        "Gagal membuat komentar",
        backgroundColor: Colors.pink,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addNote({required Map<String, dynamic> payload}) async {
    /* { 
          durasi: number; 
          text: string; 
          topicUuid: string 
        }
    */
    try {
      final response = await restClient.postData(
        url: baseUrl + apiVideoTopicAddNotes,
        payload: payload,
      );
      print(payload);
      getNotes(videoData['uuid']);
      keyEditor.currentState?.clear();
      Get.snackbar(
        "Berhasil",
        "Berhasil membuat notes",
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Gagal membuat notes",
        backgroundColor: Colors.pink,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteNotes({required Map<String, dynamic> payload}) async {
    /* { 
          durasi: number; 
          topicUuid: string 
        }
    */
    try {
      final response = await restClient.postData(
        url: baseUrl + apiVideoTopicDeleteNotes,
        payload: payload,
      );
      print(payload);
      getNotes(videoData['uuid']);
      Get.snackbar(
        "Berhasil",
        "Berhasil menghapus notes",
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Gagal menghapus notes",
        backgroundColor: Colors.pink,
        colorText: Colors.white,
      );
    }
  }

  void increment() => count.value++;
  String formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String formatytDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
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

  void printNextAndPrevTopic() {
    print("Prev: ${prevTopic.value}");
    print("Next: ${nextTopic.value}");
  }

  void goToNextTopic() {
    if (isReady.value == true) {
      if (nextTopic.value.isNotEmpty) {
        loadTopic(nextTopic.value);
      }
    }
  }

  void goToPrevTopic() {
    if (isReady.value == true) {
      if (prevTopic.value.isNotEmpty) {
        loadTopic(prevTopic.value);
      }
    }
  }

  Future<void> download2(Dio dio, String url, String fileName) async {
    try {
      Get.snackbar(
        "Mendownload File",
        " ",
        colorText: Colors.white,
        backgroundColor: Colors.teal,
      );
      // Ambil folder writable dari device
      final dir = await getDownloadsDirectory();
      final savePath = '${dir!.path}/$fileName';

      print("Menyimpan file di: $savePath");

      // Mulai download
      final response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress, // Progress download
        options: Options(
          responseType: ResponseType.bytes, // Data diterima sebagai bytes
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      // Simpan hasil download ke file
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      Get.snackbar(
        "Berhasil",
        "File Bisa dilihat di: $savePath ",
        colorText: Colors.white,
        backgroundColor: Colors.teal,
      );

      print("Download selesai: $savePath");
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Gagal mendownload file",
        colorText: Colors.pink,
        backgroundColor: Colors.teal,
      );
      print("Terjadi error saat download: $e");
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  // Fungsi toggle
  void toggleReplyVisibility(int commentId) {
    if (expandedReplies.contains(commentId)) {
      expandedReplies.remove(commentId);
    } else {
      expandedReplies.add(commentId);
    }
  }

  Future<void> playVideo() async {
    if (videoData['isyoutube'] == 1) {
      ytController.play();
    } else {
      await webViewController.runJavaScript("""
    var videoElement = document.querySelector('video');
    if (videoElement) {
      videoElement.play();
    }
  """);
    }
  }

  Future<void> pauseVideo() async {
    if (videoData['isyoutube'] == 1) {
      ytController.pause();
    } else {
      await webViewController.runJavaScript("""
    var videoElement = document.querySelector('video');
    if (videoElement) {
      videoElement.pause();
    }
  """);
    }
  }

  Future<void> seekTo(int detik) async {
    if (videoData['isyoutube'] == 1) {
      ytController.seekTo(Duration(seconds: detik));
    } else {
      await webViewController.runJavaScript("""
    var videoElement = document.querySelector('video');
    if (videoElement) {
      videoElement.currentTime = $detik;
    }
  """);
    }
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
