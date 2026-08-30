import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF60A5FA);

  static const Color secondary = Color(0xFF0D9488); // Teal
  static const Color accent = Color(0xFFF59E0B); // Amber

  // Pipeline Status Colors
  static const Color statusApplied = Color(0xFF3B82F6); // Blue
  static const Color statusScreening = Color(0xFF8B5CF6); // Purple
  static const Color statusInterview = Color(0xFFF59E0B); // Amber
  static const Color statusTechnical = Color(0xFFEC4899); // Pink
  static const Color statusOffer = Color(0xFF10B981); // Emerald Green
  static const Color statusAccepted = Color(0xFF059669); // Dark Green
  static const Color statusRejected = Color(0xFFEF4444); // Red
  static const Color statusWithdrawn = Color(0xFF6B7280); // Gray

  // Neutral Light
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Neutral Dark
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPLIED':
        return statusApplied;
      case 'SCREENING':
        return statusScreening;
      case 'INTERVIEW':
        return statusInterview;
      case 'TECHNICAL_INTERVIEW':
      case 'TECHNICAL':
        return statusTechnical;
      case 'OFFER':
        return statusOffer;
      case 'ACCEPTED':
        return statusAccepted;
      case 'REJECTED':
        return statusRejected;
      case 'WITHDRAWN':
        return statusWithdrawn;
      default:
        return primary;
    }
  }
}
