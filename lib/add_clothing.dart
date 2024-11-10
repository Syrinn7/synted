import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pour choisir l'image
import 'dart:io'; // Pour manipuler les fichiers
import 'package:firebase_storage/firebase_storage.dart'; // Pour stocker l'image sur Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // Pour enregistrer les données dans Firestore
import 'dart:convert'; // Pour encoder en base64

class AddClothingPage extends StatefulWidget {
  const AddClothingPage({super.key});

  @override
  _AddClothingPageState createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _base64Controller = TextEditingController(); // Pour l'URL base64

  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _category;
  final List<String> categories = ['Accessoire', 'Pantalon', 'Haut', 'Chaussure']; // Liste des catégories

  Future<void> _pickImage() async {
    // Ouvrir la galerie pour sélectionner une image
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        // Déterminer la catégorie en fonction de l'image (à implémenter selon tes besoins)
        _category = 'Pantalon'; // Exemple, ici on attribue la catégorie "Pantalon"
      });
    }
  }

  Future<void> _submitClothing() async {
    if (_image == null && _base64Controller.text.isEmpty || _titleController.text.isEmpty || _sizeController.text.isEmpty || _brandController.text.isEmpty || _priceController.text.isEmpty || _category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    try {
      String imageUrl = '';
      // Si une image a été choisie via la galerie
      if (_image != null) {
        // Upload de l'image sur Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('clothing_images/${DateTime.now().toString()}');
        await storageRef.putFile(_image!);

        // Récupérer l'URL de l'image
        imageUrl = await storageRef.getDownloadURL();
      } else {
        // Si l'utilisateur a fourni un lien base64
        imageUrl = _base64Controller.text;
      }

      // Enregistrer les données dans Firestore
      await FirebaseFirestore.instance.collection('clothes').add({
        'Category': _category, // Catégorie du vêtement
        'Image': imageUrl, // URL de l'image ou base64
        'Marque': _brandController.text, // Marque
        'Name': _titleController.text, // Nom (Titre)
        'Price': double.tryParse(_priceController.text) ?? 0.0, // Prix
        'Taille': _sizeController.text, // Taille
        'createdAt': Timestamp.now(),
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vêtement ajouté avec succès')),
      );

      // Rediriger vers la page de profil après ajout
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Vêtement'),
        backgroundColor: Colors.black, // Changer la couleur de l'appbar si nécessaire
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  color: Colors.grey[800], // Fond sombre pour l'image
                  height: 200,
                  width: double.infinity,
                  child: _image == null
                      ? const Center(child: Text('Appuyez pour choisir une image', style: TextStyle(color: Colors.white)))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              // Champ pour entrer un lien base64
              TextField(
                controller: _base64Controller,
                decoration: const InputDecoration(
                  labelText: 'Ou entrez un lien en base64 de l\'image',
                  labelStyle: TextStyle(color: Colors.white), // Texte des labels en blanc
                ),
                style: const TextStyle(color: Colors.white), // Texte des champs en blanc
              ),
              const SizedBox(height: 8),
              // Champ catégorie avec un DropdownButton
              DropdownButton<String>(
                value: _category,
                hint: const Text('Sélectionnez une catégorie', style: TextStyle(color: Colors.white)),
                onChanged: (String? newCategory) {
                  setState(() {
                    _category = newCategory;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, style: const TextStyle(color: Colors.white)), // Texte en blanc
                  );
                }).toList(),
                 dropdownColor: const Color.fromARGB(255, 0, 0, 0),              
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white), // Texte des champs en blanc
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: 'Taille', labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white), // Texte des champs en blanc
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marque', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white), // Texte des champs en blanc
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Prix', labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white), // Texte des champs en blanc
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitClothing,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: const Color.fromARGB(255, 198, 255, 187), // Texte noir pour le bouton
                ),
                child: const Text('Valider', style: TextStyle(color: Colors.black)), // Texte du bouton en noir
              ),
            ],
          ),
        ),
      ),
    );
  }
}
