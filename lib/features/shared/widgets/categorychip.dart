import 'package:flutter/material.dart';

Widget categoryChip(String title, bool selected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: selected ? const Color(0xFF3B37D0) : const Color(0xFF2A2A2C),
      borderRadius: BorderRadius.circular(8),
      border: selected ? null : Border.all(color: Colors.white12),
    ),
    child: Text(
      title,
      style: TextStyle(color: selected ? Colors.white : Colors.white70),
    ),
  );
}
