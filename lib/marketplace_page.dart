import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'product_provider.dart';
import 'jewelry_model.dart';
import 'product_detail_page.dart'; // Sesuaikan dengan nama file detail page kamu

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String kategoriTerpilih = "Semua";
  final List<String> daftarKategori = [
    "Semua",
    "Cincin",
    "Kalung",
    "Anting",
    "Gelang",
    "Lainnya",
  ];

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final productProvider = Provider.of<ProductProvider>(context);

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
          // KATEGORI
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
                          color: isSelected ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // DAFTAR PRODUK (STREAM DARI FIREBASE)
          Expanded(
            child: StreamBuilder<List<Jewelry>>(
              stream: productProvider
                  .getProductsStream(), // Ambil data real-time
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFC5A059)),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Produk belum tersedia di Firebase"),
                  );
                }

                final filteredItems = snapshot.data!.where((item) {
                  return kategoriTerpilih == "Semua" ||
                      item.kategori == kategoriTerpilih;
                }).toList();

                return ListView.builder(
                  itemCount: filteredItems.length,
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: item),
                        ),
                      ),
                      child: _buildProductCard(
                        item,
                        currencyFormat,
                        productProvider,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    Jewelry item,
    NumberFormat formatter,
    ProductProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              item.gambar,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, e, s) => Container(
                width: 90,
                height: 90,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image),
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
                    color: Color(0xFF8E6E53),
                  ),
                ),
                Text(
                  item.kategori,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  formatter.format(item.harga),
                  style: const TextStyle(
                    color: Color(0xFFC5A059),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart, color: Color(0xFFC5A059)),
            onPressed: () {
              provider.addToCart(item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${item.nama} ditambah ke keranjang")),
              );
            },
          ),
        ],
      ),
    );
  }
}
