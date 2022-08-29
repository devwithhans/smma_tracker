import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/statistics/functions/get_employee_dash_data.dart';
import 'package:agency_time/functions/statistics/models/company_month.dart';
import 'package:agency_time/functions/statistics/models/dashdata.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/dashboard_widgets/custom_app_bar.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/dashboard_widgets/dashboard_data_display.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/dashboard_widgets/user_stats.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/utils/functions/currency_formatter.dart';
import 'package:agency_time/utils/widgets/custom_toggl_button.dart';
import 'package:agency_time/utils/widgets/stats_card.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String selectedDash = 'Total';
  String selected = '';
  DateTime selectedDateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    AppUser appUser = context.read<AuthCubit>().state.appUser!;
    Company company = context.read<AuthCubit>().state.company!;
    String role = context.read<AuthCubit>().state.role!;
    final moneyFormatter =
        CustomCurrencyFormatter.getFormatter(countryCode: company.countryCode);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<StatsBloc, StatsState>(
          builder: (context, state) {
            bool loading = state.status == StatsStatus.loading;
            CompanyMonth selectedMonth = state.selectedMonth;
            if (state.status == StatsStatus.loading) return SizedBox();
            Map<String, Widget> views = {
              'Myself': DashboardDataView(
                loading: loading,
                moneyFormatter: moneyFormatter,
                dashData: getEmployeeDashData(
                  mrr: selectedMonth.mrr,
                  thisMonthEmployees: state.selectedMonth.employees,
                  lastMonthEmployees: state.compareMonth.employees,
                  userId: appUser.id,
                ),
              ),
              'Total': DashboardDataView(
                loading: loading,
                moneyFormatter: moneyFormatter,
                dashData: state.dashData!,
              ),
              'Users': UsersData()
            };

            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomAppBar(
                    selectedMonth: selectedDateTime,
                    onSelectMonth: () async {
                      DateTime? selection = await showMonthPicker(
                        firstDate: state.months.first.date ?? DateTime.now(),
                        lastDate: state.months.last.date ?? DateTime.now(),
                        context: context,
                        initialDate: state.selectedMonth.date ?? DateTime.now(),
                      );
                      if (selection != null) {
                        selectedDateTime = selection;
                        context
                            .read<StatsBloc>()
                            .add(GetStats(month: selection));
                        context
                            .read<ClientsBloc>()
                            .add(GetClientsWithMonth(month: selection));
                      }
                    },
                  ),
                  Expanded(
                      child: ListView(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          children: [
                        StatCard(
                          loading: loading,
                          title: 'Monthly revenue',
                          value: moneyFormatter.format(selectedMonth.mrr),
                          subText: state.dashData!.selectedMrr,
                        ),
                        const SizedBox(height: 10),
                        role == 'owner'
                            ? CustomToggl(
                                buttons: views.keys.toList(),
                                selected: selected.isNotEmpty
                                    ? selected
                                    : views.keys.first,
                                onPressed: (e) {
                                  selected = e;
                                  setState(() {});
                                },
                              )
                            : SizedBox(),
                        const SizedBox(height: 10),
                        views[selected.isNotEmpty
                                ? selected
                                : views.keys.first] ??
                            SizedBox(),
                      ]))
                ]);
          },
        ),
      ),
    );
  }
}
