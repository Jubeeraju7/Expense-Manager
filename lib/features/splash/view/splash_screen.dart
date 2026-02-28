import 'package:flutter/material.dart';
import 'package:proactive_expense_manager/core/utils/shared_perferences.dart';
import 'package:proactive_expense_manager/features/home/view/home_screen.dart';
import 'package:proactive_expense_manager/features/auth/repository/auth_repository.dart';
import 'package:proactive_expense_manager/features/splash/view/walkthrough_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SharedPreferencesDataProvider _preferences =
      SharedPreferencesDataProvider();
  late final AuthRepository repository = AuthRepository();

  @override
  void initState() {
    super.initState();
    gotoLandingPage();
  }

  void gotoLandingPage() async {
    try {
      String token = await _preferences.getAccessToken();
      print("Token: $token");
      String name = await _preferences.getUserName();

      if (token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(name: name)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WalkthroughScreen()),
        );
      }
    } catch (_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WalkthroughScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Image.asset("assets/Logo.png", width: 80)),
    );
  }
}
