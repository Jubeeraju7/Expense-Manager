import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phone;
  const SendOtpEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  const VerifyOtpEvent(this.otp);

  @override
  List<Object?> get props => [otp];
}

class NicknameChanged extends AuthEvent {
  final String nickname;
  const NicknameChanged(this.nickname);

  @override
  List<Object?> get props => [nickname];
}

class SubmitNickname extends AuthEvent {
  const SubmitNickname();
}