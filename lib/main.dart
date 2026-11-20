import 'package:flutter/material.dart';
import 'package:flutter_cv/Experiance.dart';
import 'package:flutter_cv/MainShell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final pwdController = TextEditingController();
  bool masque = true;

  @override
  void dispose() {
    idController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  void _seConnecter() {
    if (!formKey.currentState!.validate()) return;
    if (idController.text.trim() == Profile.identifiant &&
        pwdController.text == Profile.motDePasse) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identifiant ou mot de passe incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_circle, size: 96, color: couleurs.primary),
                  const SizedBox(height: 12),
                  Text(
                    'Bienvenue',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  const Text('Connectez-vous pour voir mon CV'),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: idController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Identifiant',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Saisissez votre identifiant'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: pwdController,
                    obscureText: masque,
                    onFieldSubmitted: (_) => _seConnecter(),
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          masque ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => masque = !masque),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Saisissez votre mot de passe'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _seConnecter,
                      child: const Text('Se connecter'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
