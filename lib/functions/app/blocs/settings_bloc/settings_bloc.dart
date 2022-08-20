import 'package:agency_time/functions/app/repos/settings_repo.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepo _settingsRepo;

  SettingsBloc(this._settingsRepo) : super(SettingsState()) {}
}
