part of 'update_tracking_cubit.dart';

abstract class UpdateTrackingState extends Equatable {
  const UpdateTrackingState();

  @override
  List<Object> get props => [];
}

class UpdateTrackingInitial extends UpdateTrackingState {}

class UpdateTrackingLoading extends UpdateTrackingState {}

class UpdateTrackingSucces extends UpdateTrackingState {}

class UpdateTrackingFailed extends UpdateTrackingState {}
