import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Tambahkan ini untuk format uang
import 'product_provider.dart';
import 'jewelry_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Jewelry product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    const Color goldColor = Color(0xFFC5A059);
    const Color brownColor = Color(0xFF8E6E53);

    // Format Rupiah
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Akses Provider tanpa listen karena hanya menjalankan fungsi
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "DETAIL PRODUK",
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: brownColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Area Gambar dengan Badge Rating
            Stack(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: Image.network(
                    product.gambar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        Text(
                          " ${product.rating}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori & Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.kategori.toUpperCase(),
                        style: const TextStyle(
                          color: goldColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        currencyFormat.format(product.harga),
                        style: const TextStyle(
                          fontSize: 22,
                          color: brownColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Nama Produk
                  Text(
                    product.nama,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const Divider(height: 40, thickness: 1),

                  // Deskripsi
                  const Text(
                    "DESKRIPSI",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: brownColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product
                        .deskripsi, // Mengambil data deskripsi asli dari Firebase
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Tombol Tambah ke Keranjang
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brownColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        productProvider.addToCart(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${product.nama} masuk ke keranjang!",
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: brownColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "TAMBAH KE KERANJANG",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
