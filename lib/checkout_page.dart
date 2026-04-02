import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'jewelry_model.dart';
import 'product_provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("CHECKOUT"),
        backgroundColor: const Color(0xFFC5A059),
      ),

      /// 🔥 STREAM BUILDER
      body: StreamBuilder<List<Jewelry>>(
        stream: provider.cartStream,
        builder: (context, snapshot) {
          final cartItems = snapshot.data ?? [];

          double total = cartItems.fold(
            0.0,
            (sum, item) => sum + ((item.harga ?? 0) * (item.jumlah ?? 1)),
          );

          if (cartItems.isEmpty) {
            return const Center(child: Text("Keranjang kosong"));
          }

          return Column(
            children: [
              /// LIST PRODUK
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    return ListTile(
                      title: Text(item.nama),
                      subtitle: Text(
                        "${item.jumlah} x ${formatter.format(item.harga ?? 0)}",
                      ),
                      trailing: Text(
                        formatter.format(
                          (item.harga ?? 0) * (item.jumlah ?? 1),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// TOTAL + BUTTON
              Container(
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
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 16)),
                        Text(
                          formatter.format(total),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC5A059),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        /// SIMULASI CHECKOUT
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Checkout berhasil!")),
                        );
                      },
                      child: const Text("BAYAR"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
