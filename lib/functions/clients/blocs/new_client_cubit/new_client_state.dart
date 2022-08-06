part of 'new_client_cubit.dart';

enum Status { loading, initial, succes, failed }

class NewClientState extends Equatable {
  const NewClientState({
    this.hourly_rate_target,
    this.mrr,
    this.name,
    this.status = Status.initial,
  });

  final Status status;
  final String? name;
  final double? mrr;
  final double? hourly_rate_target;

  NewClientState copyWith({
    String? name,
    double? mrr,
    double? hourly_rate_target,
    Status? status,
  }) {
    return NewClientState(
      status: status ?? this.status,
      name: name ?? this.name,
      mrr: mrr ?? this.mrr,
      hourly_rate_target: hourly_rate_target ?? this.hourly_rate_target,
    );
  }

  @override
  List get props => [mrr, hourly_rate_target, name];
}
