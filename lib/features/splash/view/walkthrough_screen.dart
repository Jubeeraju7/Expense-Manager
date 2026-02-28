import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/auth/view/login_screen.dart';
import 'package:proactive_expense_manager/features/splash/bloc/walkthrough_bloc.dart';
import 'package:proactive_expense_manager/features/splash/bloc/walkthrough_event.dart';
import 'package:proactive_expense_manager/features/splash/bloc/walkthrough_state.dart';


class WalkthroughScreen extends StatelessWidget {
  final PageController controller = PageController();

  WalkthroughScreen({super.key});

  final List<Map<String, String>> data = [
    {
      "title": "Privacy by Default, With Zero Ads or Hidden Tracking",
      "desc": "No ads. No trackers. No third-party analytics.",
      "image": "assets/onboarding.png",
    },
    {
      "title": "Insights That Help You Spend Better Without Complexity",
      "desc": "See category-wise spending, recent activity.",
      "image": "assets/onboarding.png",
    },
    {
      "title": "Local-First Tracking That Stays Fully On Your Device",
      "desc": "Your finances stay on your phone.",
      "image": "assets/onboarding.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalkthroughBloc(totalPages: data.length),
      child: BlocConsumer<WalkthroughBloc, WalkthroughState>(
        listener: (context, state) {
          controller.jumpToPage(state.currentPage);
        },
        builder: (context, state) {
          final currentPage = state.currentPage;

          return Scaffold(
            body: PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(data[index]['image']!, fit: BoxFit.cover),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black, Colors.transparent],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              data.length,
                              (i) => Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: currentPage == i ? Colors.white : Colors.white38,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            data[index]['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data[index]['desc']!,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          index == 0
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF312ECB),
                                    minimumSize: const Size(double.infinity, 50),
                                  ),
                                  onPressed: () => context.read<WalkthroughBloc>().add(NextPageEvent()),
                                  child: const Text(
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                                        onPressed: () => context.read<WalkthroughBloc>().add(PreviousPageEvent()),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF312ECB),
                                          minimumSize: const Size(double.infinity, 50),
                                        ),
                                        onPressed: () {


                                          
                                          if (currentPage == data.length - 1) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (_) => LoginScreen()),
                                            );
                                          } else {
                                            context.read<WalkthroughBloc>().add(NextPageEvent());
                                          }
                                        },
                                        child: Text(
                                          currentPage == data.length - 1 ? "Get Started" : "Next",
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}