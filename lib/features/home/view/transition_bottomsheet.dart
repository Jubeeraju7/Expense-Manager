import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_bloc.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_event.dart';
import 'package:proactive_expense_manager/features/home/bloc/home_state.dart';
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
  void initState() {
    super.initState();
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(FetchCategories());
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    return SafeArea(
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
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isExpense = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                  const SizedBox(height: 20),
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
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? "Please enter title"
                        : null,
                  ),
                  const SizedBox(height: 15),
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
                      if (value == null || value.trim().isEmpty)
                        return "Please enter amount";
                      if (double.tryParse(value) == null)
                        return "Enter valid amount";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("CATEGORY", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoaded) {
                        if (state.categories.isEmpty)
                          return const Text("No categories");
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: state.categories.map((category) {
                            final isSelected =
                                selectedCategoryId == category.categoryid;
                            return categoryChip(category.name, isSelected, () {
                              setState(
                                () => selectedCategoryId = category.categoryid,
                              );
                            });
                          }).toList(),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(height: 20),
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
                        if (!_formKey.currentState!.validate()) return;
                        if (selectedCategoryId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select category"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        homeBloc.add(
                          SaveTransactionEvent(
                            title: titleController.text.trim(),
                            amount: double.parse(amountController.text.trim()),
                            isExpense: isExpense,
                            categoryId: selectedCategoryId!,
                          ),
                        );
                       Navigator.pop(context, true); 
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
    );
  }
}
