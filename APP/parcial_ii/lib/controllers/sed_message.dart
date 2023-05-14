import 'dart:convert';

import 'package:parcial_ii/exports.dart';
import 'package:http/http.dart' as http;
import 'package:parcial_ii/models/message_model.dart';

class SendMessage {
  Future<Map<String, String>> sendMessage(MessageModel messageData) async {
    Uri url = Uri.http(Params.api, Params.messageURL);
    final response = await http.post(url, body: {
      'EMAIL_REM': messageData.emailRem,
      'EMAIL_RES': messageData.emailRes,
      'TITLE': messageData.title,
      'MESSAGE': messageData.body,
      'ID_RES': messageData.idRes,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['code'] == 'OK') {
        return {'status': 'success', 'message': data['message']};
      } else {
        return {'status': 'error', 'message': data['message']};
      }
    } else {
      throw Exception('Error al enviar el mensaje');
    }
  }
}
