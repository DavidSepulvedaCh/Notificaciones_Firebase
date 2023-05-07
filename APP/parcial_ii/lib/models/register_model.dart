class RegisterModel {
  String? name;
  String? email;
  String? cargo;
  String? token;
  String? password;
  String? image = "https://bit.ly/3VFd1jO";
  String? phone;

  RegisterModel(
      {this.name,
      this.email,
      this.cargo,
      this.token,
      this.password,
      this.image,
      this.phone});
}
