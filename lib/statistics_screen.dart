import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إحصائيات النظام'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('history').snapshots(),
        builder: (context, historySnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
            builder: (context, ordersSnapshot) {
              if (historySnapshot.connectionState == ConnectionState.waiting ||
                  ordersSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final historyDocs = historySnapshot.data?.docs ?? [];
              final ordersDocs = ordersSnapshot.data?.docs ?? [];

              // حساب مجموع الاستهلاك اليومي بالكيلوواط من السجل
              double totalKwh = 0;
              for (var doc in historyDocs) {
                final data = doc.data() as Map<String, dynamic>;
                totalKwh += (data['kwh'] ?? 0).toDouble();
              }

              // حساب إجمالي قيم طلبات الشراء
              double totalOrdersValue = 0;
              for (var doc in ordersDocs) {
                final data = doc.data() as Map<String, dynamic>;
                totalOrdersValue += (data['price'] ?? 0).toDouble();
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildStatCard(
                      title: 'إجمالي الحسابات المحفوظة',
                      value: '${historyDocs.length} عملية',
                      icon: Icons.calculate,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      title: 'مجموع الاستهلاك اليومي المحسوب',
                      value: '${totalKwh.toStringAsFixed(2)} kWh',
                      icon: Icons.electric_bolt,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      title: 'إجمالي عدد الطلبات',
                      value: '${ordersDocs.length} طلب',
                      icon: Icons.shopping_bag,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      title: 'إجمالي قيمة الطلبات',
                      value: '\$${totalOrdersValue.toStringAsFixed(2)}',
                      icon: Icons.attach_money,
                      color: Colors.purple,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}