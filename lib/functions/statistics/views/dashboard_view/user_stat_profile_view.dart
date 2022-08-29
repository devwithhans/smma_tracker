import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/statistics/functions/get_employee_dash_data.dart';
import 'package:agency_time/functions/statistics/models/company_month.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/dashboard_view.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/dashboard_widgets/dashboard_data_display.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/clients/views/client_view/widgets/custom_app_bar.dart';
import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class UserStatProfile extends StatelessWidget {
  const UserStatProfile({required this.employee, required this.state, Key? key})
      : super(key: key);
  final Employee employee;
  final StatsState state;

  @override
  Widget build(BuildContext context) {
    Company company = context.read<AuthCubit>().state.company!;

    final moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: company.countryCode);
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
                  DashboardDataView(
                    loading: false,
                    moneyFormatter: moneyFormatter,
                    userId: employee.member.id,
                    dashData: getEmployeeDashData(
                      mrr: state.selectedMonth.mrr,
                      userId: employee.member.id,
                      employee: employee,
                      thisMonthEmployees: state.selectedMonth.employees,
                      lastMonthEmployees: state.compareMonth.employees,
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
