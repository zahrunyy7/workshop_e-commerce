import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'jewelry_model.dart';

class ProductProvider with ChangeNotifier {
  // 1. DATA KERANJANG (LOKAL)
  final List<Jewelry> _cartItems = [];
  List<Jewelry> get cartItems => _cartItems;

  // 2. REFERENSI FIREBASE
  final CollectionReference _productCol = FirebaseFirestore.instance.collection(
    'products',
  );

  // ==========================================
  // LOGIKA PRODUK (FIREBASE)
  // ==========================================

  // Ambil data real-time
  Stream<List<Jewelry>> getProductsStream() {
    return _productCol.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Jewelry.fromFirestore(doc)).toList();
    });
  }

  // Tambah Produk ke Firebase
  Future<void> addProduct(Jewelry product) async {
    try {
      await _productCol.add({
        'nama': product.nama,
        'harga': product.harga,
        'deskripsi': product.deskripsi,
        'gambar': product.gambar,
        'kategori': product.kategori,
        'rating': product.rating,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error tambah produk: $e");
    }
  }

  // Edit Produk di Firebase
  Future<void> editProduct(String? id, Jewelry product) async {
    if (id == null) return;
    try {
      await _productCol.doc(id).update({
        'nama': product.nama,
        'harga': product.harga,
        'deskripsi': product.deskripsi,
        'gambar': product.gambar,
        'kategori': product.kategori,
      });
    } catch (e) {
      debugPrint("Error edit produk: $e");
    }
  }

  // Hapus Produk dari Firebase
  Future<void> deleteProduct(String id) async {
    try {
      await _productCol.doc(id).delete();
    } catch (e) {
      debugPrint("Error hapus produk: $e");
    }
  }

  // ==========================================
  // LOGIKA KERANJANG (LOKAL)
  // ==========================================

  void addToCart(Jewelry product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Jewelry product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void tambahJumlah(Jewelry product) {
    product.jumlah++;
    notifyListeners();
  }

  void kurangJumlah(Jewelry product) {
    if (product.jumlah > 1) {
      product.jumlah--;
      notifyListeners();
    }
  }

  // Menghitung total harga di keranjang (Harga x Jumlah)
  double get totalCartPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.harga * item.jumlah));
  }
} // <--- KURUNG PENUTUP CLASS HARUS DI PALING BAWAH
