import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const Header({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onMenuPressed,
          icon: const Icon(Icons.menu),
        ),
        const CircleAvatar(
          backgroundImage: NetworkImage(
              "https://faces-img.xcdn.link/image-lorem-face-3430.jpg"),
          radius: 26.0,
        ),
      ],
    );
  }
}
