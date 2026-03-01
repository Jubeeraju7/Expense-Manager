import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:proactive_expense_manager/features/auth/bloc/auth_event.dart';
import 'package:proactive_expense_manager/features/auth/bloc/auth_state.dart';
import 'package:proactive_expense_manager/features/home/view/home_screen.dart';
import 'package:proactive_expense_manager/features/auth/view/onboarding_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phone;

  const VerifyOtpScreen({super.key, required this.phone});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  int secondsRemaining = 32;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();

    final state = context.read<AuthBloc>().state;
    if (state is OtpSent && state.otp.length == 6) {
      for (int i = 0; i < 6; i++) {
        controllers[i].text = state.otp[i];
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  String maskPhone(String phone) {
    if (phone.length < 10) return phone;
    return "${phone.substring(0, 4)}****${phone.substring(phone.length - 2)}";
  }

  Widget otpBox(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  void submitOtp() {
    final otp = getOtp();
    context.read<AuthBloc>().add(VerifyOtpEvent(otp));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
          if (state.otp.length == 6) {
            for (int i = 0; i < 6; i++) {
              controllers[i].text = state.otp[i];
            }
          }
        } else if (state is AuthSuccess) {
          print("nickname : ${state.nickname}");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(name: state.nickname ?? ''),
            ),
          );
        } else if (state is AuthOnboardingRequired) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OnboardingScreen(phone: state.phone),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Verify OTP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter the 6-Digit code sent to ${maskPhone(widget.phone)}",
                    style: const TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) => otpBox(index)),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B37D0),
                      ),
                      onPressed: isLoading ? null : submitOtp,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Verify",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: secondsRemaining == 0
                        ? () {
                            context.read<AuthBloc>().add(
                              SendOtpEvent(widget.phone),
                            );
                            setState(() {
                              secondsRemaining = 32;
                            });
                            startTimer();
                          }
                        : null,
                    child: Text(
                      secondsRemaining > 0
                          ? "Resend OTP in ${secondsRemaining}s"
                          : "Resend OTP",
                      style: TextStyle(
                        color: secondsRemaining > 0
                            ? Colors.white38
                            : Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
