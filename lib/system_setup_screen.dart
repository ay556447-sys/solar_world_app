import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemSetupScreen extends StatefulWidget {
  const SystemSetupScreen({super.key});

  @override
  State<SystemSetupScreen> createState() => _SystemSetupScreenState();
}

class _SystemSetupScreenState extends State<SystemSetupScreen> {
  final _inverterController = TextEditingController(text: '3000');
  final _batteryController = TextEditingController(text: '200');
  final _panelsController = TextEditingController(text: '4');

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // تحميل البيانات المحفوظة سابقاً
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _inverterController.text = (prefs.getDouble('inverter_watt') ?? 3000.0).round().toString();
      _batteryController.text = (prefs.getDouble('battery_ah') ?? 200.0).round().toString();
      _panelsController.text = (prefs.getInt('panels_count') ?? 4).toString();
    });
  }

  // حفظ البيانات محلياً على الهاتف
  Future<void> _saveData() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final double inverterWatt = double.tryParse(_inverterController.text) ?? 3000.0;
    final double batteryAh = double.tryParse(_batteryController.text) ?? 200.0;
    final int panelsCount = int.tryParse(_panelsController.text) ?? 4;

    await prefs.setDouble('inverter_watt', inverterWatt);
    await prefs.setDouble('battery_ah', batteryAh);
    await prefs.setInt('panels_count', panelsCount);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ مواصفات منظومتك بنجاح! ⚡'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // إرجاع القيمة للشاشة الرئيسية لتحديث الحسابات
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('مواصفات المنظومة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أدخل بيانات منظومتك الشمسية ليعطيك التطبيق نصائح تشغيل دقيقة ومخصصة لك:',
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),

              // قدرة الإنفرتر
              _buildInputField(
                controller: _inverterController,
                label: 'قدرة الإنفرتر (Watt)',
                hint: 'مثال: 3000 أو 5000',
                icon: Icons.electric_bolt_rounded,
              ),

              const SizedBox(height: 16),

              // سعة البطارية
              _buildInputField(
                controller: _batteryController,
                label: 'سعة البطارية الإجمالية (Ah / أمبير)',
                hint: 'مثال: 150 أو 200',
                icon: Icons.battery_charging_full_rounded,
              ),

              const SizedBox(height: 16),

              // عدد الألواح
              _buildInputField(
                controller: _panelsController,
                label: 'عدد الألواح الشمسية',
                hint: 'مثال: 4 أو 6',
                icon: Icons.solar_power_rounded,
              ),

              const Spacer(),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : _saveData,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text('حفظ التعديلات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            prefixIcon: Icon(icon, color: const Color(0xFFFFD700), size: 20),
            filled: true,
            fillColor: const Color(0xFF161B22),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFFD700)),
            ),
          ),
        ),
      ],
    );
  }
}