import 'package:flutter/material.dart';
import 'marketplace_page.dart';
import 'profile_page.dart';
import 'cart_page.dart';

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

  // DATA ASLI KAKAK (Diamond Gold Ring, Pearl Necklace, dll)
  final List<Jewelry> _allItems = [
    Jewelry(
      nama: "Diamond Gold Ring",
      harga: 12500000,
      rating: 4.9,
      kategori: "Cincin",
      gambar:
          "https://i.pinimg.com/1200x/77/13/7b/77137b2b26f041eb29ea6a07993b23fb.jpg",
      deskripsi:
          "Cincin emas 18k dengan berlian murni yang memberikan kesan mewah.",
    ),
    Jewelry(
      nama: "Diamond with White Gold Ring",
      harga: 11500000,
      rating: 4.9,
      kategori: "Cincin",
      gambar:
          "https://i.pinimg.com/1200x/85/8d/89/858d89cc4ebe2d4f8dcaabf2e037a06c.jpg",
      deskripsi: "Cincin emas Putih 18k dengan berlian murni.",
    ),
    Jewelry(
      nama: "Pearl Necklace",
      harga: 87500000,
      rating: 4.8,
      kategori: "Kalung",
      gambar:
          "https://i.pinimg.com/736x/13/b0/10/13b010a114b51e7fae8e8df102f676ed.jpg",
      deskripsi: "Kalung mutiara air laut alami dengan pengait emas putih.",
    ),
    Jewelry(
      nama: "Crystal Necklace",
      harga: 550500000,
      rating: 4.8,
      kategori: "Kalung",
      gambar:
          "https://i.pinimg.com/736x/57/4b/ca/574bca21602b1b7acab5fc1847fc0946.jpg",
      deskripsi: "Kalung Emas Putih 18k yang dihiasi Berlian murni mewah.",
    ),
    Jewelry(
      nama: "Crystal Earrings",
      harga: 50500000,
      rating: 4.8,
      kategori: "Anting",
      gambar:
          "https://i.pinimg.com/736x/28/dd/37/28dd37100539afa05671a614133bbfb3.jpg",
      deskripsi: "Anting Berlian Putih murni yang  mewah dan bercahaya.",
    ),
    Jewelry(
      nama: "Pearl Earrings",
      harga: 73500000,
      rating: 4.9,
      kategori: "Anting",
      gambar:
          "https://i.pinimg.com/1200x/ee/e1/d9/eee1d96618fcccf674f150f7b8fd603c.jpg",
      deskripsi:
          "Anting Berlian Putih murni yang dihiasi mutiara laut mewah dan bercahaya.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // List halaman ditaruh di dalam build agar data terbaru selalu terbaca
    final List<Widget> pages = [
      JewelryMarketplace(
        items: _allItems,
        onUpdate: () => setState(() {}),
        nama: widget.nama,
        email: widget.email,
        alamat: widget.alamat,
        telepon: widget.telepon,
      ),
      CartPage(items: _allItems),
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

// Widget Settings Page sederhana untuk navigasi ke profil
// Widget Settings Page yang lebih "Rame"
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

          // Bagian Akun
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

          // Bagian Preferensi
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
          _buildSettingItem(
            icon: Icons.language,
            title: "Bahasa",
            subtitle: "Indonesia",
          ),

          const SizedBox(height: 20),

          // Bagian Dukungan
          _buildSectionTitle("DUKUNGAN"),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: "Pusat Bantuan",
            subtitle: "FAQ & Customer Service",
          ),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: "Tentang Luxe Jewels",
            subtitle: "Versi 1.0.0",
          ),

          const SizedBox(height: 30),

          // Tombol Logout
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
              onPressed: () {
                // Balik ke halaman login
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              },
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

  // Widget pembantu untuk judul seksi
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

  // Widget pembantu untuk item setting
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
        onTap:
            onTap ??
            () {}, // Kalau belum ada aksi, dia bisa dipencet tapi nggak ke mana-mana
      ),
    );
  }
}
