// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:parcial_ii/exports.dart';
import 'package:parcial_ii/models/message_model.dart';

class SendMessageView extends StatefulWidget {
  final UserModel user;
  const SendMessageView({super.key, required this.user});

  @override
  _SendMessageViewState createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  late UserModel _user;

  String _title = "";
  String _message = "";
  String _devices = "";

  @override
  void initState() {
    super.initState();
    _user = widget.user;
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
                Navigator.of(context).pop();
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
              child: const Text("OK"),
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
        title: ChatHeader(
          name: _user.name,
          imageUrl: _user.photo,
          status: _user.email,
        ),
        backgroundColor: const Color.fromARGB(255, 8, 44, 107),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_user.name),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
            const SizedBox(height: 16),
            /* TextFormField(
              decoration: const InputDecoration(
                labelText: 'Dispositivos',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _devices = value;
                });
              },
            ), */
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _sendButtonPressed();
                },
                child: const Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendButtonPressed() {
    final messageData = MessageModel(
        title: _title,
        body: _message,
        emailRem: "prueba@mail.com",
        emailRes: _user.email,
        idRes: _user.id);
    SendMessage().sendMessage(messageData).then((result) {
      if (result['status'] == 'success') {
        _showSuccessDialog(result['message']!);
      } else {
        _showErrorDialog(result['message']!);
      }
    }).catchError((error) {
      // Manejar el error
      print(error.toString());
    });
  }
}
