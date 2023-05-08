import 'dart:convert';
import 'package:parcial_ii/exports.dart';
import 'package:http/http.dart' as http;

class RegisterController {
  Future<Map<String, String>> register(RegisterModel registerData) async {
    final response = await http.post(
      Uri.parse("http://10.153.50.87/backend/registerUser.php"),
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
        return {'status': 'success', 'message': data['message']};
      } else {
        return {'status': 'error', 'message': data['message']};
      }
    } else {
      throw Exception('Error al enviar los datos');
    }
  }
}
