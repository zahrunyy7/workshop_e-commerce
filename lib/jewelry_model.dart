class Jewelry {
  final String nama;
  final double harga;
  final double rating;
  final String kategori;
  final String gambar;
  final String deskripsi;
  int jumlah; // Pastikan baris ini ada

  Jewelry({
    required this.nama,
    required this.harga,
    required this.rating,
    required this.kategori,
    required this.gambar,
    required this.deskripsi,
    this.jumlah = 0,
  });
}
