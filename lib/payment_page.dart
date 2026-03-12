import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = "Transfer Bank";
  final Color navyColor = const Color(
    0xFF1A237E,
  ); // Kita definisikan warna navy di sini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Metode Pembayaran",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: navyColor,
      ),
      body: Column(
        children: [
          _buildOption("Transfer Bank", Icons.account_balance),
          _buildOption("E-Wallet", Icons.account_balance_wallet),
          _buildOption("COD", Icons.local_shipping),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: navyColor,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Simpan Metode",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: navyColor),
      title: Text(title),
      trailing: Radio(
        value: title,
        groupValue: selectedMethod,
        onChanged: (value) => setState(() => selectedMethod = value.toString()),
      ),
    );
  }
}
