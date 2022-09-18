part of 'trackings_cubit.dart';

class TrackingsState extends Equatable {
  List<Tracking>? trackings;
  bool reachedEnd;
  TrackingsState({this.trackings, this.reachedEnd = false});

  @override
  List<Object?> get props => [trackings, reachedEnd];
}

class TrackingsInitial extends TrackingsState {}

class TrackingsLoading extends TrackingsState {}

class TrackingsSucces extends TrackingsState {
  TrackingsSucces(trackings, reachedEnd)
      : super(trackings: trackings, reachedEnd: reachedEnd);
}
