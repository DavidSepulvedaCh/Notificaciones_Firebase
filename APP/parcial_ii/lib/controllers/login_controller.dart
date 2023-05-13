import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parcial_ii/exports.dart';

class LoginController {
  Future<Map<String, dynamic>> login(LoginModel loginData) async {
    Uri url = Uri.http(Params.api, Params.loginURL);
    final response = await http.post(url, body: {
      'email_usuario': loginData.email,
      'clave': loginData.password,
      'token_fcm': loginData.tokenFcm
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['code'] == "OK") {
        LoginRespModel respModel =
            LoginRespModel.fromJson(data['loginRespModel']);
        await Shared.setLogginDetails(respModel);
        return {
          'status': 'success',
          'message': data['message'],
          'token': data['tk'],
          'respModel': respModel,
        };
      } else {
        return {'status': 'error', 'message': data['message']};
      }
    } else {
      throw Exception('Error al enviar los datos');
    }
  }
}
