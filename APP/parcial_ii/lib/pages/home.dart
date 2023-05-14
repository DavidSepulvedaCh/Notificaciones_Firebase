// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:parcial_ii/exports.dart';
import 'package:parcial_ii/pages/login.dart';

class Home extends StatefulWidget {
  final String userLoged;

  const Home({Key? key, required this.userLoged}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<UserModel> _users = [];
  late String _userLoged;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _userLoged = widget.userLoged;
  }

  Future<void> _loadUsers() async {
    //final getUsers = GetUsers();
    try {
      final getUsers = GetUsers();
      final users = await getUsers.getUsers();
      setState(() {
        _users = users;
      });
    } catch (error) {
      print(error);
    }
  }

  void showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Salir"),
              onPressed: () async {
                await Shared.setUp();
                await Shared.storageSahred.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () async {
                await Shared.setUp();
                await Shared.storageSahred.clear();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: const Color.fromARGB(255, 8, 44, 107),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: (() async {
              await Shared.printLogginDetails();
              showSuccessDialog(context, "Cerrar Sesión",
                  "Seguro que quieres cerrar sesión?");
              /*  */
            }),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          if (user.name == widget.userLoged || user.email == widget.userLoged) {
            return Container();
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendMessageView(
                      user: user,
                      rem: _userLoged,
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.photo),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
              ),
            );
          }
        },
      ),
    );
  }
}
