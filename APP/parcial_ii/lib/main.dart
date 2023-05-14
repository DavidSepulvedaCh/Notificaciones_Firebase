import 'package:parcial_ii/exports.dart';
import 'package:parcial_ii/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Shared.setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parcial_II',
      debugShowCheckedModeBanner: false,
      initialRoute: '/verifyLogin',
      routes: {
        '/verifyLogin': (context) => const Logged(),
        '/register': (context) => const Register(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
