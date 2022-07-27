import 'package:agency_time/models/tag.dart';
import 'package:agency_time/models/tracking.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_tracking_state.dart';

class UpdateTrackingCubit extends Cubit<UpdateTrackingState> {
  TrackerRepository _trackerRepository;

  UpdateTrackingCubit(this._trackerRepository) : super(UpdateTrackingInitial());

  Future<void> updateTracking(
      Tracking originalTracking, Duration? duration, Tag? tag) async {
    emit(UpdateTrackingLoading());
    print(tag);
    print(duration);

    try {
      await _trackerRepository.updateTracking(
        // start: originalTracking.start,
        duration: duration,
        // originalDuration: originalTracking.duration,
        trackingDocId: originalTracking.id,
        // clientId: originalTracking.clientId,
        tag: tag != null ? tag.id : null,
      );
    } catch (e) {
      print(e);
      emit(UpdateTrackingFailed());
    }
    emit(UpdateTrackingSucces());
  }
}
