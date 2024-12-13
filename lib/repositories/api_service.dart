import 'package:dio/dio.dart';
import 'package:oxdo_web_socket/util/constants.dart';

class ApiService {
    final Dio _dio =
      Dio(BaseOptions(baseUrl: base_url));

    Future<String> getWelcomeMessage() async {
    try {
      // get request by dio without header
      final Response<dynamic> response = await _dio.get("/");
      // Check for status code
      if (response.statusCode == 200) {
        return response.data as String;
      } else {
        throw Exception("Unknown response");
      }
    } on DioException catch (e) {
      // Catch dio exception
      throw Exception(e.toString());
    } catch (e) {
      // Catching other exception

      throw Exception(e.toString());
    }
  }

   Future<String> login(
      {required String userName, required String password}) async {
    try {
      // get request by dio without header
      final Response<dynamic> response = await _dio.post(
        "/login", // data to post
        data: {"userName": userName, "password": password},
        // options
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            "owner": "oxdo"
          },
        ),
      );
      // Check for status code
      if (response.statusCode == 200) {
        final token =
            (response.data as Map<String, dynamic>)["token"].toString();
        return token;
      } else {
        throw Exception("Unknown response");
      }
    } on DioException catch (e) {
      // Catch dio exception
      throw Exception(e.toString());
    } catch (e) {
      // Catching other exception

      throw Exception(e.toString());
    }
  }




}
