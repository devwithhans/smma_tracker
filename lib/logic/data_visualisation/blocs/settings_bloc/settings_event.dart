part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SetLocale extends SettingsEvent {
  final String countryCode;
  SetLocale(this.countryCode);
}
