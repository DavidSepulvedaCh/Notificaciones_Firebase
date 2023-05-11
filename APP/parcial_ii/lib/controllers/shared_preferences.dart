import 'package:parcial_ii/exports.dart';

class Shared {
  static late SharedPreferences storageSahred;

  static Future<void> setUp() async {
    storageSahred = await SharedPreferences.getInstance();
  }

  static Future<void> setLogginDetails(LoginRespModel model) async {
    var id = model.id ?? 'default';
    var name = model.name ?? 'default';
    var email = model.email ?? 'default';
    var photo = model.photo ?? 'https://bit.ly/3Lstjcq';
    var role = model.role ?? 'default';
    var token = model.token ?? 'default';
    if (name != 'default' &&
        token != 'default' &&
        email != 'default' &&
        id != 'default' &&
        role != 'default') {
      await storageSahred.setString('id', id);
      await storageSahred.setString('email', email);
      await storageSahred.setString('name', name);
      await storageSahred.setString('role', role);
      await storageSahred.setString('token', token);
    }
    await storageSahred.setString("photo", photo);
  }
}
