import 'dart:io';
import '../exports.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  late String? _name;
  late String? _email;
  late String? _cargo;
  late String? _token;
  late String? _password;
  String? _image;
  late String? _phone;
  late String? tk;

  File? fileImg;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        _token = token;
      });
    });
    _image = "https://bit.ly/3VFd1jO";
    fileImg = null; // Agrega esta línea
  }

  void options() async {
    final pickedFile = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Editar desde galeria'),
                onTap: () async {
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    if (pickedFile != null) {
                      fileImg = File(pickedFile.path);
                      UpImage.uploadImageToCloudinary(fileImg!).then((image) {
                        _image = image;
                      });
                    }
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Editar desde camara'),
                onTap: () async {
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    if (pickedFile != null) {
                      fileImg = File(pickedFile.path);
                      UpImage.uploadImageToCloudinary(fileImg!).then((image) {
                        _image = image;
                      });
                    }
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                const Text(
                  'Registro de usuario',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: fileImg != null
                          ? FileImage(fileImg!)
                          : NetworkImage(_image!) as ImageProvider<Object>,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 80),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 6, 34, 82),
                        ),
                        child: IconButton(
                          onPressed: () {
                            options();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Cargo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese su cargo actual';
                    }
                    return null;
                  },
                  onSaved: (value) => _cargo = value!,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
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
                MyElevatedButton(onPressed: sendInfomation),
                const SizedBox(height: 15),
                buildAvisoLogin(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendInfomation() async {
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
          DialogUtils.showSuccessDialog(
              context, "Registro exitoso", result['message']!);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                userLoged: _email!,
              ),
            ),
          );
        } else {
          DialogUtils.showErrorDialog(context, "Error", result['message']!);
        }
      }).catchError((error) {
        // Manejar el error
        print(error.toString());
      });
    }
  }
}
