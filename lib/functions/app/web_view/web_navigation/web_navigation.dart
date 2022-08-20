import 'package:agency_time/functions/app/blocs/navigation_cubit/navigation_cubit.dart';
import 'package:agency_time/functions/app/blocs/settings_bloc/settings_bloc.dart';
import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/app/web_view/web_navigation/sections/web_clients_side_view.dart';
import 'package:agency_time/functions/app/web_view/web_navigation/sections/web_side_menu.dart';
import 'package:agency_time/functions/app/web_view/web_navigation/web_screens.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/tracking/blocs/timer_bloc/ticker.dart';
import 'package:agency_time/functions/tracking/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/app/repos/settings_repo.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebNavigation extends StatelessWidget {
  const WebNavigation({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocProvider(
      create: (context) => ClientsBloc(
          clientsRepo: context.read<ClientsRepo>(),
          company: context.read<AuthCubit>().state.company!),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(
              create: (context) => TimerBloc(
                  context.read<AuthCubit>().state.appUser!.companyId,
                  ticker: const Ticker(),
                  trackerRepository: context.read<TrackerRepo>(),
                  clientsBloc: context.read<ClientsBloc>())),
          BlocProvider(
              create: (context) => SettingsBloc(context.read<SettingsRepo>())),
          BlocProvider(
              create: (context) => StatsBloc(context.read<SettingsRepo>(),
                  context.read<AuthCubit>().state.company!)),
        ],
        child: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return Scaffold(
              body: Row(
                children: [
                  const WebSideMenu(),
                  Expanded(
                    flex: 8,
                    child: webScreens[state.currentIndex].page,
                  ),
                  WebClientsSideView(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
