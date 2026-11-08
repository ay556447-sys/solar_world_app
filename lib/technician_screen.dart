import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class TechnicianScreen extends StatelessWidget {
  const TechnicianScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فني الصيانة والتركيب'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('technicians')
            .doc('main_technician')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // إذا لم تكن البيانات موجودة في قاعدة البيانات، نعرض البيانات الافتراضية المعتمدة
          final data = snapshot.hasData && snapshot.data!.exists
              ? snapshot.data!.data() as Map<String, dynamic>
              : {};

          final name = data['name'] ?? data['الأسم'] ?? data['الاسم'] ?? 'الأستاذ ياسر';
          final specialty = data['specialty'] ?? data['تخصص'] ?? 'كهرباء و تركيب منظومات طاقة شمسية';
          final phone = (data['phone'] ?? data['رقم'] ?? '0936420700').toString();
          final location = data['location'] ?? data['مكان'] ?? 'دمشق و ريفها';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  specialty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.green),
                        title: const Text('رقم الهاتف'),
                        subtitle: Text(phone, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.green),
                        title: const Text('منطقة الخدمة'),
                        subtitle: Text(location, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _makePhoneCall(phone),
                    icon: const Icon(Icons.call, color: Colors.white),
                    label: const Text(
                      'الاتصال بالفني',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}