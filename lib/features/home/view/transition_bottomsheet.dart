import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_bloc.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_event.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_state.dart';
import 'package:proactive_expense_manager/features/home/repository/home_repository.dart';
import 'package:proactive_expense_manager/features/shared/widgets/categorychip.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String? selectedCategoryId;
  bool isExpense = true;

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rootContext = context;

    return BlocProvider(
      create: (context) => HomeBloc(HomeRepository())..add(FetchCategories()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is TransactionSaving) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is TransactionSaved) {
            Navigator.pop(context);
            Navigator.pop(context, true);
          }

          if (state is TransactionSaveError) {
            Navigator.pop(context);

            ScaffoldMessenger.of(
              rootContext,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Add Transaction",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              "Close",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// EXPENSE / INCOME SWITCH
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isExpense = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isExpense
                                        ? Colors.green
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Expense",
                                    style: TextStyle(
                                      color: isExpense
                                          ? Colors.white
                                          : Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isExpense = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !isExpense
                                        ? Colors.green
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Income",
                                    style: TextStyle(
                                      color: !isExpense
                                          ? Colors.white
                                          : Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// TITLE
                      TextFormField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Title",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF2A2A2C),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter title";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      /// AMOUNT
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Amount ( ₹ )",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF2A2A2C),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter amount";
                          }

                          if (double.tryParse(value) == null) {
                            return "Enter valid amount";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "CATEGORY",
                        style: TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 10),

                      /// CATEGORY LIST
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state is CategoryLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is CategoryLoaded) {
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: state.categories.map((category) {
                                final isSelected =
                                    selectedCategoryId == category.categoryid;

                                return categoryChip(
                                  category.name,
                                  isSelected,
                                  () {
                                    setState(() {
                                      selectedCategoryId = category.categoryid;
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          }

                          return const SizedBox();
                        },
                      ),

                      const SizedBox(height: 25),

                      /// SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B37D0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            if (selectedCategoryId == null) {
                              ScaffoldMessenger.of(
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select category"),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            context.read<HomeBloc>().add(
                              SaveTransactionEvent(
                                title: titleController.text.trim(),
                                amount: double.parse(
                                  amountController.text.trim(),
                                ),
                                isExpense: isExpense,
                                categoryId: selectedCategoryId!,
                              ),
                            );
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
