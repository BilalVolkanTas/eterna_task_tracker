import 'package:flutter/material.dart';

class AppColors {
  // Ana Aksan Renkleri (Göz Yormayan Mat ve Şık)
  static const Color primary = Color(0xFF6366F1); // Yumuşak İndigo
  static const Color secondary = Color(0xFF10B981); // Mat Zümrüt Yeşili
  static const Color accent = Color(0xFFF59E0B); // Ilık Kehribar

  // Öncelik Renkleri (TaskCard & HabitCard Tarafından Kullanılır)
  static const Color priorityLow = Color(0xFF10B981); // Düşük - Yeşil
  static const Color priorityMedium = Color(0xFFF59E0B); // Orta - Turuncu
  static const Color priorityHigh = Color(0xFFEF4444); // Yüksek - Kırmızı

  // Degrade (Gradient) Geçişleri
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient habitGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Göz Yormayan Arka Plan & Kart Renkleri (Açık Tema)
  static const Color lightBackground = Color(
    0xFFF1F5F9,
  ); // Yumuşak mat Slate-Gri
  static const Color lightSurface = Color(0xFFFFFFFF); // Şık Mat Beyaz Kartlar
  static const Color lightTextPrimary = Color(0xFF1E293B); // Koyu Mat Slate
  static const Color lightTextSecondary = Color(0xFF64748B); // Doygun Gri Metin
  static const Color lightBorder = Color(0xFFE2E8F0); // İnce Mat Çerçeve

  // Koyu Tema Renkleri
  static const Color darkBackground = Color(0xFF0F172A); // Derin Füme
  static const Color darkSurface = Color(0xFF1E293B); // Yumuşak Koyu Kartlar
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Vurgu ve Durum Renkleri
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
}
