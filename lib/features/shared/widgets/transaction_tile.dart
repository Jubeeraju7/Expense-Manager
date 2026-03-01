import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_bloc.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_event.dart';

class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;

  const TransactionTile({super.key, required this.tx});

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('d MMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = tx['type'] ?? "debit"; 
    final amount = tx['amount'] ?? 0;
    final category = tx['category'] ?? "Unknown";
    final note = tx['note'] ?? "Unknown";
    final timestamp = tx['timestamp'] ?? "";
    final id = tx['id'] ?? "";

    final sign = type == "credit" ? "+" : "-";
    final color = type == "credit" ? Colors.green : Colors.red;

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
          // Left side: Note and Category
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          // Right side: Date, Amount and Delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatDate(timestamp),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$sign ₹$amount",
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Confirm deletion
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.grey.shade900,
                          title: const Text(
                            "Delete Transaction?",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            "Are you sure you want to delete this transaction?",
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel",
                              style: TextStyle(color: Colors.white),),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              
                                context.read<HomeBloc>().add(
                                      DeleteTransactionEvent([id]),
                                    );
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}