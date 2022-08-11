import 'package:agency_time/functions/app/blocs/navigation_cubit/navigation_cubit.dart';
import 'package:agency_time/functions/app/blocs/settings_bloc/settings_bloc.dart';
import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/app/views/dashboard_view/dashboard_view.dart';
import 'package:agency_time/functions/app/views/settings_view/settings_view.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/functions/clients/views/client_list_view/clients_view.dart';
import 'package:agency_time/functions/clients/views/internal_client_list_view/internal_client_list_view.dart';
import 'package:agency_time/functions/tracking/blocs/timer_bloc/ticker.dart';
import 'package:agency_time/functions/tracking/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/functions/clients/repos/client_repo.dart';
import 'package:agency_time/functions/app/repos/settings_repo.dart';
import 'package:agency_time/functions/tracking/repos/tracker_repo.dart';

import 'package:agency_time/utils/widgets/timer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

List<Widget> widgets = [
  const DashboardView(),
  const ClientsView(),
  const InternalClientsView(),
  const SettingsView()
];

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return MultiBlocProvider(
      providers: [
        //Bloc used to keep track of the current selected screen
        BlocProvider(create: (context) => NavigationCubit()),
        //Bloc to manage the local timer, it supply data as time ticker, and clients who is beein tracked
        BlocProvider(
            create: (context) => TimerBloc(
                context.read<AuthCubit>().state.appUser!.companyId,
                ticker: Ticker(),
                trackerRepository: context.read<TrackerRepo>())),
        //Bloc used to get all clients, and their data
        BlocProvider(
            create: (context) => ClientsBloc(
                clientsRepo: context.read<ClientsRepo>(),
                company: context.read<AuthCubit>().state.company!)),

        //Bloc managing the user settings such as witch period of data should be shown, what kind and so on.
        BlocProvider(
            create: (context) => SettingsBloc(context.read<SettingsRepo>())),
        BlocProvider(
            create: (context) => StatsBloc(context.read<SettingsRepo>(),
                context.read<AuthCubit>().state.company!)),
      ],
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                widgets[state.currentIndex],
                // Expanded(child: widgets[state.currentIndex]),
                BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) {
                    if (state is TimerRunning) {
                      if (state.timerStatus == TimerStatus.loading) {
                        return Center(
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
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: state.currentIndex,
              onTap: (i) {
                context.read<NavigationCubit>().selectIndex(i);
              },
              items: [
                /// Home
                SalomonBottomBarItem(
                  icon: Icon(Icons.speed_rounded),
                  title: Text("Dashboard"),
                  selectedColor: Colors.black,
                ),

                /// Likes
                SalomonBottomBarItem(
                  icon: Icon(Icons.store_rounded),
                  title: Text("Clients"),
                  selectedColor: Colors.black,
                ),

                /// Search
                SalomonBottomBarItem(
                  icon: Icon(Icons.business_rounded),
                  title: Text("Internal"),
                  selectedColor: Colors.black,
                ),

                /// Profile
                SalomonBottomBarItem(
                  icon: Icon(Icons.person),
                  title: Text("Profile"),
                  selectedColor: Colors.teal,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
