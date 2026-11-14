import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class Product {
  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.icon,
    this.imageBytes,
  });

  final String name;
  final double price;
  final String category;
  final String description;
  final IconData icon;
  final Uint8List? imageBytes;
}

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  String name = 'Andy Campos';
  String email = 'admin@demo.com';
  Uint8List? avatarBytes;
  Color accent = CupertinoColors.activeBlue;
  bool notificationsEnabled = true;

  final List<Product> _products = [
    Product(
      name: 'Mesa de escritorio',
      price: 350,
      category: 'Muebles',
      description: 'Mesa de madera para oficina.',
      icon: CupertinoIcons.square_grid_2x2,
    ),
    Product(
      name: 'Silla gamer',
      price: 450,
      category: 'Muebles',
      description: 'Silla ergonómica para largas sesiones.',
      icon: CupertinoIcons.bed_double,
    ),
    Product(
      name: 'Teclado mecánico',
      price: 250,
      category: 'Tecnología',
      description: 'Teclado mecánico con iluminación.',
      icon: CupertinoIcons.keyboard,
    ),
    Product(
      name: 'Monitor 24 pulgadas',
      price: 620,
      category: 'Tecnología',
      description: 'Monitor de alta definición.',
      icon: CupertinoIcons.desktopcomputer,
    ),
    Product(
      name: 'Mouse inalámbrico',
      price: 120,
      category: 'Tecnología',
      description: 'Mouse inalámbrico compacto.',
      icon: CupertinoIcons.cursor_rays,
    ),
  ];

  List<Product> get products => List.unmodifiable(_products);

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void updateProfile(String newName, String newEmail) {
    name = newName;
    email = newEmail;
    notifyListeners();
  }

  void updateAvatar(Uint8List bytes) {
    avatarBytes = bytes;
    notifyListeners();
  }

  void updateAccent(Color color) {
    accent = color;
    notifyListeners();
  }

  void updateNotifications(bool enabled) {
    notificationsEnabled = enabled;
    notifyListeners();
  }
}
