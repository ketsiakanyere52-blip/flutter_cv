import 'package:flutter/material.dart';
import 'package:flutter_cv/Experiance.dart';
import 'package:flutter_cv/Service/ApiExeption.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactPage extends StatelessWidget {
  final Future<Etudiant?> etudiant;
  const ContactPage({super.key, required this.etudiant});

  Future<void> _ouvrir(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir ce lien')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Etudiant?>(
      future: etudiant,
      builder: (context, snap) {
        final tel = (snap.data?.telephone.isNotEmpty ?? false)
            ? snap.data!.telephone
            : Profile.telephone;
        final adresse = (snap.data?.adresse.isNotEmpty ?? false)
            ? snap.data!.adresse
            : Profile.adresse;

        final contacts =
            <({IconData icone, String label, String valeur, Uri? uri})>[
          (
            icone: Icons.phone,
            label: 'Téléphone',
            valeur: tel,
            uri: Uri(scheme: 'tel', path: tel),
          ),
          (
            icone: Icons.email,
            label: 'E-mail',
            valeur: Profile.email,
            uri: Uri(scheme: 'mailto', path: Profile.email),
          ),
          (
            icone: Icons.location_on,
            label: 'Adresse',
            valeur: adresse,
            uri: null,
          ),
          (
            icone: Icons.business_center,
            label: 'LinkedIn',
            valeur: Profile.linkedin,
            uri: Uri.parse(Profile.linkedin),
          ),
          (
            icone: Icons.code,
            label: 'GitHub',
            valeur: Profile.github,
            uri: Uri.parse(Profile.github),
          ),
        ];

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            for (final c in contacts)
              Card(
                child: ListTile(
                  leading: Icon(c.icone,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(c.label),
                  subtitle: Text(c.valeur),
                  trailing:
                      c.uri == null ? null : const Icon(Icons.open_in_new),
                  onTap:
                      c.uri == null ? null : () => _ouvrir(context, c.uri!),
                ),
              ),
          ],
        );
      },
    );
  }
}