import 'package:flutter/material.dart';

/// Centralized color palette for the industrial MMS application.
/// Inspired by SAP Fiori / Modern Industrial UI design systems.
class AppColors {
  AppColors._();

  // ── PRIMARY ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primarySurface = Color(0xFFEFF6FF);
  static const Color primaryBorder = Color(0xFFBFDBFE);

  // ── SECONDARY / TEAL ─────────────────────────────────────────────────
  static const Color secondary = Color(0xFF0D9488);
  static const Color secondaryLight = Color(0xFF14B8A6);
  static const Color secondarySurface = Color(0xFFF0FDFA);

  // ── BACKGROUND & SURFACE ─────────────────────────────────────────────
  static const Color background = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // ── TEXT ──────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── STATUS ───────────────────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successSurface = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSurface = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFDC2626);
  static const Color errorSurface = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoSurface = Color(0xFFEFF6FF);

  // ── BADGE ────────────────────────────────────────────────────────────
  static const Color badge = Color(0xFFEF4444);

  // ── ICON BACKGROUND ──────────────────────────────────────────────────
  static const Color iconBackground = Color(0xFFE2E8F0);

  // ── SHADOW ───────────────────────────────────────────────────────────
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);

  // ── DIVIDER ──────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE2E8F0);

  // ── GRADIENT ─────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF0D9488)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  );
}
