import 'package:flutter/material.dart';
import 'jewelry_model.dart'; // <--- WAJIB ADA INI
import 'product_detail_page.dart';

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

  // Warna Konsisten Luxe Jewels
  final Color goldColor = const Color(0xFFC5A059);
  final Color brownColor = const Color(0xFF8E6E53);

  @override
  Widget build(BuildContext context) {
    // Filter produk dinamis
    final filteredItems = widget.items.where((item) {
      return kategoriTerpilih == "Semua" || item.kategori == kategoriTerpilih;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),
      appBar: AppBar(
        title: Text(
          "LUXE JEWELS",
          style: TextStyle(
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            color: brownColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Kategori
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
                      color: isSelected ? goldColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: goldColor.withValues(alpha: 0.3),
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

          // Daftar Barang Marketplace
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                final item = filteredItems[index]; // Data per item

                return GestureDetector(
                  onTap: () {
                    // SEKARANG SUDAH NYAMBUNG: Ambil data dari variabel 'item'
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          title: item.nama,
                          price: "Rp ${item.harga}",
                          imagePath: item.gambar,
                        ),
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
                          color: Colors.black.withValues(alpha: 0.05),
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
                            errorBuilder: (c, e, s) => const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
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
                                style: TextStyle(
                                  color: goldColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
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
