import 'package:cloud_firestore/cloud_firestore.dart'; // WAJIB ADA INI

class Jewelry {
  final String? id;
  final String nama;
  final double harga;
  final String deskripsi;
  final String gambar;
  final String kategori;
  final double rating;
  int jumlah; // Bisa berubah nilainya di keranjang

  Jewelry({
    this.id,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.gambar,
    required this.kategori,
    this.rating = 5.0,
    this.jumlah = 1,
  });

  // Fungsi untuk konversi dari data Firebase ke Objek Dart
  factory Jewelry.fromFirestore(DocumentSnapshot doc) {
    // Ambil data sebagai Map
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Jewelry(
      id: doc.id,
      nama: data['nama'] ?? '',
      // Gunakan (data['harga'] as num).toDouble() untuk mencegah error tipe data
      harga: (data['harga'] as num?)?.toDouble() ?? 0.0,
      deskripsi: data['deskripsi'] ?? '',
      gambar: data['gambar'] ?? '',
      kategori: data['kategori'] ?? 'Lainnya',
      rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
      jumlah: 1,
    );
  }

  // Bonus: Fungsi untuk konversi balik ke Map (biasanya dipakai saat Add/Edit ke Firebase)
  Map<String, dynamic> toFirestore() {
    return {
      'nama': nama,
      'harga': harga,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'kategori': kategori,
      'rating': rating,
      // 'jumlah' biasanya tidak disimpan ke Firebase koleksi produk,
      // hanya untuk logika keranjang lokal saja.
    };
  }
}
