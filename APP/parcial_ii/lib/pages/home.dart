import 'package:parcial_ii/exports.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _message;
  String? _recipient;
  String? _token;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        _token = token;
      });
    });
  }

  Future<void> sendToken() async {
    final response = await http.post(
        Uri.parse("http://192.168.1.8/backend/registerDivide.php"),
        body: {
          'DISPO': _token,
          'ID': 1.toString(),
        });
    if (response.statusCode == 200) {
      // procesar la respuesta del script PHP
    } else {
      throw Exception('Error al enviar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              sendToken();
              print(_token);
            },
            child: const Text("Registrar"),
          )),
    );
  }
}
