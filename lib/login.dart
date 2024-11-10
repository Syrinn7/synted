import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fonction de connexion
  Future<void> _loginUser() async {
    String login = _loginController.text.trim();
    String password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      _showErrorMessage('Les champs ne doivent pas être vides');
      return;
    }

    try {
      // Tentative de connexion avec Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: login,
        password: password,
      );
      print("Connexion réussie : ${userCredential.user?.email}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print("Erreur de connexion : $e");
      _showErrorMessage('Mot de passe ou identifiant incorrect');
    }
  }

  // Afficher un message d'erreur
  void _showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Fond gris foncé
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 21, 21), // Couleur sombre de l'AppBar
        title: const Text(
          'Synted',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Message de bienvenue sur Synted
                const Text(
                  'Bienvenue sur SYNTED', // Message en gros
                  style: TextStyle(
                    fontSize: 30, // Taille du texte
                    fontFamily: 'script',
                    color: Color.fromARGB(255, 255, 255, 255), // Couleur pastel bleue
                  ),
                ),
                const SizedBox(height: 50), // Espacement avant le formulaire

                // Titre principal de la page avec style pastel
                Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 198, 255, 187), // Couleur pastel bleue
                  ),
                ),
                const SizedBox(height: 30),

                // Champ Login
                TextField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color.fromARGB(255, 198, 255, 187)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Champ Mot de passe
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: const TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: const Color.fromARGB(255, 198, 255, 187)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 30),

                // Bouton de connexion
                ElevatedButton(
                  onPressed: _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 198, 255, 187), // Couleur pastel bleue
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Option pour l'inscription si l'utilisateur n'a pas de compte
                TextButton(
                  onPressed: () {
                    // Ici, tu peux ajouter la navigation vers la page d'inscription
                  },
                  child: Text(
                    "Pas encore de compte ? S'inscrire",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 198, 255, 187),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
