import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Formun durumunu kontrol etmek için key
  final _formKey = GlobalKey<FormState>();

  // Giriş mi Kayıt mı modunda olduğunu tutan değişken
  bool _isLogin = true;

  // Şifre görünürlüğü kontrolü
  bool _obscurePassword = true;

  // Text Controller'lar (Verileri almak için)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Formu gönderme işlemi
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validasyon başarılıysa burası çalışır
      final email = _emailController.text;
      final password = _passwordController.text;

      if (_isLogin) {
        print("Giriş yapılıyor: $email");
        // BURAYA: API Giriş isteği veya Firebase Auth kodu gelecek
      } else {
        print("Kayıt olunuyor: $email");
        // BURAYA: API Kayıt isteği kodu gelecek
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // ERP için kurumsal hafif gri arka plan
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- LOGO VEYA BAŞLIK ALANI ---
              Icon(
                Icons.business_center,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                "AFSUAM ERP ", // Projenizin Adı
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isLogin ? "Hesabınıza Giriş Yapın" : "Yeni Hesap Oluşturun",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 40),

              // --- FORM ALANI ---
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // E-MAIL ALANI
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "E-Posta Adresi",
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen e-posta giriniz';
                            }
                            if (!value.contains('@')) {
                              return 'Geçerli bir e-posta giriniz';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // ŞİFRE ALANI
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: "Şifre",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen şifre giriniz';
                            }
                            if (value.length < 6) {
                              return 'Şifre en az 6 karakter olmalı';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // GİRİŞ / KAYIT BUTONU
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _isLogin ? "GİRİŞ YAP" : "KAYIT OL",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- MOD DEĞİŞTİRME (Giriş <-> Kayıt) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin
                        ? "Hesabınız yok mu?"
                        : "Zaten bir hesabınız var mı?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin; // Modu tersine çevir
                        _formKey.currentState?.reset(); // Formu temizle
                        _emailController.clear();
                        _passwordController.clear();
                      });
                    },
                    child: Text(
                      _isLogin ? "Üye Ol" : "Giriş Yap",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}