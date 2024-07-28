import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/onboard_model.dart';

part 'onboard_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  OnboardCubit(this.onBoardPageItems) : super(const OnboardStatus(0));

  final List<OnBoardModel> onBoardPageItems;

  int selectedPage = 0;

  void pageIndexControl(int value) {
    _changePage(value);
  }

  bool isLastPage() {
    return onBoardPageItems.length - 1 == selectedPage;
  }

  void _changePage(int v) {
    selectedPage = v;

    emit(OnboardStatus(selectedPage));
  }
}
