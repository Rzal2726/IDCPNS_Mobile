import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idcpns_mobile/app/modules/notification/controllers/notification_controller.dart';
import 'package:idcpns_mobile/app/providers/exceptions.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class RestClient {
  Dio dio = Dio();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  // BaseApiService() : dio = Dio(options);

  Future<RestClient> init() async {
    // final notifC = Get.put(NotificationController());
    // notifC.getNotif();
    try {
      await GetStorage.init();
      final box = GetStorage();
      var token = box.read("token");
      Map<String, dynamic> headers = {'Authorization': "Bearer $token"};
      var options = BaseOptions(
        connectTimeout: Duration(seconds: 30000),
        headers: headers,
        receiveTimeout: Duration(seconds: 30000),
      );
      dio = Dio(options);
      initInterceptors();
      return this;
    } catch (e) {
      return this;
    }
  }

  void initInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            // ignore: avoid_print
            print(
              'REQUEST[${options.method}] => PATH: ${options.path} '
              '=> Request Values: ${options.queryParameters}, => HEADERS: ${options.headers}',
            );
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            // ignore: avoid_print
            print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (err, handler) {
          if (kDebugMode) {
            // ignore: avoid_print
            print('ERROR[${err.response?.statusCode}]');
          }
          return handler.next(err);
        },
      ),
    );
  }

  //get data
  getData({
    String? url,
    Map<String, dynamic>? headers,
    Map<String, String>? payload,
    CancelToken? cancelToken, // Tambahkan parameter cancelToken
  }) async {
    await init();
    if (url == null) {
      return;
    }
    try {
      dio.options.headers.addAll(headers ?? {});

      // Gunakan cancelToken saat memanggil dio.get
      var response = await dio.get(url, cancelToken: cancelToken);

      return _processResponse(response);
    } on DioException catch (DioException) {
      throw _dioException(DioException);
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('not connected');
      }
    } catch (e) {
      rethrow;
    }
  }

  //post data
  postData({
    String? url,
    dynamic payload,
    Map<String, dynamic>? headers,
  }) async {
    await init();
    if (url == null) return;

    try {
      if (headers != null) {
        dio.options.headers.addAll(headers);
      }

      var response = await dio.post(
        url,
        data: payload ?? {},
        options: Options(
          validateStatus: (status) => true, // semua status dianggap valid
        ),
      );

      // kembalikan data JSON apapun statusnya
      return response.data;
    } on DioException catch (e) {
      // tangkap DioException dan ambil response.data jika ada
      if (e.response != null) {
        return e.response!.data;
      } else {
        rethrow;
      }
    } on SocketException catch (_) {
      if (kDebugMode) print('Not connected');
    } catch (e) {
      rethrow;
    }
  }

  //update data
  updateData({
    String? url,
    dynamic payload,
    Map<String, dynamic>? headers,
  }) async {
    await init();
    if (url == null) {
      return;
    }

    try {
      if (headers != null) {
        dio.options.headers.addAll(headers);
      }
      var response = await dio.patch(url, data: payload ?? {});

      return _processResponse(response);
    } on DioException catch (DioException) {
      throw _dioException(DioException);
    } catch (e) {
      rethrow;
    }
  }

  //delete data
  deleteData({
    String? url,
    dynamic payload,
    Map<String, dynamic>? headers,
  }) async {
    await init();
    if (url == null) {
      return;
    }
    try {
      if (headers != null) {
        dio.options.headers.addAll(headers);
      }
      var response = await dio.delete(url, data: payload ?? {});

      return _processResponse(response);
    } on DioException catch (DioException) {
      throw _dioException(DioException);
    } catch (e) {
      rethrow;
    }
  }

  _processResponse(response) {
    if (response == null) {
      // ignore: avoid_print
      return print("Something went wrong1");
    }
    switch (response.statusCode) {
      case 200:
        var decodedJson = response.data;
        return decodedJson;
      case 201:
        var decodedJson = response.data;
        return decodedJson;
      case 400:
        var message = jsonDecode(response.toString())["message"];
        // showPopup("Error", message);
        print("xxcode1");
        throw ClientException(message: message, response: response.data);
      case 401:
        var message = jsonDecode(response.toString())["message"];
        print("xxcode2");
        if (message == 'Token Expired') {
          print("xxcode2.1");
          return ClientException(message: message, response: response.data);
        }
        // showPopup("Error", message);
        throw message;
      case 404:
        var message = jsonDecode(response.toString())["message"];
        print("xxcode3");
        // showPopup("Error", message);
        throw message;
      case 500:
        var message = jsonDecode(response.toString())["message"];
        print("xxcode4");
        if (message == 'Server Error') {
          print("xxcode4.1");
          return ClientException(message: message, response: response.data);
        }
        // showPopup("Error", "Server Error");
        throw ServerException(message: "Something went wrong2");
      case 504:
        print("xxcode5");
        // showPopup("Error", "Server Down");
        throw ServerException(message: "Server went down");
      default:
        var message =
            jsonDecode(response.toString())["message"] ?? 'An error occured';
        // showPopup("Error", message);
        throw HttpException(
          statusCode: response.statusCode,
          message: "Something went wrong3",
        );
    }
  }

  _dioException(DioException dioErr) {
    switch (dioErr.type) {
      case DioExceptionType.sendTimeout:
        throw "Something went wrong4";
      case DioExceptionType.receiveTimeout:
        throw "Something went wrong5";
      default:
        // tampilkan dialog logout
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // sudut dialog membulat
            ),
            title: Row(
              children: const [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  "Peringatan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            content: const Text(
              "Akun ini terhubung dengan device lain.\n\n"
              "Untuk melanjutkan, silakan login kembali.",
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.black54,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () async {
                  try {
                    await _googleSignIn.disconnect();
                    await _googleSignIn.signOut();
                    print(
                      'Google logout berhasil / atau tidak ada session Google.',
                    );
                  } catch (e) {
                    print(
                      'Tidak ada akun Google yang sedang login atau sudah logout: $e',
                    );
                  }

                  Get.offAllNamed(Routes.LOGIN);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
          barrierColor: Colors.transparent,
        );

        break;
    }
  }
}
