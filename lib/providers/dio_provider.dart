import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';

class DioProvider {
  static const String url = 'http://127.0.0.1:8080';
  static const String chatEndPoint = '$url/api/v1/gpt';
  static const String jsonDelimiter = "}\n";
  static const String messageContent = "message";

  static Future<void> fetchStreamData({
    required Map query,
    required Function(String) onMessageReceived,
  }) async {
    String buffer = '';
    final dio = Dio();
    try {
      final response = await dio.get<ResponseBody>(
        chatEndPoint,
        queryParameters: {'mbti': query['mbti'], 'content': query['content']},
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      await for (var value in response.data!.stream) {
        for (int element in value) {
          buffer += String.fromCharCode(element);
          int index;

          while ((index = buffer.indexOf(jsonDelimiter)) != -1) {
            String jsonString = buffer.substring(0, index + 1);
            buffer = buffer.substring(index + 2);
            try {
              var jsonObject = json.decode(jsonString);
              await Future.delayed(const Duration(milliseconds: 10));
              onMessageReceived(jsonObject[messageContent]);
            } catch (e) {
              print('Error parsing JSON: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching stream data: $e');
    }
  }
}
