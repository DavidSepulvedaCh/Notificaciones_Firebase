// ignore_for_file: avoid_print

import '../exports.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  late String? _name;
  late String? _email;
  late String? _cargo;
  late String? _token;
  late String? _password;
  final String _image = "https://bit.ly/3VFd1jO";
  late String? _phone;
  late String? tk;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        _token = token;
      });
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Registro exitoso"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                print(tk);
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error en el registro"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.next_plan),
          onPressed: () {
            print(_token);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  userLoged: _email!,
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_image),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    // agregar código para seleccionar una imagen
                  },
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su nombre completo';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Numero telefonico',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su numero telefonico';
                  }
                  return null;
                },
                onSaved: (value) => _phone = value!,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor ingrese un correo electrónico válido';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Cargo',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su cargo actual';
                  }
                  return null;
                },
                onSaved: (value) => _cargo = value!,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Registrarse'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final registerData = RegisterModel(
                      name: _name,
                      email: _email,
                      phone: _phone,
                      cargo: _cargo,
                      image: _image,
                      password: _password,
                      token: _token,
                    );
                    RegisterController().register(registerData).then((result) {
                      if (result['status'] == 'success') {
                        _showSuccessDialog(result['message']!);
                        setState(() {
                          tk = result['tk'];
                        });
                      } else {
                        _showErrorDialog(result['message']!);
                      }
                    }).catchError((error) {
                      // Manejar el error
                      print(error.toString());
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
