import 'package:flutter/material.dart';
import 'package:flutter_cv/AddFamill.dart';
import 'package:flutter_cv/Service/ApiExeption.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  late Future<List<FamilleMembre>> _futur = ApiService.famille();

  Future<void> _recharger() async {
    setState(() {
      _futur = ApiService.famille();
    });
    await _futur.catchError((_) => <FamilleMembre>[]);
  }

  void _message(String texte) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texte)));
  }

  // Ouvre le formulaire (ajout si membre == null, sinon modification)
  Future<void> _ouvrirFormulaire({FamilleMembre? membre}) async {
    final change = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddFamilyPage(membre: membre)),
    );
    if (change == true) {
      _message(membre == null ? 'Membre ajouté' : 'Membre modifié');
      _recharger();
    }
  }

  // Demande confirmation, puis supprime
  Future<void> _supprimer(FamilleMembre m) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('Voulez-vous vraiment supprimer ${m.nomComplet} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true) return;

    try {
      await ApiService.supprimerMembre(m.id);
      if (!mounted) return;
      _message('Membre supprimé');
      _recharger();
    } on ApiException catch (e) {
      if (!mounted) return;
      _message(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ouvrirFormulaire(),
        icon: const Icon(Icons.person_add),
        label: const Text('Ajouter'),
      ),
      body: FutureBuilder<List<FamilleMembre>>(
        future: _futur,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${snap.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _recharger,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }
          final membres = snap.data!;
          if (membres.isEmpty) {
            return const Center(
              child: Text('Aucun membre. Appuyez sur « Ajouter ».'),
            );
          }
          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView.builder(
              // espace en bas pour que le bouton ne cache pas la dernière carte
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: membres.length,
              itemBuilder: (context, i) {
                final m = membres[i];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                    onTap: () =>
                        _ouvrirFormulaire(membre: m), // appui = modifier
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: m.imageUrl == null
                          ? null
                          : NetworkImage(m.imageUrl!),
                      child: m.imageUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      m.nomComplet,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${m.parente}\nNé(e) le ${m.dateNaissance} à ${m.lieuNaissance}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (choix) {
                        if (choix == 'modifier') _ouvrirFormulaire(membre: m);
                        if (choix == 'supprimer') _supprimer(m);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'modifier',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Modifier'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'supprimer',
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Supprimer'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
