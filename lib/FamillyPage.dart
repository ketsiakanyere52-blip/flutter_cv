import 'package:flutter/material.dart';
import 'package:flutter_cv/Avatar.dart';
import 'package:flutter_cv/Experiance.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: Profile.famille.length,
      itemBuilder: (context, i) {
        final m = Profile.famille[i];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Avatar(asset: m.photo, radius: 30),
            title: Text(
              m.nom,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${m.lien}\n${m.profession}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
