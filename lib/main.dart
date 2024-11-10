import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Assurez-vous d'importer les options Firebase
import 'login.dart';           // Importer la page de connexion
import 'buy.dart';             // Importer la page d'achat
import 'cart.dart';            // Importer la page du panier
import 'profile.dart';         // Importer la page de profil

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialisation de Firebase
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synted',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[900], // Fond gris foncé pour tout l'app
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 21, 21, 21),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15, // Taille de police pour afficher 'Synted' en grand
            letterSpacing: 1, // Espacement entre les lettres
          ),
        ),
        // Colorie la barre de navigation en bas et les icônes
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 21, 21, 21), // Couleur sombre
          selectedItemColor: const Color.fromARGB(255, 198, 255, 187), // Couleur pastel claire
          unselectedItemColor: Colors.grey, // Couleur grise pour les éléments non sélectionnés
        ),
      ),
      home: const LoginPage(), // Page de connexion par défaut
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Liste des pages pour la navigation
  static final List<Widget> _pages = <Widget>[
    const BuyPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Synted', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ), // Centrer le titre
      ),
      body: _pages[_selectedIndex],  // Afficher la page sélectionnée
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,  // Gérer le changement de page
      ),
    );
  }
}
