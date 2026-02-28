import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String otp;
  final bool userExists;
  final String? nickname;
  final String? token;

  OtpSent({required this.otp, required this.userExists, this.nickname, this.token});

  @override
  List<Object?> get props => [otp, userExists, nickname, token];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthOnboardingRequired extends AuthState {
  final String phone;
  AuthOnboardingRequired({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class AuthSuccess extends AuthState {
  final String token;
  final String? nickname; 

  AuthSuccess({required this.token, this.nickname});

  @override
  List<Object?> get props => [token, nickname ?? ''];
}

class OnboardingState extends AuthState {
  final String nickname;
  OnboardingState({this.nickname = ''});

  @override
  List<Object?> get props => [nickname];
}

class OnboardingLoading extends AuthState {}
class OnboardingFailure extends AuthState {
  final String message;
  OnboardingFailure(this.message);
}