import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Key untuk validasi form
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi"),
        backgroundColor: const Color(0xFFC5A059),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey, // Membungkus input dengan Form
          child: Column(
            children: [
              const Text(
                "REGISTRASI VIP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8E6E53),
                ),
              ),
              const SizedBox(height: 30),
              _buildInput(nameController, "Nama Lengkap"),
              _buildInput(emailController, "Email"),
              _buildInput(phoneController, "No. Telepon"),
              _buildInput(countryController, "Negara/Alamat"),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC5A059),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Munculkan SnackBar sukses sesuai tugas praktikum
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Registrasi Berhasil!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Kembali ke Login
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "DAFTAR SEKARANG",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label tidak boleh kosong";
          }
          return null;
        },
      ),
    );
  }
}
