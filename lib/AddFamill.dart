import 'package:flutter/material.dart';
import 'package:flutter_cv/Service/ApiExeption.dart';

class AddFamilyPage extends StatefulWidget {
  // null = ajout, sinon = modification de ce membre
  final FamilleMembre? membre;
  const AddFamilyPage({super.key, this.membre});

  @override
  State<AddFamilyPage> createState() => _AddFamilyPageState();
}

class _AddFamilyPageState extends State<AddFamilyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _postnom = TextEditingController();
  final _prenom = TextEditingController();
  final _lieu = TextEditingController();
  final _parente = TextEditingController();
  final _image = TextEditingController();
  DateTime? _date;
  bool _chargement = false;

  bool get _modification => widget.membre != null;

  @override
  void initState() {
    super.initState();
    final m = widget.membre;
    if (m != null) {
      _nom.text = m.nom;
      _postnom.text = m.postnom;
      _prenom.text = m.prenom;
      _lieu.text = m.lieuNaissance;
      _parente.text = m.parente;
      _image.text = m.image ?? '';
      _date = DateTime.tryParse(m.dateNaissance);
    }
  }

  @override
  void dispose() {
    _nom.dispose();
    _postnom.dispose();
    _prenom.dispose();
    _lieu.dispose();
    _parente.dispose();
    _image.dispose();
    super.dispose();
  }

  // 1990-03-05 (format attendu par l'API)
  String _formater(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _choisirDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisissez la date de naissance')),
      );
      return;
    }

    final image = _image.text.trim().isEmpty ? null : _image.text.trim();

    setState(() => _chargement = true);
    try {
      if (_modification) {
        await ApiService.modifierMembre(
          widget.membre!.id,
          nom: _nom.text.trim(),
          postnom: _postnom.text.trim(),
          prenom: _prenom.text.trim(),
          lieuNaissance: _lieu.text.trim(),
          dateNaissance: _formater(_date!),
          parente: _parente.text.trim(),
          image: image,
        );
      } else {
        await ApiService.ajouterMembre(
          nom: _nom.text.trim(),
          postnom: _postnom.text.trim(),
          prenom: _prenom.text.trim(),
          lieuNaissance: _lieu.text.trim(),
          dateNaissance: _formater(_date!),
          parente: _parente.text.trim(),
          image: image,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true); // true = la liste doit être rechargée
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  Widget _champ(
    TextEditingController c,
    String label,
    IconData icone, {
    bool obligatoire = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: obligatoire ? label : '$label (facultatif)',
          prefixIcon: Icon(icone),
          border: const OutlineInputBorder(),
        ),
        validator: obligatoire
            ? (v) =>
                  (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modification ? 'Modifier le membre' : 'Ajouter un membre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _champ(_nom, 'Nom', Icons.person),
              _champ(_postnom, 'Postnom', Icons.person_outline),
              _champ(_prenom, 'Prénom', Icons.badge),
              _champ(_lieu, 'Lieu de naissance', Icons.location_on),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: _choisirDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date de naissance',
                      prefixIcon: Icon(Icons.cake),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _date == null
                          ? 'Appuyez pour choisir'
                          : _formater(_date!),
                    ),
                  ),
                ),
              ),
              _champ(
                _parente,
                'Lien de parenté (père, mère, frère…)',
                Icons.family_restroom,
              ),
              _champ(
                _image,
                'Adresse de la photo (https://…)',
                Icons.image,
                obligatoire: false,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _chargement ? null : _enregistrer,
                  child: _chargement
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _modification
                              ? 'Enregistrer les changements'
                              : 'Enregistrer',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
