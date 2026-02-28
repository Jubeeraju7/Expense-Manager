import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;

  const TransactionTile({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tx['title'] ?? "Unknown",
                  style: const TextStyle(color: Colors.white)),
              Text(tx['date'] ?? "", style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text("- ₹${tx['amount'] ?? 0}",
              style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}