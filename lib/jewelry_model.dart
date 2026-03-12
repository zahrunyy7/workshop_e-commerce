class Jewelry {
  final String nama, deskripsi, kategori, gambar;
  final int harga;
  final double rating;
  int jumlah;

  Jewelry({
    required this.nama,
    required this.harga,
    required this.rating,
    required this.deskripsi,
    required this.kategori,
    required this.gambar,
    this.jumlah = 0,
  });
}
