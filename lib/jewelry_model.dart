import 'package:cloud_firestore/cloud_firestore.dart';

class Jewelry {
  final String? id;
  final String nama;
  final double harga;
  final String deskripsi;
  final String gambar;
  final String kategori;
  final double rating;
  int jumlah; // Variabel untuk keranjang

  Jewelry({
    this.id,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.gambar,
    required this.kategori,
    this.rating = 0.0,
    this.jumlah = 1,
  });

  // Fungsi untuk konversi dari Firebase (PENTING!)
  factory Jewelry.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Jewelry(
      id: doc.id,
      nama: data['nama'] ?? '',
      harga: (data['harga'] ?? 0).toDouble(),
      deskripsi: data['deskripsi'] ?? '',
      gambar: data['gambar'] ?? '',
      kategori: data['kategori'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }
}
