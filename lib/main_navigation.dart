import 'package:flutter/material.dart';
import 'marketplace_page.dart';
import 'profile_page.dart';
import 'cart_page.dart';
import 'admin_page.dart';

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

  // List halaman yang akan ditampilkan di Bottom Navigation
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const MarketplacePage(),
      const CartPage(), // Pastikan CartPage sudah didefinisikan sebagai const jika memungkinkan
      SettingsPage(
        nama: widget.nama,
        email: widget.email,
        alamat: widget.alamat,
        telepon: widget.telepon,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFC5A059),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Biar label tidak geser-geser
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

// --- HALAMAN PENGATURAN ---
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
    const Color primaryGold = Color(0xFFC5A059);
    const Color textDark = Color(0xFF8E6E53);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),
      appBar: AppBar(
        title: const Text(
          "PENGATURAN",
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildSectionTitle("ADMINISTRATOR"),
          _buildAdminTile(context),
          const SizedBox(height: 25),
          _buildSectionTitle("AKUN"),
          _buildSettingItem(
            icon: Icons.person_outline,
            title: "Profil VIP",
            subtitle: "Detail informasi pribadi Anda",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  nama: nama,
                  email: email,
                  alamat: alamat,
                  telepon: telepon,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildAdminTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF000080).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.admin_panel_settings_outlined,
            color: Color(0xFF000080),
          ),
        ),
        title: const Text(
          'Panel Admin (CRUD)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Kelola stok perhiasan Luxe'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminPage()),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.1,
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
          child: Icon(icon, color: Color(0xFFC5A059)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () => Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/', (route) => false),
        child: const Text(
          "KELUAR AKUN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
