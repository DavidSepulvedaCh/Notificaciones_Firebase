// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:parcial_ii/exports.dart';

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
            }),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          if (user.name == widget.userLoged || user.email == widget.userLoged) {
            // Exclude the currently logged-in user from the list
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
