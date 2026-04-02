import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'jewelry_model.dart';

class ProductProvider {
  /// ===============================
  /// 🔥 FIRESTORE COLLECTION
  /// ===============================
  final CollectionReference _productCol = FirebaseFirestore.instance.collection(
    'products',
  );

  /// ===============================
  /// 🔥 STREAM PRODUK (dari Firestore)
  /// ===============================
  Stream<List<Jewelry>> getProductsStream() {
    return _productCol.orderBy('createdAt', descending: true).snapshots().map((
      snap,
    ) {
      return snap.docs.map((doc) {
        return Jewelry.fromFirestore(doc);
      }).toList();
    });
  }

  /// ===============================
  /// 🔥 TAMBAH PRODUK
  /// ===============================
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
      debugPrint("Gagal tambah: $e");
    }
  }

  /// ===============================
  /// 🛒 CART (STREAM BASED)
  /// ===============================
  final List<Jewelry> _cartItems = [];

  final StreamController<List<Jewelry>> _cartController =
      StreamController<List<Jewelry>>.broadcast();

  Stream<List<Jewelry>> get cartStream => _cartController.stream;

  /// TAMBAH KE CART
  void addToCart(Jewelry item) {
    _cartItems.add(item);
    _cartController.sink.add(List.from(_cartItems));
  }

  /// HAPUS DARI CART
  void removeFromCart(Jewelry item) {
    _cartItems.remove(item);
    _cartController.sink.add(List.from(_cartItems));
  }

  /// TAMBAH JUMLAH
  void tambahJumlah(Jewelry item) {
    item.jumlah = (item.jumlah ?? 1) + 1;
    _cartController.sink.add(List.from(_cartItems));
  }

  /// KURANG JUMLAH
  void kurangJumlah(Jewelry item) {
    if ((item.jumlah ?? 1) > 1) {
      item.jumlah = item.jumlah! - 1;
      _cartController.sink.add(List.from(_cartItems));
    }
  }

  /// TOTAL HARGA (helper, bukan stream)
  double get totalCartPrice {
    return _cartItems.fold(0.0, (total, item) {
      final harga = item.harga ?? 0;
      final jumlah = item.jumlah ?? 1;
      return total + (harga * jumlah);
    });
  }

  /// WAJIB: dispose biar gak memory leak
  void dispose() {
    _cartController.close();
  }
}
