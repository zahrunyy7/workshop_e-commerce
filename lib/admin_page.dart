import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'jewelry_model.dart';
import 'package:intl/intl.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  static const Color primaryGold = Color(0xFFC5A059);
  static const Color scaffoldBg = Color(0xFFF8F4F0);
  static const Color textDark = Color(0xFF8E6E53);

  // Daftar Kategori Tetap
  static const List<String> categories = [
    'Cincin',
    'Kalung',
    'Gelang',
    'Anting',
    'Lainnya',
  ];

  void _showForm(BuildContext context, {Jewelry? jewelry, String? docId}) {
    final nameController = TextEditingController(text: jewelry?.nama ?? "");
    final priceController = TextEditingController(
      text: jewelry?.harga.toString() ?? "",
    );
    final descController = TextEditingController(
      text: jewelry?.deskripsi ?? "",
    );
    final imageController = TextEditingController(text: jewelry?.gambar ?? "");

    // TAMBAHAN: Variable untuk menampung pilihan kategori
    String selectedCategory = jewelry?.kategori ?? categories[0];

    final isEdit = docId != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        // Pakai StatefulBuilder supaya Dropdown bisa berubah saat diklik
        builder: (context, setModalState) => Container(
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

                // TAMBAHAN: Dropdown Kategori
                const Text(
                  "Pilih Kategori",
                  style: TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      items: categories
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null)
                          setModalState(() => selectedCategory = val);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                _buildTextField(
                  descController,
                  'Deskripsi',
                  Icons.description_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  imageController,
                  'Link Foto Produk (URL)',
                  Icons.image_outlined,
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
                    onPressed: () async {
                      double? parsedPrice = double.tryParse(
                        priceController.text,
                      );
                      if (parsedPrice == null) return;

                      final collection = FirebaseFirestore.instance.collection(
                        'products',
                      );
                      String imageUrl = imageController.text.trim().isEmpty
                          ? "https://via.placeholder.com/150"
                          : imageController.text.trim();

                      if (isEdit) {
                        await collection.doc(docId).update({
                          'nama': nameController.text,
                          'harga': parsedPrice,
                          'deskripsi': descController.text,
                          'gambar': imageUrl,
                          'kategori':
                              selectedCategory, // Simpan kategori yang dipilih
                        });
                      } else {
                        await collection.add({
                          'nama': nameController.text,
                          'harga': parsedPrice,
                          'deskripsi': descController.text,
                          'gambar': imageUrl,
                          'kategori': selectedCategory, // Simpan kategori baru
                          'rating': 5.0,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
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

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'KELOLA KOLEKSI LUXE',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(color: primaryGold),
            );
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(child: Text('Belum ada koleksi perhiasan.'));

          final docs = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final String docId = docs[i].id;

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
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
                      data['gambar'] ?? "https://via.placeholder.com/150",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                  title: Text(
                    data['nama'] ?? "Tanpa Nama",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  // MODIFIKASI SUBTITLE: Menampilkan Kategori juga
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['kategori'] ?? "Lainnya",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        currencyFormat.format(data['harga'] ?? 0),
                        style: const TextStyle(
                          color: primaryGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          final jewelry = Jewelry(
                            nama: data['nama'],
                            harga: (data['harga'] as num).toDouble(),
                            deskripsi: data['deskripsi'],
                            gambar:
                                data['gambar'] ??
                                "https://via.placeholder.com/150",
                            rating: 5.0,
                            kategori: data['kategori'] ?? "Lainnya",
                          );
                          _showForm(context, jewelry: jewelry, docId: docId);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => FirebaseFirestore.instance
                            .collection('products')
                            .doc(docId)
                            .delete(),
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
}
