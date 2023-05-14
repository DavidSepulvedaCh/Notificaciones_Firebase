// ignore_for_file: library_private_types_in_public_api, avoid_print, sort_child_properties_last
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
  bool _changedText = false;

  String _title = "";
  String _message = "";

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    remitente = widget.rem;
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
            Text(
              "Cargo: ${_user.cargo} - Telefono: ${_user.phone}",
              style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                "Envia un mensaje!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                isCollapsed: true,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _message = value;
                  _changedText = true;
                });
              },
              decoration: InputDecoration(
                labelText: 'Mensaje',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                isCollapsed: true,
                suffixIcon: Visibility(
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _sendButtonPressed();
                    },
                  ),
                  visible: _changedText,
                ),
              ),
              maxLines: 3,
              minLines: 1,
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
        DialogUtils.showSuccessDialog(
            context, "Mensaje enviado", result['message']!);
      } else {
        DialogUtils.showErrorDialog(
            context, "Error en en mensaje", result['message']!);
      }
    }).catchError((error) {
      print(error.toString());
    });
  }
}
