import 'dart:convert';
import 'package:parcial_ii/exports.dart';
import 'package:http/http.dart' as http;

class RegisterController {
  String email = "";

  Future<Map<String, String>> register(RegisterModel registerData) async {
    Uri url = Uri.http(Params.api, Params.registerURL);
    final response = await http.post(
      url,
      body: {
        'nombre_completo': registerData.name,
        'email_usuario': registerData.email,
        'numero_telefonico': registerData.phone,
        'cargo': registerData.cargo,
        'foto_usuario': registerData.image,
        'clave': registerData.password,
        'token_fcm': registerData.token,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['code'] == "OK") {
        LoginRespModel respModel =
            LoginRespModel.fromJson(data['loginRespModel']);
        await Shared.setLogginDetails(respModel);
        return {
          'status': 'success',
          'message': data['message'],
          'token': data['tk']
        };
      } else {
        return {'status': 'error', 'message': data['message']};
      }
    } else {
      throw Exception('Error al enviar los datos');
    }
  }
}
