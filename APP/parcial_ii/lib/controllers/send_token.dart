import 'package:parcial_ii/exports.dart';
import 'package:http/http.dart' as http;

class SendTokenFCM {
  SendTokenFCM(String? token);

  Future<void> sendToken(String token) async {
    final response = await http.post(
        Uri.parse("http://192.168.1.8/backend/registerDivide.php"),
        body: {
          'DISPO': token,
          'ID': 1.toString(),
        });
    if (response.statusCode == 200) {
      // procesar la respuesta del script PHP
    } else {
      throw Exception('Error al enviar los datos');
    }
  }
}
