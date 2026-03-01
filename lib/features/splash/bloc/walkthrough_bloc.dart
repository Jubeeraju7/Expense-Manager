import 'package:flutter_bloc/flutter_bloc.dart';
import 'walkthrough_event.dart';
import 'walkthrough_state.dart';

class WalkthroughBloc extends Bloc<WalkthroughEvent, WalkthroughState> {
  final int totalPages;

  WalkthroughBloc({required this.totalPages})
    : super(const WalkthroughState()) {
    on<NextPageEvent>((event, emit) {
      final nextPage = (state.currentPage + 1).clamp(0, totalPages - 1);
      emit(state.copyWith(currentPage: nextPage));
    });

    on<PreviousPageEvent>((event, emit) {
      final prevPage = (state.currentPage - 1).clamp(0, totalPages - 1);
      emit(state.copyWith(currentPage: prevPage));
    });
  }
}
