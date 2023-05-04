import 'package:parcial_ii/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /* String? token = await FirebaseMessaging.instance.getToken();
  String tokenSaved = getSharedPreferences(name: "SP_FILE", mode: 0)
      .getString(key: "DISPO", defValue: null);
  if (token != null) {
    if (tokenSaved != null || token != tokenSaved) {}
  } */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodHub',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
      },
    );
  }
}
