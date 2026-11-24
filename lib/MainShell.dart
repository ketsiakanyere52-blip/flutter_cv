import 'package:flutter/material.dart';
import 'package:flutter_cv/Contact.dart';
import 'package:flutter_cv/FamillyPage.dart';
import 'package:flutter_cv/HomePage.dart';
import 'package:flutter_cv/Service/ApiExeption.dart';
import 'package:flutter_cv/main.dart';


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final Future<Etudiant?> _etudiant = ApiService.etudiant();

  static const _titres = ['Mon CV', 'Ma famille', 'Contact'];

  void _deconnexion() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(etudiant: _etudiant),
      const FamilyPage(),
      ContactPage(etudiant: _etudiant),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_titres[_index]),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: _deconnexion,
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(
              icon: Icon(Icons.family_restroom), label: 'Famille'),
          NavigationDestination(
              icon: Icon(Icons.contact_mail), label: 'Contact'),
        ],
      ),
    );
  }
}