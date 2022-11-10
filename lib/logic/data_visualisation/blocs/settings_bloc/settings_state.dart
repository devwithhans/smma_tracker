part of 'settings_bloc.dart';

enum status { loading, succes, failed }

class SettingsState extends Equatable {
  const SettingsState({
    this.watchUserId,
  });

  final String? watchUserId;

  SettingsState copyWith({
    String? watchUserId,
  }) {
    return SettingsState(
      watchUserId: watchUserId ?? this.watchUserId,
    );
  }

  @override
  List<Object> get props => [];
}
