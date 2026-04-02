import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Tambahkan ini
import 'package:intl/intl.dart'; // Tambahkan ini untuk format rupiah
import 'product_provider.dart'; // Tambahkan ini
import 'payment_success_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPayment = "Transfer Bank";
  final Color goldColor = const Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    // AMBIL DATA DARI PROVIDER
    final productProvider = Provider.of<ProductProvider>(context);
    final cartItems = productProvider.cartItems;

    // HITUNG TOTAL HARGA ASLI
    double total = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.harga * (item.jumlah > 0 ? item.jumlah : 1)),
    );

    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "CHECKOUT",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            _buildOption("Transfer Bank", Icons.account_balance),
            _buildOption("E-Wallet", Icons.account_balance_wallet),
            _buildOption("COD", Icons.local_shipping),

            const Spacer(),
            const Divider(thickness: 1),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Tagihan", style: TextStyle(fontSize: 16)),
                Text(
                  currencyFormatter.format(total), // PAKAI TOTAL ASLI
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  // Tambahkan logika untuk mengosongkan keranjang setelah bayar (opsional)
                  // productProvider.clearCart();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentSuccessPage(),
                    ),
                  );
                },
                child: const Text(
                  "BAYAR SEKARANG",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile(
        activeColor: goldColor,
        value: title,
        groupValue: selectedPayment,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        secondary: Icon(icon, color: goldColor),
        onChanged: (value) =>
            setState(() => selectedPayment = value.toString()),
      ),
    );
  }
}
