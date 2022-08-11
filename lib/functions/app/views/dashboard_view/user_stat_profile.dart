import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/app/models/company_month.dart';
import 'package:agency_time/functions/app/views/dashboard_view/dashboard_view.dart';
import 'package:agency_time/functions/app/views/dashboard_view/total_view.dart';
import 'package:agency_time/functions/clients/views/client_view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class UserStatProfile extends StatelessWidget {
  const UserStatProfile({required this.employee, required this.state, Key? key})
      : super(key: key);
  final Employee employee;
  final StatsState state;

  @override
  Widget build(BuildContext context) {
    final moneyFormatter =
        NumberFormat.currency(locale: 'da', name: 'kr.', decimalDigits: 0);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: 'Stats for ${employee.member.firstName}',
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  TotalTrackings(
                    loading: false,
                    moneyFormatter: moneyFormatter,
                    userId: employee.member.id,
                    dashData: getEmployeeDashData(
                      mrr: state.selectedMonth.mrr,
                      userId: employee.member.id,
                      employee: employee,
                      nonFilterEmployee: state.selectedMonth.employees,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
