// ignore_for_file: unused_field

import 'package:parcial_ii/exports.dart';
import 'package:parcial_ii/pages/login.dart';

class Logged extends StatefulWidget {
  const Logged({super.key});

  @override
  State<Logged> createState() => _LoggedState();
}

class _LoggedState extends State<Logged> {
  //Calling the shared instance
  static late SharedPreferences storageSahred;

  @override
  void initState() {
    super.initState();
    verifyLogin();
  }

  verifyLogin() async {
    await Shared.setUp();
    var email = Shared.storageSahred.getString('email');

    await Shared.verifyLogged().then((value) => {
          if (value == "OK")
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(
                    userLoged: email!,
                  ),
                ),
              ),
            }
          else
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              ),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
