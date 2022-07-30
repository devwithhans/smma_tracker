import 'package:agency_time/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/blocs/navigation_cubit/navigation_cubit.dart';
import 'package:agency_time/blocs/timer_bloc/ticker.dart';
import 'package:agency_time/blocs/timer_bloc/timer_bloc.dart';
import 'package:agency_time/mobile_views/client_list_view/clients_view.dart';
import 'package:agency_time/mobile_views/dashboard_view/dashboard_view.dart';
import 'package:agency_time/repos/trackerRepository.dart';
import 'package:agency_time/test_view.dart';
import 'package:agency_time/utils/widgets/timer_box.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

List<Widget> widgets = [
  DashboardView(),
  ClientsView(),
  TestingWidget(),
  Center(child: Text('4')),
];

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(
            create: (context) => TimerBloc(
                context.read<AuthCubit>().state.appUser!.companyId,
                ticker: Ticker(),
                trackerRepository: context.read<TrackerRepository>())),
        BlocProvider(
            create: (context) => ClientsBloc(
                trackerRepository: context.read<TrackerRepository>())),
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
