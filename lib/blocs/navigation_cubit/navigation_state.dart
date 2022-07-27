part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  const NavigationState({this.currentIndex = 0});

  final int currentIndex;

  NavigationState copyWith({int? currentIndex}) {
    return NavigationState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object> get props => [currentIndex];
}
