import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  final String name;
  final String status;
  final String imageUrl;

  const ChatHeader({
    Key? key,
    required this.name,
    required this.status,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            imageUrl,
          ),
          radius: 20.0,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 211, 211, 211),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
