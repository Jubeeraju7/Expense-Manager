import 'package:equatable/equatable.dart';

class WalkthroughState extends Equatable {
  final int currentPage;
  const WalkthroughState({this.currentPage = 0});

  WalkthroughState copyWith({int? currentPage}) {
    return WalkthroughState(currentPage: currentPage ?? this.currentPage);
  }

  @override
  List<Object?> get props => [currentPage];
}