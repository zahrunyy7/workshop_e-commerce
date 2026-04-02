import 'package:flutter/material.dart';
import 'jewelry_model.dart';

class ProductProvider with ChangeNotifier {
  final List<Jewelry> _items = [
    Jewelry(
      nama: "Diamond Gold Ring",
      harga: 12500000,
      rating: 4.9,
      kategori: "Cincin",
      gambar:
          "https://i.pinimg.com/1200x/77/13/7b/77137b2b26f041eb29ea6a07993b23fb.jpg",
      deskripsi: "Cincin emas 18k dengan berlian murni.",
    ),
    Jewelry(
      nama: "Ocean Blue Necklace",
      harga: 8500000,
      deskripsi: "Kalung perak dengan liontin batu sapphire biru laut.",
      rating: 4.8,
      kategori: "Kalung",
      gambar:
          "https://i.pinimg.com/736x/58/4f/c6/584fc67482f08d28e1dbc96a0d160189.jpg",
    ),
    Jewelry(
      nama: "Rose Gold Bracelet",
      harga: 5200000,
      deskripsi: "Gelang rose gold minimalis untuk tampilan sehari-hari.",
      rating: 4.7,
      kategori: "Gelang",
      gambar:
          "https://i.pinimg.com/1200x/bd/17/6c/bd176cab3d866736b79a84d2ef83340a.jpg",
    ),
    Jewelry(
      nama: "Crystal Earrings",
      harga: 3500000,
      deskripsi: "Anting kristal swarovski yang berkilau mewah.",
      rating: 5.0,
      kategori: "Anting",
      gambar:
          "https://i.pinimg.com/736x/28/dd/37/28dd37100539afa05671a614133bbfb3.jpg",
    ),
  ];

  List<Jewelry> get items => [..._items];

  // Tambahkan fungsi ini untuk memperbaiki error di AdminPage
  void addProduct(Jewelry product) {
    _items.add(product);
    notifyListeners(); // Memberitahu Beranda untuk refresh
  }

  // Edit Produk
  void editProduct(
    String originalName,
    String newName,
    double newPrice,
    String newDesc,
  ) {
    final index = _items.indexWhere((p) => p.nama == originalName);
    if (index >= 0) {
      _items[index] = Jewelry(
        nama: newName,
        harga: newPrice,
        deskripsi: newDesc,
        rating: _items[index].rating,
        kategori: _items[index].kategori,
        gambar: _items[index].gambar,
      );
      notifyListeners();
    }
  }

  // Hapus Produk
  void deleteProduct(String name) {
    _items.removeWhere((p) => p.nama == name);
    notifyListeners(); // Beranda akan langsung kehilangan produk ini
  }
}
