import 'package:parcial_ii/exports.dart';

Widget buildAvisoRegister(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Register()),
      );
    },
    child: RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'No tiene una tienes cuenta? ',
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 71, 71, 71),
              fontWeight: FontWeight.w300,
            ),
          ),
          TextSpan(
            text: 'Registrate ahora!',
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
