import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState());

  Future<void> selectIndex(int index) async {
    emit(state.copyWith(currentIndex: index));
  }
}
