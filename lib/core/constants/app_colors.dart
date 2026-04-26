import 'package:flutter/material.dart';

/// Paleta oficial de colores Ciclox
class AppColors {
  AppColors._();

  // ── Primarios ──────────────────────────────────────
  /// Azul marino oscuro (header, botones primarios)
  static const Color navy = Color(0xFF1A1F3C);

  /// Verde lima / acento Ciclox
  static const Color accent = Color(0xFFB4E614);

  /// Alias semántico: color primario de la marca
  static const Color primary = Color(0xFF1A1F3C);

  // ── Fondos ─────────────────────────────────────────
  static const Color background     = Color(0xFFF5F5F5);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F0F0);

  // ── Texto ──────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1F3C);
  static const Color textSecondary = Color(0xFF8D9196);
  static const Color textOnDark    = Color(0xFFFFFFFF);

  // ── Estado ─────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color error   = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info    = Color(0xFF2196F3);

  // ── Utilitarios ────────────────────────────────────
  static const Color divider      = Color(0xFFDDDDDD);
  static const Color cardShadow   = Color(0x14000000);
  static const Color overlay      = Color(0x801A1F3C);

  // ── Degradados ─────────────────────────────────────
  static const LinearGradient navyGradient = LinearGradient(
    colors: [Color(0xFF1A1F3C), Color(0xFF2D3566)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFB4E614), Color(0xFF8CC800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
