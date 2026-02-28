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
  final dynamic name;

  const HomePage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(HomeRepository())..add(LoadTransactionsEvent()),
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "profile",
              mini: true,
              backgroundColor: Colors.grey.shade800,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileSettingsScreen(name: name),
                  ),
                );
              },
              child: const Icon(Icons.person),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: "add",
              backgroundColor: Colors.green,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const AddTransactionSheet(),
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome,$name !",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: "Total Income",
                        amount: "₹90,000",
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SummaryCard(
                        title: "Total Expense",
                        amount: "₹36,345",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Monthly Limit",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  "70000/10000",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey.shade800,
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                const Text(
                  "27 Remaninig ",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Recent Transactions",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HomeLoaded) {
                        if (state.transactions.isEmpty) {
                          return const Center(
                            child: Text(
                              "No transactions found",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: state.transactions.length,
                            itemBuilder: (context, index) {
                              return TransactionTile(
                                tx: state.transactions[index],
                              );
                            },
                          ),
                        );
                      } else if (state is HomeError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
