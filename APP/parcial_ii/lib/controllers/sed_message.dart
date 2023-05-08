import 'dart:convert';

import 'package:parcial_ii/exports.dart';
import 'package:http/http.dart' as http;
import 'package:parcial_ii/models/message_model.dart';

class SendMessage {
  Future<Map<String, String>> sendMessage(MessageModel messageData) async {
    final response = await http
        .post(Uri.parse("http://10.153.50.87/backend/sendMessage.php"), body: {
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
        return {'status': 'success', 'message': data['message']};
      }
    } else {
      throw Exception('Error al enviar el mensaje');
    }
  }
}
