import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String asset;
  final double radius;
  const Avatar({super.key, required this.asset, this.radius = 30});

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;
    final taille = radius * 2;
    return ClipOval(
      child: Container(
        width: taille,
        height: taille,
        color: couleurs.primaryContainer,
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.person, size: radius, color: couleurs.primary),
        ),
      ),
    );
  }
}
