import 'package:flutter/material.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/auth/repository/auth_repository.dart';
import 'package:proactive_expense_manager/features/splash/view/splash_screen.dart';
import 'package:proactive_expense_manager/features/profile/bloc/profile_bloc.dart';
import 'package:proactive_expense_manager/features/profile/repository/profile_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => AuthRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),
          BlocProvider(create: (context) => ProfileBloc(ProfileRepository())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
