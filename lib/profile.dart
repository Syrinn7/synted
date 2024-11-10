import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Pour limiter le code postal aux chiffres
import 'login.dart';  // Remplace par le chemin correct si nécessaire
import 'add_clothing.dart'; // Page pour ajouter un vêtement

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _anniversaireController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _codePostalController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();

  String _email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String userId = _auth.currentUser?.uid ?? '';
    _email = _auth.currentUser?.email ?? '';

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          _passwordController.text = userDoc['password'] ?? '';
          _anniversaireController.text = userDoc['anniversaire'] ?? '';
          _adresseController.text = userDoc['adresse'] ?? '';
          _codePostalController.text = userDoc['codePostal'] ?? '';
          _villeController.text = userDoc['ville'] ?? '';
          _isLoading = false;
        });
      } else {
        print("Document utilisateur introuvable.");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Erreur lors du chargement des données : $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserData() async {
    String userId = _auth.currentUser?.uid ?? '';

    // Vérification du format de date (JJ/MM/AAAA)
    final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!datePattern.hasMatch(_anniversaireController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le format de date doit être JJ/MM/AAAA')),
      );
      return;
    }

    try {
      // Mise à jour ou création du document utilisateur dans Firestore
      await _firestore.collection('users').doc(userId).set({
        'password': _passwordController.text,
        'anniversaire': _anniversaireController.text,
        'adresse': _adresseController.text,
        'codePostal': _codePostalController.text,
        'ville': _villeController.text,
        'email': _email, // Ajout de l'email pour la récupération future
      }, SetOptions(merge: true)); // merge pour ne pas écraser d'autres champs si le doc existe déjà

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Données sauvegardées')),
      );
    } catch (e) {
      print("Erreur de sauvegarde : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la sauvegarde des données')),
      );
    }
  }

  void _logout() async {
    await _auth.signOut();
    // Utilisation de pushReplacement pour s'assurer que l'utilisateur est bien redirigé vers la page de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    readOnly: true,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _anniversaireController,
                    decoration: const InputDecoration(labelText: 'Anniversaire (JJ/MM/AAAA)'),
                    keyboardType: TextInputType.datetime,
                  ),
                  TextField(
                    controller: _adresseController,
                    decoration: const InputDecoration(labelText: 'Adresse'),
                  ),
                  TextField(
                    controller: _codePostalController,
                    decoration: const InputDecoration(labelText: 'Code Postal'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Limite aux chiffres uniquement
                  ),
                  TextField(
                    controller: _villeController,
                    decoration: const InputDecoration(labelText: 'Ville'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveUserData,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: const Color.fromARGB(255, 198, 255, 187), // Texte noir pour le bouton
                    ),
                    child: const Text('Valider'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Naviguer vers la page d'ajout du vêtement
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddClothingPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: const Color.fromARGB(255, 198, 255, 187), // Texte noir pour le bouton
                    ),
                    child: const Text('Ajouter un nouveau vêtement'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _logout,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // Texte blanc pour le bouton
                    ),
                    child: const Text('Se déconnecter'),
                  ),
                ],
              ),
            ),
    );
  }
}
