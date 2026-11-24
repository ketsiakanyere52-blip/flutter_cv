import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class Etudiant {
  final String nom;
  final String postnom;
  final String prenom;
  final String adresse;
  final String telephone;

  Etudiant({
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.adresse,
    required this.telephone,
  });

  factory Etudiant.fromJson(Map<String, dynamic> j) => Etudiant(
    nom: '${j['nom'] ?? ''}',
    postnom: '${j['postnom'] ?? ''}',
    prenom: '${j['prenom'] ?? ''}',
    adresse: '${j['adresse'] ?? ''}',
    telephone: '${j['telephone'] ?? ''}',
  );

  String get nomComplet => '$prenom $nom $postnom'.trim();
}

class FamilleMembre {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String? image;
  final String parente;

  FamilleMembre({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.image,
    required this.parente,
  });

  factory FamilleMembre.fromJson(Map<String, dynamic> j) => FamilleMembre(
    id: int.tryParse('${j['id']}') ?? 0,
    nom: '${j['nom'] ?? ''}',
    postnom: '${j['postnom'] ?? ''}',
    prenom: '${j['prenom'] ?? ''}',
    lieuNaissance: '${j['lieu_naissance'] ?? ''}',
    dateNaissance: '${j['date_naissance'] ?? ''}',
    image: j['image'] == null ? null : '${j['image']}',
    parente: '${j['parente'] ?? ''}',
  );

  String get nomComplet => '$prenom $nom $postnom'.trim();

  String? get imageUrl {
    if (image == null || image!.isEmpty) return null;
    if (image!.startsWith('http')) return image;
    return '${ApiService.baseUrl}/${image!.replaceFirst(RegExp(r'^/'), '')}';
  }
}

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  static const _entetes = {'Content-Type': 'application/json'};
  static const _delai = Duration(seconds: 10);

  static Map<String, dynamic> _lire(http.Response r) {
    try {
      final d = jsonDecode(utf8.decode(r.bodyBytes));
      if (d is Map<String, dynamic>) return d;
      return {'data': d};
    } catch (_) {
      throw ApiException('Réponse invalide du serveur (${r.statusCode})');
    }
  }

  static Future<void> _authentifier(
    String chemin,
    String email,
    String motDePasse,
  ) async {
    try {
      final r = await http
          .post(
            Uri.parse('$baseUrl$chemin'),
            headers: _entetes,
            body: jsonEncode({'email': email, 'password': motDePasse}),
          )
          .timeout(_delai);
      final d = _lire(r);
      if (r.statusCode >= 400 || d['success'] == false) {
        throw ApiException('${d['message'] ?? 'Opération refusée'}');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      print('ERREUR RÉSEAU : $e');
      throw ApiException(
        'Serveur injoignable. Vérifiez l\'adresse et le réseau.',
      );
    }
  }

  static Future<void> login(String email, String mdp) =>
      _authentifier('/accounts/login', email, mdp);

  static Future<void> register(String email, String mdp) =>
      _authentifier('/accounts/register', email, mdp);

  static Future<Etudiant?> etudiant() async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/etudiants'), headers: _entetes)
          .timeout(_delai);
      final d = _lire(r);
      final liste = d['data'] ?? d['etudiants'] ?? [];
      if (liste is List && liste.isNotEmpty) {
        return Etudiant.fromJson(liste.first as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }

  static Future<List<FamilleMembre>> famille() async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/famille-membres'), headers: _entetes)
          .timeout(_delai);
      final d = _lire(r);
      if (r.statusCode >= 400 || d['success'] == false) {
        throw ApiException('${d['message'] ?? 'Erreur serveur'}');
      }
      final liste = d['data'] ?? d['membres'] ?? [];
      return (liste as List)
          .map((e) => FamilleMembre.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Impossible de charger la famille.');
    }
  }

  static Future<void> ajouterMembre({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance, // format AAAA-MM-JJ
    required String parente,
    String? image,
  }) async {
    try {
      final r = await http
          .post(
            Uri.parse('$baseUrl/famille-membres'),
            headers: _entetes,
            body: jsonEncode({
              'nom': nom,
              'postnom': postnom,
              'prenom': prenom,
              'lieu_naissance': lieuNaissance,
              'date_naissance': dateNaissance,
              'parente': parente,
              'image': image,
            }),
          )
          .timeout(_delai);
      final d = _lire(r);
      if (r.statusCode >= 400 || d['success'] == false) {
        throw ApiException('${d['message'] ?? 'Ajout refusé'}');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      print('ERREUR RÉSEAU : $e');
      throw ApiException(
        'Serveur injoignable. Vérifiez l\'adresse et le réseau.',
      );
    }
  }

  // Envoie une requête et vérifie la réponse du serveur
  static Future<void> _appel(
    Future<http.Response> Function() requete,
    String messageParDefaut,
  ) async {
    try {
      final r = await requete().timeout(_delai);
      final d = _lire(r);
      if (r.statusCode >= 400 || d['success'] == false) {
        throw ApiException('${d['message'] ?? messageParDefaut}');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      print('ERREUR RÉSEAU : $e');
      throw ApiException(
        'Serveur injoignable. Vérifiez l\'adresse et le réseau.',
      );
    }
  }

  static Future<void> modifierMembre(
    int id, {
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance, // AAAA-MM-JJ
    required String parente,
    String? image,
  }) {
    return _appel(
      () => http.put(
        Uri.parse('$baseUrl/famille-membres/$id'),
        headers: _entetes,
        body: jsonEncode({
          'nom': nom,
          'postnom': postnom,
          'prenom': prenom,
          'lieu_naissance': lieuNaissance,
          'date_naissance': dateNaissance,
          'parente': parente,
          'image': image,
        }),
      ),
      'Modification refusée',
    );
  }

  static Future<void> supprimerMembre(int id) {
    return _appel(
      () => http.delete(
        Uri.parse('$baseUrl/famille-membres/$id'),
        headers: _entetes,
      ),
      'Suppression refusée',
    );
  }
}
