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

class HomePage extends StatefulWidget {
  final String name;

  const HomePage({super.key, required this.name});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;
  late final HomeBloc _homeBloc;

  @override
  void initState()  {
    super.initState();
    _scrollController = ScrollController();
    _homeBloc = HomeBloc(HomeRepository());
     _loadData();
    
  }

  void _loadData() {
    _homeBloc.add(LoadTransactionsEvent());
    _homeBloc.add(FetchCategories());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "profile",
              mini: true,
              backgroundColor: Colors.grey.shade800,
              child: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileSettingsScreen(name: widget.name),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
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
                if (result == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Transaction added successfully"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HomeError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is HomeLoaded) {
                  double totalIncome = 0;
                  double totalExpense = 0;

                  for (var tx in state.transactions) {
                    final amount =
                        double.tryParse(tx['amount'].toString()) ?? 0;
                    if (tx['type'] == "credit") {
                      totalIncome += amount;
                    } else {
                      totalExpense += amount;
                    }
                  }

                  const double monthlyLimit = 10000;
                  double progress = totalExpense / monthlyLimit;
                  if (progress > 1) progress = 1;
                  double remaining = monthlyLimit - totalExpense;
                  if (remaining < 0) remaining = 0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, ${widget.name.isNotEmpty ? widget.name : "User"}!",
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
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.green,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "₹${remaining.toStringAsFixed(0)} Remaining",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Recent Transactions",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: state.transactions.isEmpty
                            ? const Center(
                                child: Text(
                                  "No transactions found",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: state.transactions.length,
                                itemBuilder: (context, index) {
                                  final tx = state.transactions[index];
                                  return TransactionTile(tx: tx);
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
