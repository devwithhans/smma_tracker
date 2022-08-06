part of 'settings_bloc.dart';

enum status { loading, succes, failed }

class SettingsState extends Equatable {
  const SettingsState({
    this.countryCode = 'en',
    this.watchUserId,
  });

  final String countryCode;
  final String? watchUserId;

  SettingsState copyWith({
    String? countryCode,
    String? watchUserId,
  }) {
    return SettingsState(
      countryCode: countryCode ?? this.countryCode,
      watchUserId: watchUserId ?? this.watchUserId,
    );
  }

  @override
  List<Object> get props => [];
}
