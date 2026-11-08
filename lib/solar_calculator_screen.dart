import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SolarCalculatorScreen extends StatefulWidget {
  const SolarCalculatorScreen({super.key});

  @override
  State<SolarCalculatorScreen> createState() => _SolarCalculatorScreenState();
}

class _SolarCalculatorScreenState extends State<SolarCalculatorScreen> {
  final _powerController = TextEditingController();
  final _hoursController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _calculateAndSave() async {
    final powerStr = _powerController.text.trim();
    final hoursStr = _hoursController.text.trim();

    if (powerStr.isEmpty || hoursStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الاستطاعة وعدد الساعات')),
      );
      return;
    }

    final double? power = double.tryParse(powerStr);
    final double? hours = double.tryParse(hoursStr);

    if (power == null || hours == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال أرقام صحيحة')),
      );
      return;
    }

    // حساب الطاقة المطلوبة (واط ساعة)
    final double totalEnergy = power * hours;
    setState(() {
      _result = 'الطاقة المطلوبة: ${totalEnergy.toStringAsFixed(2)} واط ساعة يومياً';
      _isLoading = true;
    });

    try {
      // حفظ العملية في قاعدة البيانات لتظهر في شاشة السجل
      await FirebaseFirestore.instance.collection('history').add({
        'title': 'حساب طاقة شمسية',
        'details': 'استطاعة: $power واط | مدة: $hours ساعات | الإجمالي: ${totalEnergy.toStringAsFixed(0)} واط ساعة',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حساب وحفظ العملية في السجل بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبة الطاقة الشمسية'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _powerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'استطاعة الجهاز (بالواط)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flash_on),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'عدد ساعات التشغيل يومياً',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _calculateAndSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'احسِب واحفظ في السجل',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 30),
            if (_result.isNotEmpty)
              Card(
                elevation: 3,
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _result,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}