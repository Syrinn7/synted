import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'object_page.dart';

class BuyPage extends StatelessWidget {
  const BuyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Vêtements'),
        backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clothes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement des vêtements'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun vêtement trouvé'));
          }

          final clothes = snapshot.data!.docs;
          return SingleChildScrollView(
            child: Column(
              children: clothes.map<Widget>((doc) {
                final clothingItem = doc.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Naviguer vers la page des détails du vêtement
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ObjectPage(clothingItem: clothingItem),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.grey[800],
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          // Afficher l'image du vêtement en grand
                          clothingItem['Image'] != null
                              ? Image.network(
                                  clothingItem['Image'],
                                  width: double.infinity, // Prend toute la largeur
                                  height: 300, // Hauteur plus grande pour l'image
                                  fit: BoxFit.cover, // Ajuste l'image pour remplir l'espace
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 300,
                                  color: Colors.grey,
                                ),
                          const SizedBox(height: 12),

                          // Informations du vêtement
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clothingItem['Name'] ?? 'Nom indisponible',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Prix: ${(clothingItem['Price'] is int || clothingItem['Price'] is double) ? clothingItem['Price'].toStringAsFixed(2) : 'Prix indisponible'} €',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Taille: ${clothingItem['size'] ?? clothingItem['Taille'] ?? 'Taille indisponible'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
