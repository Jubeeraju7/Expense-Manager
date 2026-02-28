import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/core/utils/shared_perferences.dart';
import 'package:proactive_expense_manager/features/auth/bloc/auth_event.dart';
import 'package:proactive_expense_manager/features/auth/bloc/auth_state.dart';
import 'package:proactive_expense_manager/features/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  String _apiOtp = '';
  bool _userExists = false;
  String _phone = '';
  String? _token;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      _phone = event.phone;
      try {
        final data = await repository.sendOtp(event.phone);
        _apiOtp = data['otp']?.toString() ?? '';
        _userExists = data['user_exists'] ?? false;
        _token = data['token'];
        await SharedPreferencesDataProvider().saveAccessToken(_token ?? '');
        emit(
          OtpSent(
            otp: _apiOtp,
            userExists: _userExists,
            token: _token,
            nickname: data['nickname'],
          ),
        );
      } catch (e) {
        emit(AuthError("Failed to send OTP: $e"));
      }
    });
    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      if (event.otp == _apiOtp) {
        if (_userExists) {
          await SharedPreferencesDataProvider().saveAccessToken(_token ?? '');
          emit(AuthSuccess(token: _token ?? ''));
        } else {
          emit(AuthOnboardingRequired(phone: _phone));
        }
      } else {
        emit(AuthError("Invalid OTP"));
      }
    });

    // NICKNAME CHANGE
    on<NicknameChanged>((event, emit) {
      emit(OnboardingState(nickname: event.nickname));
    });

    // SUBMIT NICKNAME → CREATE ACCOUNT
    on<SubmitNickname>((event, emit) async {
      final currentState = state;
      String nickname = '';
      if (currentState is OnboardingState)
        nickname = currentState.nickname.trim();

      if (nickname.isEmpty) {
        emit(OnboardingFailure("Please enter a nickname"));
        return;
      }

      emit(OnboardingLoading());
      try {
        final response = await repository.createAccount(
          phone: _phone,
          nickname: nickname,
        );

        if (response['status'] == 'success' && response['token'] != null) {
          _token = response['token'];
          await SharedPreferencesDataProvider().saveAccessToken(_token ?? '');
          emit(AuthSuccess(token: _token!));
        } else {
          emit(OnboardingFailure("Failed to create account"));
        }
      } catch (e) {
        emit(OnboardingFailure("Something went wrong: $e"));
      }
    });
  }
}
