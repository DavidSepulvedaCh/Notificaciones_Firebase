// ignore_for_file: use_build_context_synchronously

import 'package:parcial_ii/exports.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _tokenFcm = '';
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        _tokenFcm = token!;
        _textEditingController.text = _tokenFcm;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Inicio de Sesión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              /* TextField(
                readOnly: true,
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: _textEditingController.text));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Texto copiado al portapapeles'),
                  ));
                },
                controller: _textEditingController,
                decoration: const InputDecoration(labelText: 'Texto'),
              ), */
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 20),
              MyElevatedButton(onPressed: sendInfomation),
              const SizedBox(height: 20),
              buildAvisoRegister(context),
            ],
          ),
        ),
      ),
    );
  }

  void sendInfomation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final loginData = LoginModel(
        email: _email,
        password: _password,
        tokenFcm: _tokenFcm,
      );
      Map<String, dynamic> rta = await LoginController().login(loginData);
      if (rta['status'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              userLoged: _email,
            ),
          ),
        );
      } else {
        DialogUtils.showErrorDialog(context, "Error", rta['message']);
      }
    }
  }
}
