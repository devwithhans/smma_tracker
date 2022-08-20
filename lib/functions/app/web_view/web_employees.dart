import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/app/models/company_month.dart';
import 'package:agency_time/functions/app/views/dashboard_view/dashboard_widgets/user_stats.dart';
import 'package:agency_time/functions/app/views/dashboard_view/user_stat_profile_view.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WebEmployees extends StatefulWidget {
  const WebEmployees({Key? key}) : super(key: key);

  @override
  State<WebEmployees> createState() => _WebEmployeesState();
}

class _WebEmployeesState extends State<WebEmployees> {
  String searchParameter = '';
  List<Employee> searchResult = [];

  @override
  Widget build(BuildContext context) {
    AppUser appUser = context.read<AuthCubit>().state.appUser!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<StatsBloc, StatsState>(
          builder: (context, state) {
            searchResult = state.selectedMonth.employees
                .where((element) =>
                    '${element.member.firstName} ${element.member.lastName} '
                        .toLowerCase()
                        .contains(searchParameter.toLowerCase()))
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Employee overview',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.add_circle),
                          splashRadius: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: CustomSearchField(
                        hintText: 'Search employees',
                        onSearch: (v) {
                          searchParameter = v;
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: searchResult.map((e) {
                    return StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: WebUserCard(
                        statState: state,
                        e: e,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WebUserCard extends StatelessWidget {
  const WebUserCard({
    required this.statState,
    required this.e,
    Key? key,
  }) : super(key: key);

  final Employee e;
  final StatsState statState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => UserStatProfile(
            state: statState,
            employee: e,
          ),
        );
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (c) => BlocProvider.value(
        //               value: context.read<ClientsBloc>(),
        //               child: UserStatProfile(
        //                 state: statState,
        //                 employee: e,
        //               ),
        //             )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: kColorGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text(
                        '${e.member.firstName} ${e.member.lastName}',
                        style: TextStyle(
                            fontSize: 15,
                            height: 1,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTrackingDisplayWidget(
                        value: e.lastActivity != null
                            ? DateFormat('d MMM, y').format(e.lastActivity!)
                            : '',
                        title: 'Last tracking',
                      ),
                      CustomTrackingDisplayWidget(
                        value: printDuration(e.clientsDuration),
                        title: 'Client hours',
                      ),
                      CustomTrackingDisplayWidget(
                        value: printDuration(e.internalDuration),
                        title: 'Internal hours',
                      ),
                      CustomTrackingDisplayWidget(
                        value: printDuration(e.totalDuration),
                        title: 'Total hours',
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
