import 'package:agency_time/functions/clients/views/client_list_view/clients_view.dart';
import 'package:agency_time/functions/tracking/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/utils/widgets/timer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebClientsSideView extends StatelessWidget {
  const WebClientsSideView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: 400,
      child: Stack(
        children: [
          const ClientsView(),
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              if (state is TimerRunning) {
                if (state.timerStatus == TimerStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: TimerBox(
                    timerState: state,
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
