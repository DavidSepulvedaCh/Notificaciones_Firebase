import 'package:parcial_ii/exports.dart';
import 'package:parcial_ii/pages/login.dart';

Widget buildAvisoLogin(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    },
    child: RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: '¿Ya tienes una cuenta? ',
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 71, 71, 71),
              fontWeight: FontWeight.w300,
            ),
          ),
          TextSpan(
            text: 'Ingresa ahora!',
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 8, 44, 107),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
