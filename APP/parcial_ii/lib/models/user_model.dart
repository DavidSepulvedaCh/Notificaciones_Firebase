class UserModel {
  final String name;
  final String email;
  final String photo;
  final String id;
  final String cargo;
  final String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    required this.cargo,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['nombre_completo'],
        email: json['email'],
        photo: json['foto'],
        cargo: json['cargo'],
        phone: json['numero_telefonico']);
  }
}
