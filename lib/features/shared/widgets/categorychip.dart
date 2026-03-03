import 'package:flutter/material.dart';

Widget categoryChip(String title, bool selected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? Color(0xff312ECB80).withOpacity(.5)
            : const Color(0xFF2A2A2C),
        borderRadius: BorderRadius.circular(8),
        border: selected ? null : Border.all(color: Colors.white12),
      ),
      child: Text(
        title,
        style: TextStyle(color: selected ? Colors.white : Colors.white70),
      ),
    ),
  );
}
