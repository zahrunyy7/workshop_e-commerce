import 'package:flutter/material.dart';
import 'marketplace_page.dart';

class CartPage extends StatelessWidget {
  final List<Jewelry> items;
  const CartPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Cari barang yang jumlahnya lebih dari 0
    final cartItems = items.where((i) => i.jumlah > 0).toList();

    // Hitung total harga
    int total = cartItems.fold(
      0,
      (sum, item) => sum + (item.harga * item.jumlah),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "KERANJANG",
          style: TextStyle(
            color: Color(0xFF8E6E53),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Keranjangmu masih kosong."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          item.gambar,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item.nama),
                        subtitle: Text("${item.jumlah} x Rp ${item.harga}"),
                        trailing: Text("Rp ${item.harga * item.jumlah}"),
                      );
                    },
                  ),
                ),
                // Bagian Total & Tombol Beli yang dipindah ke sini
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Total"),
                          Text(
                            "Rp $total",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC5A059),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          // Tambahkan aksi beli di sini
                        },
                        child: const Text(
                          "BELI SEKARANG",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
