import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'jewelry_model.dart';
import 'product_provider.dart';
import 'package:intl/intl.dart';

// --- INI CLASS YANG TADI HILANG ---
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  static const Color primaryGold = Color(0xFFC5A059);
  static const Color textDark = Color(0xFF8E6E53);

  // Daftar kategori untuk Dropdown
  static const List<String> categories = [
    'Cincin',
    'Kalung',
    'Gelang',
    'Anting',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    final productProv = Provider.of<ProductProvider>(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),
      appBar: AppBar(
        title: const Text(
          'KELOLA STOK LUXE',
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<Jewelry>>(
        stream: productProv.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryGold),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada koleksi perhiasan.'));
          }

          final listJewelry = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: listJewelry.length,
            itemBuilder: (ctx, i) {
              final item = listJewelry[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.gambar,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(
                    item.nama,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    currencyFormat.format(item.harga),
                    style: const TextStyle(color: primaryGold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () => _showForm(context, jewelry: item),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (item.id != null)
                            productProv.deleteProduct(item.id!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGold,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showForm(context),
      ),
    );
  }

  // Fungsi untuk memunculkan Modal Tambah/Edit
  void _showForm(BuildContext context, {Jewelry? jewelry}) {
    final nameController = TextEditingController(text: jewelry?.nama ?? "");
    final priceController = TextEditingController(
      text: jewelry?.harga.toInt().toString() ?? "",
    );
    final descController = TextEditingController(
      text: jewelry?.deskripsi ?? "",
    );
    final imageController = TextEditingController(text: jewelry?.gambar ?? "");
    String selectedCat = jewelry?.kategori ?? categories[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: selectedCat,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => selectedCat = v!,
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'URL Gambar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryGold),
              onPressed: () {
                final prov = Provider.of<ProductProvider>(
                  context,
                  listen: false,
                );
                final newProd = Jewelry(
                  nama: nameController.text,
                  harga: double.parse(priceController.text),
                  deskripsi: descController.text,
                  gambar: imageController.text,
                  kategori: selectedCat,
                );

                if (jewelry == null) {
                  prov.addProduct(newProd);
                } else {
                  prov.editProduct(jewelry.id, newProd);
                }
                Navigator.pop(ctx);
              },
              child: Text(
                jewelry == null ? 'TAMBAH' : 'SIMPAN',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
