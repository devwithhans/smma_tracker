import 'dart:ui';
import 'package:agency_time/logic/clients/repos/client_repo.dart';
import 'package:agency_time/logic/data_visualisation/blocs/navigation_cubit/navigation_cubit.dart';
import 'package:agency_time/logic/data_visualisation/blocs/settings_bloc/settings_bloc.dart';
import 'package:agency_time/logic/settings/repos/settings_repo.dart';
import 'package:agency_time/logic/timer/repositories/timer_repo.dart';
import 'package:agency_time/logic/timer/repositories/ticker.dart';
import 'package:agency_time/logic/timer/repositories/ui_helper.dart';
import 'package:agency_time/logic/timer/timer_bloc/timer_bloc.dart';
import 'package:agency_time/models/client.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/views/dialog_payment/web/web_checkout_overlap.dart';
import 'package:agency_time/views/section_navigation/web/web_screens.dart';
import 'package:agency_time/views/section_navigation/web/widgets/web_side_menu.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

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
              backgroundColor: Colors.white,
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
                  BlocBuilder<TimerBloc, TimerState>(
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
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      printDuration(
                                          Duration(seconds: state.duration)),
                                      style: const TextStyle(
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
                                    FinishTimerUIHelper.onToggleTimer(
                                      state: state,
                                      context: context,
                                      client: client,
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: const Icon(
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
