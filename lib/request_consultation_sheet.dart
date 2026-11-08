import 'package:flutter/material.dart';

class RequestConsultationSheet extends StatefulWidget {
  final int totalWatts;
  const RequestConsultationSheet({super.key, required this.totalWatts});

  @override
  State<RequestConsultationSheet> createState() => _RequestConsultationSheetState();
}

class _RequestConsultationSheetState extends State<RequestConsultationSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _selectedCity = 'دمشق';

  final List<String> _cities = ['دمشق', 'ريف دمشق', 'حمص', 'حماة', 'حلب', 'اللاذقية', 'طرطوس'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF161B22),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'طلب كشف ميداني / استشارة 🛠️',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'حمل المنظومة المطلوب: ${widget.totalWatts} واط',
              style: const TextStyle(color: Color(0xFFFFD700), fontSize: 14),
            ),
            const SizedBox(height: 16),

            // الاسم
            _buildInput('الاسم الكامل', Icons.person, _nameCtrl),
            const SizedBox(height: 12),

            // رقم الهاتف
            _buildInput('رقم التواصل (سيريتل / MTN)', Icons.phone, _phoneCtrl, isNumber: true),
            const SizedBox(height: 12),

            // المحافظة
            DropdownButtonFormField<String>(
              value: _selectedCity,
              dropdownColor: const Color(0xFF161B22),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'المحافظة',
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.location_city, color: Color(0xFFFFD700)),
                filled: true,
                fillColor: const Color(0xFF0D1117),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _cities.map((city) {
                return DropdownMenuItem(value: city, child: Text(city));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCity = val!),
            ),
            const SizedBox(height: 12),

            // العنوان التفصيلي
            _buildInput('العنوان التفصيلي / المنطقة', Icons.map, _addressCtrl),
            const SizedBox(height: 20),

            // زر الإرسال
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'إرسال الطلب للفنيين القريبين',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, IconData icon, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: const Color(0xFFFFD700)),
        filled: true,
        fillColor: const Color(0xFF0D1117),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _submitRequest() {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء الاسم ورقم الهاتف')),
      );
      return;
    }

    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('تم استلام طلبك بنجاح! 🎉', style: TextStyle(color: Colors.white)),
        content: const Text(
          'سيقوم أحد المهندسين أو الفنيين المعتمدين في منطقتك بالتواصل معك قريباً لتقديم الدراسة وتحديد موعد الكشف.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('حسناً', style: TextStyle(color: Color(0xFFFFD700))),
          ),
        ],
      ),
    );
  }
}