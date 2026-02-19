import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart'; // عدلي المسار إذا مختلف

class LevelTopBar extends StatelessWidget {
  final String userId;
  final String levelTitle;
  final VoidCallback onBack;

  const LevelTopBar({
    super.key,
    required this.userId,
    required this.levelTitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          // ⬅️ 1) زر الرجوع (أول عنصر = يمين الشاشة في RTL)
          _CircleIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),

          // 📝 2) اسم المستوى بالنص
          Expanded(
            child: Center(
              child: Text(
                levelTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // ⭐ 3) عداد النقاط (آخر عنصر = يسار الشاشة)
          StreamBuilder<DocumentSnapshot>(
            stream: auth.userStream(userId: userId),
            builder: (context, snapshot) {
              final data = snapshot.data?.data() as Map<String, dynamic>?;
              final points = (data?['points'] ?? 0) as int;
              return _PointsChip(points: points);
            },
          ),
        ],
      ),
    );
  }
}

/* ================== Helpers ================== */

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: 18),
      ),
    );
  }
}

class _PointsChip extends StatelessWidget {
  final int points;

  const _PointsChip({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            points.toString(),
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.stars_rounded,
            size: 18,
            color: Color(0xFF8E5CCB),
          ),
        ],
      ),
    );
  }
}
