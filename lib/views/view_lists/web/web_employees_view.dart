import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/statistics/models/company_month.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/user_stat_profile_view.dart';
import 'package:agency_time/logic/clients/clients_bloc/clients_bloc.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/utils/functions/print_duration.dart';

import 'package:agency_time/views/lists_view/web/widgets/column_row.dart';
import 'package:agency_time/views/lists_view/web/widgets/column_row_clickable.dart';
import 'package:agency_time/views/lists_view/web/widgets/web_list_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_sheet/side_sheet.dart';

class WebEmployeesView extends StatefulWidget {
  const WebEmployeesView({Key? key}) : super(key: key);

  @override
  State<WebEmployeesView> createState() => _WebEmployeesViewState();
}

class _WebEmployeesViewState extends State<WebEmployeesView> {
  String searchParameter = '';
  List<Employee> searchResult = [];

  @override
  Widget build(BuildContext context) {
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
              WebListHeader(
                searchHint: 'Search employees',
                onSearch: (v) {
                  searchParameter = v;
                  setState(() {});
                },
                onPlusPressed: () {},
                currentMonth: DateTime.now(),
                title: 'Employees',
              ),
              const SizedBox(height: 10),
              ColumnRow(
                items: [
                  Text(
                    'Name',
                    style: AppTextStyle.boldSmall,
                  ),
                  Text(
                    'Duration',
                    style: AppTextStyle.boldSmall,
                  ),
                  Text(
                    'Last tracking',
                    style: AppTextStyle.boldSmall,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 0),
              Column(
                children: searchResult.map((Employee employee) {
                  return ColumnRowClickable(
                    items: [
                      Text(
                        '${employee.member.firstName} ${employee.member.lastName}',
                        style: AppTextStyle.small,
                      ),
                      Text(
                        printDuration(employee.totalDuration),
                        style: AppTextStyle.small,
                      ),
                      Text(
                        DateFormat('EEE, dd MMM HH:MM ')
                            .format(employee.lastActivity!),
                        style: AppTextStyle.small,
                      ),
                    ],
                    onPressed: () {
                      SideSheet.right(
                        width: 800,
                        context: context,
                        body: BlocProvider.value(
                          value: context.read<ClientsBloc>(),
                          child: UserStatProfile(
                            employee: employee,
                            state: state,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}