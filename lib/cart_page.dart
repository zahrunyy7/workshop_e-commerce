import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'jewelry_model.dart';
import 'product_provider.dart';
// JANGAN LUPA IMPORT INI
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartItems = productProvider.cartItems;

    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    double total = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.harga * (item.jumlah > 0 ? item.jumlah : 1)),
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
          ? _buildEmptyState()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.gambar,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                            title: Text(
                              item.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              currencyFormatter.format(item.harga),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                productProvider.removeFromCart(item);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Kita masukkan list barang ke checkout jika diperlukan
                _buildTotalSection(
                  total,
                  currencyFormatter,
                  context,
                  cartItems,
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 10),
          const Text(
            "Wah, keranjangmu masih kosong!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(
    double total,
    NumberFormat formatter,
    BuildContext context,
    List<Jewelry> cartItems, // Tambahkan parameter ini
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
                  "Total Harga",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  formatter.format(total),
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
                backgroundColor: const Color(0xFFC5A059),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: cartItems.isEmpty
                  ? null // Tombol mati kalau kosong
                  : () {
                      // PINDAH KE HALAMAN CHECKOUT
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutPage(),
                        ),
                      );
                    },
              child: const Text(
                "CHECKOUT",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
