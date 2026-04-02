import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Tambahkan import provider
import 'marketplace_page.dart';
import 'profile_page.dart';
import 'cart_page.dart';
import 'admin_page.dart'; // Jangan lupa import admin_page
import 'product_provider.dart'; // 2. Import provider produk

class MainNavigation extends StatefulWidget {
  final String nama, email, alamat, telepon;
  const MainNavigation({
    super.key,
    required this.nama,
    required this.email,
    required this.alamat,
    required this.telepon,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 3. Ambil data dari Provider (bukan list manual lagi)
    final productProvider = Provider.of<ProductProvider>(context);
    final allProducts = productProvider.items;

    final List<Widget> pages = [
      JewelryMarketplace(
        // Sekarang pakai data dari provider
        items: allProducts,
        onUpdate: () => setState(() {}),
        nama: widget.nama,
        email: widget.email,
        alamat: widget.alamat,
        telepon: widget.telepon,
      ),
      CartPage(items: allProducts),
      SettingsPage(
        nama: widget.nama,
        email: widget.email,
        alamat: widget.alamat,
        telepon: widget.telepon,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFFC5A059),
        type: BottomNavigationBarType.fixed, // Tambahkan ini agar stabil
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final String nama, email, alamat, telepon;
  const SettingsPage({
    super.key,
    required this.nama,
    required this.email,
    required this.alamat,
    required this.telepon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),
      appBar: AppBar(
        title: const Text(
          "PENGATURAN",
          style: TextStyle(
            color: Color(0xFF8E6E53),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // BAGIAN ADMIN (CRUD)
          _buildSectionTitle("ADMINISTRATOR"),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF000080).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Color(0xFF000080),
                ),
              ),
              title: const Text(
                'Panel Admin (CRUD)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Kelola semua produk perhiasan'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPage()),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          _buildSectionTitle("AKUN"),
          _buildSettingItem(
            icon: Icons.person_outline,
            title: "Profil VIP",
            subtitle: "Detail informasi pribadi Anda",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    nama: nama,
                    email: email,
                    alamat: alamat,
                    telepon: telepon,
                  ),
                ),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.history,
            title: "Riwayat Pesanan",
            subtitle: "Lihat transaksi perhiasan Anda",
          ),

          const SizedBox(height: 20),
          _buildSectionTitle("PREFERENSI"),
          _buildSettingItem(
            icon: Icons.notifications_none,
            title: "Notifikasi",
            subtitle: "Atur pemberitahuan promo & stok",
          ),
          _buildSettingItem(
            icon: Icons.security_outlined,
            title: "Keamanan Akun",
            subtitle: "Ubah password & PIN",
          ),

          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false),
              child: const Text(
                "KELUAR AKUN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFC5A059).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFC5A059)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: onTap ?? () {},
      ),
    );
  }
}
