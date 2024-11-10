import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Panier'),
        backgroundColor: const Color.fromARGB(255, 21, 21, 21), // AppBar sombre
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: getCurrentUserId())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement du panier', style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Votre panier est vide', style: TextStyle(color: Colors.white)));
          }

          final cartItems = snapshot.data!.docs;
          double total = 0;

          for (var item in cartItems) {
            total += (item['price'] ?? 0).toDouble();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index].data() as Map<String, dynamic>;

                    return Card(
                      color: Colors.grey[800], // Fond sombre pour chaque item
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: cartItem['image'] != null
                            ? Image.network(cartItem['image'])
                            : const Icon(Icons.image, color: Colors.white),
                        title: Text(
                          cartItem['itemName'] ?? 'Nom indisponible',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), // Augmenter la taille de la police
                        ),
                        subtitle: Text(
                          'Prix: ${cartItem['price']} €',
                          style: const TextStyle(color: Colors.white, fontSize: 16), // Augmenter la taille de la police
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('cart')
                                .doc(cartItems[index].id)
                                .delete();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: $total €',
                  style: const TextStyle(
                    fontSize: 22, // Augmenter la taille du texte du total
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Texte blanc
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
