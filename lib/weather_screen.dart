import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  double? _temperature;
  double? _humidity;
  double? _solarRadiation;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    const latitude = 33.5138;
    const longitude = 36.2765;
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,direct_normal_irradiance&timezone=auto',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _temperature = data['current']['temperature_2m']?.toDouble();
          _humidity = data['current']['relative_humidity_2m']?.toDouble();
          _solarRadiation = data['current']['direct_normal_irradiance']?.toDouble();
          _isLoading = false;
        });
      } else {
        setState(() => _errorMessage = 'فشل الاتصال بالسيرفر');
      }
    } catch (e) {
      setState(() => _errorMessage = 'تحقق من الإنترنت');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- ميزة تحليل الأحمال الجديدة ---
  Widget _buildLoadRecommendation() {
    double radiation = _solarRadiation ?? 0;
    String status;
    String message;
    Color color;

    if (radiation > 500) {
      status = 'ممتاز';
      message = 'الطاقة الشمسية وفيرة جداً، يمكنك تشغيل الغسالات أو السخانات بأمان.';
      color = Colors.green;
    } else if (radiation > 200) {
      status = 'مقبول';
      message = 'الإنتاج متوسط. يمكنك تشغيل أحمال خفيفة بحذر.';
      color = Colors.orange;
    } else {
      status = 'غير مناسب';
      message = 'الإنتاج الشمسي ضعيف أو غير متوفر. تجنب تشغيل الأحمال العالية.';
      color = Colors.red;
    }

    return Card(
      elevation: 4,
      color: color.withOpacity(0.1),
      child: ListTile(
        leading: Icon(Icons.power, color: color, size: 32),
        title: Text('حالة تشغيل الأحمال: $status', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        subtitle: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الطقس والتحليل الشمسي'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // بطاقة الإشعاع
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Icon(Icons.wb_sunny, size: 50, color: Colors.amber),
                            Text('${_solarRadiation?.toInt() ?? 0} W/m²', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // بطاقة التوصية الجديدة
                    _buildLoadRecommendation(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Card(child: ListTile(leading: const Icon(Icons.thermostat), title: Text('${_temperature} °C')))),
                        Expanded(child: Card(child: ListTile(leading: const Icon(Icons.water_drop), title: Text('${_humidity} %')))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}