import 'package:agency_time/functions/tracking/models/tracking.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'trackings_state.dart';

class TrackingsCubit extends Cubit<TrackingsState> {
  ClientsRepo clientsRepo;
  TrackingsCubit(this.clientsRepo) : super(TrackingsInitial());

  Future<void> fetchTrackings(String clientId) async {
    List<Tracking> trackings = [];
    int limit = 5;
    bool reachedEnd = false;

    if (state.trackings != null) {
      trackings.addAll(trackings);
    }
    int skip = trackings.length;

    emit(TrackingsLoading());

    List<Tracking> newTrackings =
        await clientsRepo.getTrackings(skip, clientId, limit);

    if (trackings.length < limit) {
      reachedEnd = true;
    }

    trackings.addAll(newTrackings);

    emit(TrackingsSucces(trackings, reachedEnd));
  }
}
