import 'package:agency_time/functions/app/repos/settings_repo.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final storage = FlutterSecureStorage();
  final SettingsRepo _settingsRepo;

  SettingsBloc(this._settingsRepo) : super(SettingsState()) {
    _getSettings();
    on<SetLocale>(_setLocale);
  }

  Future<void> _setLocale(SetLocale event, Emitter emit) async {
    await _settingsRepo.setCountryCodeInCompanyDoc(event.countryCode);
    emit(state.copyWith(countryCode: event.countryCode));
  }

  void _getSettings() async {
    String? countryCode = _settingsRepo.getCountryCodeFromCompanyDoc();
    emit(state.copyWith(countryCode: countryCode ?? 'en'));
  }
}
