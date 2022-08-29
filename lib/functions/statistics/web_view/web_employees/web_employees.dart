import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/statistics/models/company_month.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/user_stat_profile_view.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:agency_time/utils/widgets/custom_searchfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

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
      body: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          searchResult = state.selectedMonth.employees
              .where((element) =>
                  '${element.member.firstName} ${element.member.lastName} '
                      .toLowerCase()
                      .contains(searchParameter.toLowerCase()))
              .toList();
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
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
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Total tracking',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Last tracking',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(height: 0),
              Column(
                children: searchResult.map((e) {
                  return Column(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          SideSheet.right(
                            width: 800,
                            context: context,
                            body: BlocProvider.value(
                                value: context.read<ClientsBloc>(),
                                child:
                                    UserStatProfile(employee: e, state: state)),
                          );
                        },
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${e.member.firstName} ${e.member.lastName}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  printDuration(e.totalDuration),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('EEE, dd MMM HH:MM ')
                                      .format(e.lastActivity!),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 0),
                    ],
                  );

                  // StaggeredGridTile.count(
                  //   crossAxisCellCount: 2,
                  //   mainAxisCellCount: 2,
                  //   child: WebUserCard(
                  //     statState: state,
                  //     e: e,
                  //   ),
                  // );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
