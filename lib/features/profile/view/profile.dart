import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/auth/view/login_screen.dart';
import 'package:proactive_expense_manager/features/profile/bloc/profile_bloc.dart';
import 'package:proactive_expense_manager/features/profile/bloc/profile_event.dart';
import 'package:proactive_expense_manager/features/profile/bloc/profile_state.dart';
import 'package:proactive_expense_manager/features/shared/widgets/category_item.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String name;

  const ProfileSettingsScreen({super.key, required this.name});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(FetchCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Text(
                "Profile & Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "NICKNAME",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: _boxDecoration(),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        nickname();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "ALERT LIMIT (₹)",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: _boxDecoration(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Amount (₹)",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C5CFF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          onPressed: () {},

                          child: const Text(
                            "Set",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Current Limit: ₹1,000",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "CATEGORIES",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: _boxDecoration(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: categoryController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "New category name",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        GestureDetector(
                          onTap: () {
                            final name = categoryController.text.trim();

                            if (name.isNotEmpty) {
                              context.read<ProfileBloc>().add(
                                AddCategoryEvent(name),
                              );

                              categoryController.clear();
                            }
                          },

                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xFF5C5CFF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is CategoryLoaded) {
                          return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: state.categories.map((category) {
                              return CategoryItem(category.name, () {
                                print("Deleting category id: ${category.categoryid}");
                                context.read<ProfileBloc>().add(
                                  DeleteCategoryEvent([category.categoryid]),
                                );
                                
                              });
                            }).toList(),
                          );
                        }

                        return const SizedBox();
                      },
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "CLOUD SYNC",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C5CFF),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Row(
                        children: const [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sync To Cloud",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  "Sync and update data to the backend",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),

                          Icon(Icons.cloud_upload, color: Colors.white),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },

                        icon: const Icon(Icons.logout, color: Colors.red),

                        label: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white10),
    );
  }

  void nickname() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "Edit Nickname",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: nicknameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter nickname",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
