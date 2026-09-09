import 'package:flutter/material.dart';

class AppColors {
  // Google Stitch Base Obsidian & Slate Canvas
  static const Color backgroundDark = Color(0xFF0B1326);
  static const Color surfaceDark = Color(0xFF171F33);
  static const Color surfaceElevated = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF131B2E);
  static const Color borderDark = Color(0x1FFFFFFF); // 12% white subtle glass border

  // Light Canvas (Fallback)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Core Brand Tokens (Stitch Routine Flow Identity)
  static const Color primary = Color(0xFF38BDF8); // Electric Sky
  static const Color primaryLight = Color(0xFF8ED5FF);
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color primaryContainer = Color(0x2638BDF8); // 15% Cyan

  static const Color secondary = Color(0xFF6366F1); // Vibrant Violet
  static const Color secondaryLight = Color(0xFFC0C1FF);
  static const Color secondaryContainer = Color(0x266366F1); // 15% Violet

  // Category & Functional Accents
  static const Color university = Color(0xFF38BDF8); // Academic Lecture Blue
  static const Color universityContainer = Color(0x2638BDF8);

  static const Color study = Color(0xFF10B981); // Emerald Momentum
  static const Color studyContainer = Color(0x2610B981);

  static const Color freeTime = Color(0xFF10B981); // Free-Time Slot Green
  static const Color freeTimeContainer = Color(0x2610B981);

  static const Color task = Color(0xFF6366F1); // Study Task Violet
  static const Color exam = Color(0xFFF59E0B); // Exam Amber

  static const Color personal = Color(0xFFEC4899); // Habit / Personal Pink
  static const Color personalLight = Color(0xFFF472B6);
  static const Color personalContainer = Color(0x26EC4899);

  // Semantic Alerts & Conflict Detection
  static const Color warning = Color(0xFFF59E0B); // Amber Overlap Alert
  static const Color warningContainer = Color(0x26F59E0B);

  static const Color conflict = Color(0xFFF43F5E); // Rose Conflict
  static const Color conflictContainer = Color(0x26F43F5E);

  static const Color error = Color(0xFFF43F5E); // Rose Error
  static const Color errorContainer = Color(0x26F43F5E);

  static const Color success = Color(0xFF10B981); // Checkmark Green
  static const Color successContainer = Color(0x2610B981);

  static const Color ongoing = Color(0xFF38BDF8); // Ongoing Activity Sky Blue
  static const Color ongoingContainer = Color(0x2638BDF8);

  // Typography Colors
  static const Color textPrimaryDark = Color(0xFFDAE2FD);
  static const Color textSecondaryDark = Color(0xFFBDC8D1);
  static const Color textMutedDark = Color(0xFF87929A);

  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);
}
