class Experience {
  final String titre;
  final String organisation;
  final String periode;
  final String description;
  const Experience(
    this.titre,
    this.organisation,
    this.periode,
    this.description,
  );
}

class Formation {
  final String diplome;
  final String etablissement;
  final String periode;
  const Formation(this.diplome, this.etablissement, this.periode);
}

class FamilyMember {
  final String nom;
  final String lien;
  final String profession;
  final String photo;
  const FamilyMember(this.nom, this.lien, this.profession, this.photo);
}

class Profile {
  static const identifiant = 'admin';
  static const motDePasse = '1234';

  static const nom = 'Ketsia kikusa';
  static const titre = 'Étudiante en informatique — Développeur mobile';
  static const photo = 'assets/images/moi.jpg';
  static const resume =
      'Étudiant motivé, passionné par le développement mobile et les nouvelles '
      'technologies, à la recherche de projets concrets pour progresser.';

  static const formations = [
    Formation('Etudiant', 'ISIG-Goma', '2026 – 2027'),
    Formation('Diplôme d\'État (Bac)', 'Ujumbe', '2023 – 2024'),
  ];

  static const experiences = [
    Experience(
      'Stagiaire développeur',
      'OpenClinic',
      'Été 2025',
      'Participation au développement d\'une application interne.',
    ),
    Experience(
      'Projet universitaire',
      'Université',
      '2025',
      'Conception d\'une application de gestion en équipe de 4.',
    ),
    Experience(
      'Emploi',
      'Programmeuse',
      '2024',
      'Support informatique et accueil des clients.',
    ),
  ];

  static const competencesTechniques = [
    'Flutter / Dart',
    'Git & GitHub',
    'HTML / CSS',
    'C#',
    'SQL',
    'PHP',
  ];

  static const langues = [
    'Français — langue maternelle',
    'Anglais — intermédiaire',
    'Swahili — courant',
  ];

  static const interets = [
    'Programmation',
    'Apprendre',
    'Lecture',
    'Musique',
    'Voyages',
  ];

  static const famille = [
    FamilyMember('Kaviti', 'Père', 'Profession', 'assets/images/pere.jpg'),
    FamilyMember('Kavira', 'Mère', 'Profession', 'assets/images/mere.jpg'),
    FamilyMember('Christian', 'Frère', 'Étudiant', 'assets/images/frere.jpg'),
    FamilyMember('Christelle', 'Sœur', 'Élève', 'assets/images/soeur.jpg'),
  ];

  static const telephone = '+243984356639';
  static const email = 'ketsiakanyere52@gmail.com';
  static const adresse = 'Goma, RDC';
  static const linkedin =
      'https://www.linkedin.com/in/ketsia-kanyere-052410407/';
  static const github = 'https://github.com/ketsiakanyere52-blip/flutter_cv';
}
