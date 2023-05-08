import 'dart:convert';
import 'package:parcial_ii/exports.dart';
import 'package:http/http.dart' as http;

class GetUsers {
  Future<List<UserModel>> getUsers() async {
    final response =
        await http.get(Uri.parse("http://10.153.50.87/backend/getUsers.php"));
    print(response);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<UserModel> users =
          data.map((json) => UserModel.fromJson(json)).toList();
      return users;
    } else {
      throw Exception("Error al obtener la data");
    }
  }
}
