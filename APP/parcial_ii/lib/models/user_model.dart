class UserModel {
  final String name;
  final String email;
  final String photo;
  final String id;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['nombre_completo'],
      email: json['email'],
      photo: json['foto'],
    );
  }
}
