import 'package:equatable/equatable.dart';

abstract class WalkthroughEvent extends Equatable {
  const WalkthroughEvent();

  @override
  List<Object?> get props => [];
}

class NextPageEvent extends WalkthroughEvent {}

class PreviousPageEvent extends WalkthroughEvent {}

class JumpToPageEvent extends WalkthroughEvent {
  final int index;
  const JumpToPageEvent(this.index);

  @override
  List<Object?> get props => [index];
}