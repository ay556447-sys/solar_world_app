import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String _adminPassword = "123";
  String _currentLanguage = "العربية"; // اللغة الافتراضية

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  // تحميل اللغة المحفوظة
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = prefs.getString('app_language') ?? "العربية";
    });
  }

  // تغيير وحفظ اللغة
  Future<void> _changeLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang);
    setState(() {
      _currentLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onLongPress: () => _checkAdminPassword(context),
          child: Text(
            _currentLanguage == 'العربية' ? 'الإعدادات' : 'Settings',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingTile(
              icon: Icons.dark_mode,
              title: _currentLanguage == 'العربية' ? 'المظهر' : 'Theme',
              subtitle: _currentLanguage == 'العربية' ? 'الوضع الداكن' : 'Dark Mode',
              onTap: () {},
            ),
            
            // خيار تحديد اللغة
            _buildSettingTile(
              icon: Icons.language,
              title: _currentLanguage == 'العربية' ? 'اللغة' : 'Language',
              subtitle: _currentLanguage,
              onTap: () => _showLanguageDialog(context),
            ),

            _buildSettingTile(
              icon: Icons.info_outline,
              title: _currentLanguage == 'العربية' ? 'عن التطبيق' : 'About App',
              subtitle: 'Energy App v1.0',
              onTap: () {},
            ),

            const Spacer(),

            // توقيع المطور باسم Ammar Aldais
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.2)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.code, color: Color(0xFFFFD700), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Developed by Ammar Aldais',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Energy © 2026',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFFD700)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
        onTap: onTap,
      ),
    );
  }

  // نافذة اختيار اللغة (العربية / English)
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: Text(
          _currentLanguage == 'العربية' ? 'اختر اللغة' : 'Select Language',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية', style: TextStyle(color: Colors.white)),
              trailing: _currentLanguage == 'العربية' ? const Icon(Icons.check, color: Color(0xFFFFD700)) : null,
              onTap: () {
                _changeLanguage('العربية');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('English', style: TextStyle(color: Colors.white)),
              trailing: _currentLanguage == 'English' ? const Icon(Icons.check, color: Color(0xFFFFD700)) : null,
              onTap: () {
                _changeLanguage('English');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  // دخول الإدارة المخفي
  void _checkAdminPassword(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFD700))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
            onPressed: () {
              if (passwordController.text == _adminPassword) {
                Navigator.pop(ctx);
                _showEditShamCashDialog(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wrong Password!'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Enter', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // نافذة تعديل رقم شام كاش
  void _showEditShamCashDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final currentNumber = prefs.getString('sham_cash_account') ?? "09XXXXXXXX";
    final numberController = TextEditingController(text: currentNumber);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Edit Sham Cash Number', style: TextStyle(color: Colors.white, fontSize: 15)),
        content: TextField(
          controller: numberController,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'New Account Number',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFD700))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
            onPressed: () async {
              await prefs.setString('sham_cash_account', numberController.text);
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sham Cash Number Saved Successfully!'), backgroundColor: Colors.green),
                );
              }
            },
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}