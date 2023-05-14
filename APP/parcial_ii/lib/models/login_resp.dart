// ignore: unused_import
import 'dart:convert';

class LoginRespModel {
  String? id;
  String? name;
  String? email;
  String? photo;
  String? role;
  String? token;
  String? tel;

  LoginRespModel(
      {this.id,
      this.name,
      this.email,
      this.photo,
      this.role,
      this.token,
      this.tel});

  LoginRespModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    photo = json['photo'];
    role = json['role'];
    token = json['token'];
    tel = json['tel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['photo'] = photo;
    data['role'] = role;
    data['token'] = token;
    data['tel'] = tel;
    return data;
  }
}
