import 'package:flutter/material.dart';
import 'package:flutter_cv/Avatar.dart';
import 'package:flutter_cv/Experiance.dart';
import 'package:flutter_cv/Service/ApiExeption.dart';



class HomePage extends StatelessWidget {
  final Future<Etudiant?> etudiant;
  const HomePage({super.key, required this.etudiant});

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(child: Avatar(asset: Profile.photo, radius: 60)),
        const SizedBox(height: 12),
        FutureBuilder<Etudiant?>(
          future: etudiant,
          builder: (context, snap) => Text(
            snap.data?.nomComplet ?? Profile.nom,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 4),
        Text(Profile.titre,
            textAlign: TextAlign.center,
            style: TextStyle(color: couleurs.primary)),
        const SizedBox(height: 12),
        Text(Profile.resume, textAlign: TextAlign.center),

        _Section(
          icone: Icons.school,
          titre: 'Formation',
          enfants: [
            for (final f in Profile.formations)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(f.diplome),
                subtitle: Text('${f.etablissement}\n${f.periode}'),
                isThreeLine: true,
              ),
          ],
        ),
        _Section(
          icone: Icons.work,
          titre: 'Expériences',
          enfants: [
            for (final e in Profile.experiences)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(e.titre),
                subtitle:
                    Text('${e.organisation} • ${e.periode}\n${e.description}'),
                isThreeLine: true,
              ),
          ],
        ),
        _Section(
          icone: Icons.build,
          titre: 'Compétences techniques',
          enfants: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final c in Profile.competencesTechniques)
                  Chip(label: Text(c)),
              ],
            ),
          ],
        ),
        _Section(
          icone: Icons.language,
          titre: 'Langues',
          enfants: [
            for (final l in Profile.langues)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.check, size: 18),
                title: Text(l),
              ),
          ],
        ),
        _Section(
          icone: Icons.favorite,
          titre: 'Centres d\'intérêt',
          enfants: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final i in Profile.interets) Chip(label: Text(i)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icone;
  final String titre;
  final List<Widget> enfants;
  const _Section(
      {required this.icone, required this.titre, required this.enfants});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(titre, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Divider(),
            ...enfants,
          ],
        ),
      ),
    );
  }
}