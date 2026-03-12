import 'package:flutter/material.dart';

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

class JewelryMarketplace extends StatefulWidget {
  final List<Jewelry> items;
  final VoidCallback onUpdate;
  final String nama, email, alamat, telepon;

  const JewelryMarketplace({
    super.key,
    required this.items,
    required this.onUpdate,
    required this.nama,
    required this.email,
    required this.alamat,
    required this.telepon,
  });

  @override
  State<JewelryMarketplace> createState() => _JewelryMarketplaceState();
}

class _JewelryMarketplaceState extends State<JewelryMarketplace> {
  String kategoriTerpilih = "Semua";
  final List<String> daftarKategori = [
    "Semua",
    "Cincin",
    "Kalung",
    "Anting",
    "Gelang",
  ];

  @override
  Widget build(BuildContext context) {
    // Filter produk berdasarkan kategori yang dipilih
    final filteredItems = widget.items.where((item) {
      return kategoriTerpilih == "Semua" || item.kategori == kategoriTerpilih;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),
      appBar: AppBar(
        title: const Text(
          "LUXE JEWELS",
          style: TextStyle(
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8E6E53),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // BAGIAN KATEGORI (Sudah Muncul Lagi)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daftarKategori.length,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemBuilder: (context, index) {
                bool isSelected = kategoriTerpilih == daftarKategori[index];
                return GestureDetector(
                  onTap: () =>
                      setState(() => kategoriTerpilih = daftarKategori[index]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFC5A059)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFC5A059).withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        daftarKategori[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // DAFTAR PRODUK
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return GestureDetector(
                  onTap: () {
                    // BIAR BISA DIKLIK LIHAT DESKRIPSI
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JewelryDetailPage(jewelry: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            item.gambar,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                item.kategori,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "Rp ${item.harga}",
                                style: const TextStyle(
                                  color: Color(0xFFC5A059),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // TOMBOL TAMBAH (+)
                        _buildCounter(item),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(Jewelry item) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
          onPressed: () => setState(() {
            if (item.jumlah > 0) {
              item.jumlah--;
              widget.onUpdate();
            }
          }),
        ),
        Text(
          "${item.jumlah}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Color(0xFFC5A059)),
          onPressed: () => setState(() {
            item.jumlah++;
            widget.onUpdate();
          }),
        ),
      ],
    );
  }
}

// HALAMAN DETAIL (Untuk melihat deskripsi)
class JewelryDetailPage extends StatelessWidget {
  final Jewelry jewelry;
  const JewelryDetailPage({super.key, required this.jewelry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jewelry.nama),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              jewelry.gambar,
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Text(
                    jewelry.nama,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(" ${jewelry.rating} | ${jewelry.kategori}"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    jewelry.deskripsi,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Rp ${jewelry.harga}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC5A059),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
