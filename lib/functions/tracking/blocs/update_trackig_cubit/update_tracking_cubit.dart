import 'package:agency_time/functions/tracking/models/tracking.dart';
import 'package:agency_time/main.dart';

import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'update_tracking_state.dart';

class UpdateTrackingCubit extends Cubit<UpdateTrackingState> {
  TrackerRepo _trackerRepository;

  UpdateTrackingCubit(this._trackerRepository) : super(UpdateTrackingInitial());

  Future<void> updateTracking(
      Tracking originalTracking, Duration? duration, int? tag) async {
    emit(UpdateTrackingLoading());
    try {
      await _trackerRepository.updateTracker(
        duration: duration,
        trackingDocId: originalTracking.id,
        tag: tag,
      );
    } catch (e) {
      print(e);
      emit(UpdateTrackingFailed());
    }
    emit(UpdateTrackingSucces());
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
  }

  Future<void> deleteTracking(
    String trackingId,
  ) async {
    emit(UpdateTrackingLoading());
    await _trackerRepository.deleteTracking(trackingDocId: trackingId);
    emit(UpdateTrackingSucces());
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
  }
}
