import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ObjectPage extends StatelessWidget {
  final Map<String, dynamic> clothingItem;

  const ObjectPage({super.key, required this.clothingItem});

  void _addToCart(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final cartItem = {
        'itemName': clothingItem['Name'] ?? 'Nom indisponible',
        'price': clothingItem['Price'] ?? 0,
        'image': clothingItem['Image'] ?? '',
        'size': clothingItem['size'] ?? clothingItem['Taille'] ?? 'Taille indisponible',
        'category': clothingItem['Category'] ?? 'Catégorie indisponible',
        'userId': userId,
      };

      FirebaseFirestore.instance.collection('cart').add(cartItem);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vêtement ajouté au panier')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur : utilisateur non connecté')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Fond gris foncé pour rester dans le thème
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 21, 21), // AppBar sombre
        title: const Text(
          'Détails du vêtement',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Affichage de l'image en taille réelle
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  clothingItem['Image'] ?? '',
                  width: double.infinity, // L'image occupe toute la largeur
                  height: MediaQuery.of(context).size.height * 0.4, // Fixer une hauteur raisonnable
                  fit: BoxFit.contain, // S'assurer que l'image reste entière et dans les limites
                ),
              ),
              const SizedBox(height: 20),

              // Détails du vêtement
              Text(
                clothingItem['Name'] ?? 'Nom indisponible',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Catégorie: ${clothingItem['Category'] ?? 'Catégorie indisponible'}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Taille: ${clothingItem['size'] ?? clothingItem['Taille'] ?? 'Taille indisponible'}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Marque: ${clothingItem['Marque'] ?? 'Marque indisponible'}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Prix: ${(clothingItem['Price'] is int || clothingItem['Price'] is double) ? clothingItem['Price'].toStringAsFixed(2) : 'Prix indisponible'} €',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const SizedBox(height: 30),

              // Bouton ajouter au panier
              ElevatedButton(
                onPressed: () => _addToCart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 198, 255, 187),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Ajouter au panier',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
