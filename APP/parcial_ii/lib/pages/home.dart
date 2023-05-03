import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _message;
  String? _recipient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Título',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Mensaje',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un mensaje';
                  }
                  return null;
                },
                onSaved: (value) {
                  _message = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Destinatario',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un destinatario';
                  }
                  return null;
                },
                onSaved: (value) {
                  _recipient = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Envía el formulario
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
