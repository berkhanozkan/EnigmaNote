part of 'onboard_cubit.dart';

abstract class OnboardState extends Equatable {
  const OnboardState();

  @override
  List<Object> get props => [];
}

class OnboardStatus extends OnboardState {
  final int selectedPage;

  const OnboardStatus(this.selectedPage);

  @override
  List<Object> get props => [selectedPage];
}
