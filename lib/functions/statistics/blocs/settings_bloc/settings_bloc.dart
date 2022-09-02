import 'package:agency_time/functions/statistics/repos/settings_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepo _settingsRepo;

  SettingsBloc(this._settingsRepo) : super(SettingsState()) {}
}
