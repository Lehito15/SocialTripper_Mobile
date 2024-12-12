import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:social_tripper_mobile/Models/User/user_dto.dart';

import '../Pages/config/data_retrieving_config.dart';


class UserService {
  final baseUrl = "${DataRetrievingConfig.sourceUrl}/users";

  Future<void> createUser(UserDTO user, String? profilePicture) async {
    final String url = '$baseUrl'; // URL do endpointa


    Dio dio = Dio();

    // Serializowanie obiektu Account do JSON
    String userMetadata = jsonEncode(user.toJson());


    // Tworzenie danych do wysłania w formacie multipart
    FormData formData = FormData.fromMap({
      'userDTO': MultipartFile.fromBytes(
        Uint8List.fromList(userMetadata.codeUnits),
        contentType: MediaType('application', 'json'),
      ),
        'profilePicture': profilePicture != null ? await MultipartFile.fromFile(
          profilePicture,
          contentType: MediaType('image', 'jpeg'),
        ) : null,

    });

    print("Sending user data to server...");

    try {
      Response response = await dio.post(url, data: formData);
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
    } catch (e) {
      print('Error creating user: $e');
      throw Exception('Error creating user: $e');
    }
  }
}