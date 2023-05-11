import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parcial_ii/exports.dart';

class LoginController {
  Future<LoginResponse> login(LoginModel loginData) async {
    Uri url = Uri.http(Params.api, Params.loginURL);
    final response = await http.post(url, body: {
      'email_usuario': loginData.email,
      'clave': loginData.password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final loginRespModel = LoginRespModel.fromJson(data['loginRespModel']);
      final loginResponse = LoginResponse(
        loginRespModel: loginRespModel,
        code: data['code'],
        message: data['message'],
      );
      return loginResponse;
    } else {
      throw Exception('Error al enviar los datos');
    }
  }
}
