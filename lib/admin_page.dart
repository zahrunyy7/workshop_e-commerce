import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import 'jewelry_model.dart';
import 'package:intl/intl.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  // Warna Tema Luxe Jewels
  static const Color primaryGold = Color(0xFFC5A059);
  static const Color scaffoldBg = Color(0xFFF8F4F0);
  static const Color textDark = Color(0xFF8E6E53);

  void _showForm(BuildContext context, {Jewelry? jewelry}) {
    final nameController = TextEditingController(text: jewelry?.nama ?? "");
    final priceController = TextEditingController(
      text: jewelry?.harga.toString() ?? "",
    );
    final descController = TextEditingController(
      text: jewelry?.deskripsi ?? "",
    );
    final isEdit = jewelry != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isEdit ? 'Edit Produk Mewah' : 'Tambah Koleksi Baru',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                nameController,
                'Nama Perhiasan',
                Icons.diamond_outlined,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                priceController,
                'Harga (Rp)',
                Icons.payments_outlined,
                isNumber: true,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                descController,
                'Deskripsi',
                Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGold,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    double? parsedPrice = double.tryParse(priceController.text);
                    if (parsedPrice == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Harga harus berupa angka!'),
                        ),
                      );
                      return;
                    }

                    final provider = Provider.of<ProductProvider>(
                      context,
                      listen: false,
                    );

                    if (isEdit) {
                      provider.editProduct(
                        jewelry.nama,
                        nameController.text,
                        parsedPrice,
                        descController.text,
                      );
                    } else {
                      provider.addProduct(
                        Jewelry(
                          nama: nameController.text,
                          harga: parsedPrice,
                          deskripsi: descController.text,
                          rating: 5.0,
                          kategori: "Baru",
                          gambar: "https://via.placeholder.com/150",
                        ),
                      );
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    isEdit ? 'SIMPAN PERUBAHAN' : 'TAMBAH KE KOLEKSI',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryGold, size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.items;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'KELOLA KOLEKSI',
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
      body: products.isEmpty
          ? const Center(child: Text('Belum ada koleksi perhiasan.'))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: products.length,
              itemBuilder: (ctx, i) => Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      // PERBAIKAN: Gunakan .withValues untuk menghindari peringatan deprecated
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      products[i].gambar,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    products[i].nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  subtitle: Padding(
                    // PERBAIKAN: EdgeInsets.only(top: 5) sudah benar
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      currencyFormat.format(products[i].harga),
                      style: const TextStyle(
                        color: primaryGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () =>
                            _showForm(context, jewelry: products[i]),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          productProvider.deleteProduct(products[i].nama);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGold,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showForm(context),
      ),
    );
  }
}
