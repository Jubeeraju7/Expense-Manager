import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_bloc.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_event.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_state.dart';
import 'package:proactive_expense_manager/features/home/repository/home_repository.dart';
import 'package:proactive_expense_manager/features/home/view/transition_bottomsheet.dart';
import 'package:proactive_expense_manager/features/profile/view/profile.dart';
import 'package:proactive_expense_manager/features/shared/widgets/summary_card.dart';
import 'package:proactive_expense_manager/features/shared/widgets/transaction_tile.dart';

class HomePage extends StatelessWidget {
  final String name;

  const HomePage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(HomeRepository())..add(LoadTransactionsEvent()),
      child: Scaffold(
        backgroundColor: Colors.black,

        /// FLOATING BUTTONS
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            /// PROFILE BUTTON
            FloatingActionButton(
              heroTag: "profile",
              mini: true,
              backgroundColor: Colors.grey.shade800,
              child: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileSettingsScreen(name: name),
                  ),
                );
              },
            ),

            const SizedBox(width: 10),

            /// ADD TRANSACTION BUTTON
            FloatingActionButton(
              heroTag: "add",
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
              onPressed: () async {

                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const AddTransactionSheet(),
                );

                if (!context.mounted) return;

                /// REFRESH TRANSACTIONS AFTER ADD
                if (result == true) {
                  context.read<HomeBloc>().add(LoadTransactionsEvent());

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Transaction added successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        ),

        /// BODY
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {

                /// LOADING STATE
                if (state is HomeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                /// ERROR STATE
                if (state is HomeError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                /// SUCCESS STATE
                if (state is HomeLoaded) {

                  double totalIncome = 0;
                  double totalExpense = 0;

                  /// CALCULATE TOTALS
                  for (var tx in state.transactions) {

                    final amount =
                        double.tryParse(tx['amount'].toString()) ?? 0;

                    if (tx['type'] == "credit") {
                      totalIncome += amount;
                    } else {
                      totalExpense += amount;
                    }
                  }

                  /// MONTHLY LIMIT
                  const double monthlyLimit = 10000;

                  double progress = totalExpense / monthlyLimit;
                  if (progress > 1) progress = 1;

                  double remaining = monthlyLimit - totalExpense;
                  if (remaining < 0) remaining = 0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// USER NAME
                      Text(
                        "Welcome, ${name.isNotEmpty ? name : "User"}!",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// SUMMARY CARDS
                      Row(
                        children: [

                          Expanded(
                            child: SummaryCard(
                              title: "Total Income",
                              amount: "₹${totalIncome.toStringAsFixed(2)}",
                              color: Colors.green,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: SummaryCard(
                              title: "Total Expense",
                              amount: "₹${totalExpense.toStringAsFixed(2)}",
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// MONTHLY LIMIT
                      const Text(
                        "Monthly Limit",
                        style: TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "₹${totalExpense.toStringAsFixed(0)} / ₹$monthlyLimit",
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 12),

                      /// PROGRESS BAR
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.green,
                        minHeight: 8,
                      ),

                      const SizedBox(height: 10),

                      /// REMAINING AMOUNT
                      Text(
                        "₹${remaining.toStringAsFixed(0)} Remaining",
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      /// TRANSACTION TITLE
                      const Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// TRANSACTION LIST
                      if (state.transactions.isEmpty)
                        const Expanded(
                          child: Center(
                            child: Text(
                              "No transactions found",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.transactions.length,
                            itemBuilder: (context, index) {

                              final tx = state.transactions[index];

                              return TransactionTile(
                                tx: tx,
                              );
                            },
                          ),
                        ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}