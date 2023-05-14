import 'dart:convert';

import 'package:parcial_ii/exports.dart';
import 'package:http/http.dart' as http;

class VerifyToken {
  Future<String> verifyToken(String token) async {
    Uri url = Uri.http(Params.api, Params.verifyToken);
    final response = await http.post(url, body: {'token': token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['code'] == "OK") {
        return data['code'];
      } else {
        return data['code'];
      }
    } else {
      throw Exception('Error al enviar el token para verificar.');
    }
  }
}
