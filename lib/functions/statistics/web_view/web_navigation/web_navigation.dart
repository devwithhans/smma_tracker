import 'dart:ui';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/statistics/blocs/navigation_cubit/navigation_cubit.dart';
import 'package:agency_time/functions/statistics/blocs/settings_bloc/settings_bloc.dart';
import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/statistics/web_view/web_navigation/sections/web_side_menu.dart';
import 'package:agency_time/functions/statistics/web_view/web_navigation/web_screens.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/statistics/repos/settings_repo.dart';
import 'package:agency_time/functions/tracking/models/tag.dart';
import 'package:agency_time/functions/tracking/views/finish_tracking/finish_tracking_view.dart';
import 'package:agency_time/logic/authorization/auth_cubit/authorization_cubit.dart';
import 'package:agency_time/logic/timer/repositories/timer_repo.dart';
import 'package:agency_time/logic/timer/repositories/ticker.dart';
import 'package:agency_time/logic/timer/timer_bloc/timer_bloc.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/views/payment_view/web/web_checkout_overlap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

class WebNavigation extends StatelessWidget {
  const WebNavigation({this.hasActiveSubscription = true, Key? key})
      : super(key: key);

  final bool hasActiveSubscription;

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocProvider(
      create: (context) => ClientsBloc(
          clientsRepo: context.read<ClientsRepo>(),
          company: context.read<AuthorizationCubit>().state.company!),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationCubit()),
          // BlocProvider(
          //     create: (context) => TimerBloc(
          //         context.read<AuthCubit>().state.appUser!.companyId,
          //         ticker: const Ticker(),
          //         trackerRepository: context.read<TrackerRepo>(),
          //         clientsBloc: context.read<ClientsBloc>())),
          BlocProvider(
            create: (context) => TimerBloc(
              stopWatchRepository: context.read<TimerRepository>(),
              ticker: const Ticker(),
              clientsBloc: context.read<ClientsBloc>(),
            ),
          ),
          BlocProvider(
              create: (context) => SettingsBloc(context.read<SettingsRepo>())),
          BlocProvider(
              create: (context) => StatsBloc(context.read<SettingsRepo>(),
                  context.read<AuthorizationCubit>().state.company!)),
        ],
        child: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  Row(
                    children: [
                      const WebSideMenu(),
                      Expanded(
                        flex: 8,
                        child: webScreens[state.currentIndex].page,
                      ),
                    ],
                  ),
                  BlocBuilder<TimerBloc, StopWatchState>(
                    builder: (context, state) {
                      if (state.client != null) {
                        Client client = state.client!;
                        return Positioned(
                          right: 0,
                          bottom: 60,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                                color: kColorGreen,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tracking  ${client.name}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      printDuration(
                                          Duration(seconds: state.duration)),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30),
                                InkWell(
                                  onTap: () {
                                    SideSheet.right(
                                        width: 500,
                                        body: FinishTrackingDialog(
                                          onDelete: () {
                                            // context
                                            //     .read<TrackerRepo>()
                                            //     .deleteTracking(
                                            //         trackingDocId: state
                                            //             .trackingDocumentId!);
                                          },
                                          onSave:
                                              (Tag? newTag, Duration duration) {
                                            context.read<TimerBloc>().add(
                                                  StopTimer(
                                                    duration: duration,
                                                    newTag: newTag,
                                                  ),
                                                );
                                          },
                                          client: client,
                                          duration:
                                              Duration(seconds: state.duration),
                                          tags: context
                                              .read<ClientsRepo>()
                                              .getTags(),
                                        ),
                                        context: context);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.stop_rounded,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  hasActiveSubscription
                      ? const SizedBox()
                      : const WebCheckoutOverlap(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
