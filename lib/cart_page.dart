import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'jewelry_model.dart';

class CartPage extends StatelessWidget {
  final List<Jewelry> items;
  const CartPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // 1. Filter barang yang jumlahnya > 0
    final cartItems = items.where((i) => i.jumlah > 0).toList();

    // 2. PERBAIKAN UTAMA: Mulai dari 0.0 (double) agar tidak error saat dikalikan harga
    double total = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.harga * item.jumlah),
    );

    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),
      appBar: AppBar(
        title: const Text(
          "KERANJANG",
          style: TextStyle(
            color: Color(0xFF8E6E53),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF8E6E53)),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Keranjangmu masih kosong."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.gambar,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${item.jumlah} x ${currencyFormatter.format(item.harga)}",
                          ),
                          trailing: Text(
                            currencyFormatter.format(item.harga * item.jumlah),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC5A059),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bagian Total & Tombol Beli
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Total Pembayaran",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              currencyFormatter.format(total),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Melanjutkan ke Pembayaran..."),
                              ),
                            );
                          },
                          child: const Text(
                            "BELI SEKARANG",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
