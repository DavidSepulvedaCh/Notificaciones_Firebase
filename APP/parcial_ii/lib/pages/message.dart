// ignore_for_file: library_private_types_in_public_api, avoid_print
import 'package:parcial_ii/exports.dart';
import 'package:parcial_ii/models/message_model.dart';

class SendMessageView extends StatefulWidget {
  final UserModel user;
  final String rem;
  const SendMessageView({super.key, required this.user, required this.rem});

  @override
  _SendMessageViewState createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  late UserModel _user;
  late String remitente;

  String _title = "";
  String _message = "";

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    remitente = widget.rem;
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Envio exitoso"),
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
          title: const Text("Error en el envio del mensaje"),
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
        automaticallyImplyLeading: false,
        title: ChatHeader(
          name: _user.name,
          imageUrl: _user.photo,
          email: _user.email,
        ),
        backgroundColor: const Color.fromARGB(255, 8, 44, 107),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _sendButtonPressed();
                },
                icon: const Icon(Icons.send),
                label: const Text('Enviar'),
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
        emailRem: remitente,
        emailRes: _user.email,
        idRes: _user.id);
    SendMessage().sendMessage(messageData).then((result) {
      if (result['status'] == 'success') {
        _showSuccessDialog(result['message']!);
      } else {
        _showErrorDialog(result['message']!);
      }
    }).catchError((error) {
      print(error.toString());
    });
  }
}
