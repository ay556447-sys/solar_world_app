import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage {
  static final ValueNotifier<Locale> currentLocale = ValueNotifier(const Locale('ar'));

  static Future<void> initLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String langCode = prefs.getString('app_language_code') ?? 'ar';
    currentLocale.value = Locale(langCode);
  }

  static Future<void> changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language_code', langCode);
    currentLocale.value = Locale(langCode);
  }
}