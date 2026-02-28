import 'package:flutter/material.dart';

Widget CategoryItem(String title, VoidCallback onDelete) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
        GestureDetector(
          onTap: onDelete,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delete, color: Colors.red, size: 18),
          ),
        ),
      ],
    ),
  );
}
