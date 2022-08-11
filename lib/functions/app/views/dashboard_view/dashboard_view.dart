import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/app/models/company_month.dart';
import 'package:agency_time/functions/app/views/dashboard_view/dashboard_widgets/custom_app_bar.dart';
import 'package:agency_time/functions/app/views/dashboard_view/total_view.dart';
import 'package:agency_time/functions/app/views/dashboard_view/user_stats.dart';
import 'package:agency_time/functions/authentication/blocs/auth_cubit/auth_cubit.dart';
import 'package:agency_time/functions/authentication/models/user.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/data_explanation.dart';
import 'package:agency_time/utils/widgets/revenue_card.dart';
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
    final moneyFormatter =
        NumberFormat.currency(locale: 'da', name: 'kr.', decimalDigits: 0);

    AppUser appUser = context.read<AuthCubit>().state.appUser!;
    String role = context.read<AuthCubit>().state.role!;
    print(role);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<StatsBloc, StatsState>(
          builder: (context, state) {
            bool loading = state.status == StatsStatus.loading;
            CompanyMonth selectedMonth = state.selectedMonth;
            if (state.status == StatsStatus.loading) return SizedBox();
            Map<String, Widget> views = {
              'My data': TotalTrackings(
                loading: loading,
                moneyFormatter: moneyFormatter,
                dashData: getEmployeeDashData(
                  mrr: selectedMonth.mrr,
                  nonFilterEmployee: state.selectedMonth.employees,
                  userId: appUser.id,
                ),
              ),
              'Total data': TotalTrackings(
                loading: loading,
                moneyFormatter: moneyFormatter,
                dashData: DashData(
                  clientDuration: selectedMonth.clientsDuration,
                  clientDurationChange: state.clientsDurationChange,
                  tags: selectedMonth.tags,
                  totalDuration: selectedMonth.totalDuration,
                  totalDurationChange: state.totalDurationChange,
                  totalHourlyRate: selectedMonth.totalHourlyRate,
                  totalHourlyRateChange: state.totalHourlyRateChange,
                  clientHourlyRateChange: state.clientsHourlyRateChange,
                  clientsHourlyRate: selectedMonth.clientsHourlyRate,
                  internalDuration: selectedMonth.internalDuration,
                  internalDurationChange: state.internalDurationChange,
                ),
              ),
              'Users data': UsersData(
                statState: state,
                employees: state.selectedMonth.employees,
              )
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
                          subText: state.mrrChange,
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

DashData getEmployeeDashData({
  required String userId,
  required List<Employee> nonFilterEmployee,
  double? mrr,
  double? lastMrr,
  Employee? employee,
}) {
  Employee selectedMonthEmployee;

  if (employee == null) {
    List<Employee> selectedMonthEmployeeList = nonFilterEmployee
        .where(
          (element) => element.member.id == userId,
        )
        .toList();
    if (selectedMonthEmployeeList.isEmpty) {
      selectedMonthEmployee = Employee(
        member: Member(email: '', id: '', firstName: '', lastName: ''),
        clientsDuration: Duration(),
        totalDuration: Duration(),
        clientsHourlyRate: 0,
        internalDuration: Duration(),
        totalHourlyRate: 0,
        tags: {},
      );
    } else {
      selectedMonthEmployee = selectedMonthEmployeeList.first;
    }
  } else {
    selectedMonthEmployee = employee;
  }

  List<Employee> compareMonthEmployeeList = nonFilterEmployee
      .where(
        (element) => element.member.id == userId,
      )
      .toList();
  Employee compareMonthEmployee = compareMonthEmployeeList.isNotEmpty
      ? compareMonthEmployeeList.first
      : Employee(
          member: selectedMonthEmployee.member,
          clientsDuration: Duration(),
          internalDuration: Duration(),
          totalHourlyRate: 0,
          clientsHourlyRate: 0,
          totalDuration: Duration(),
          tags: {},
        );

  Duration clientDurationChange = selectedMonthEmployee.clientsDuration -
      compareMonthEmployee.clientsDuration;

  double clientHourlyRateChange = getChangeProcentage(
      selectedMonthEmployee.clientsHourlyRate,
      compareMonthEmployee.clientsHourlyRate);

  Duration totalDurationChange =
      compareMonthEmployee.totalDuration - selectedMonthEmployee.totalDuration;

  double totalHourlyRate =
      getHourlyRate(mrr ?? 0, selectedMonthEmployee.totalDuration);

  double totalHourlyRateChange = getChangeProcentage(
    totalHourlyRate,
    compareMonthEmployee.totalHourlyRate,
  );

  Duration internalDurationChange = selectedMonthEmployee.internalDuration -
      compareMonthEmployee.internalDuration;

  return DashData(
    mrr: mrr,
    lastMrr: lastMrr,
    clientDuration: selectedMonthEmployee.clientsDuration,
    clientDurationChange: clientDurationChange,
    clientsHourlyRate: selectedMonthEmployee.clientsHourlyRate,
    clientHourlyRateChange: clientHourlyRateChange,
    totalDuration: selectedMonthEmployee.totalDuration,
    totalDurationChange: totalDurationChange,
    totalHourlyRate: totalHourlyRate,
    totalHourlyRateChange: totalHourlyRateChange,
    internalDuration: selectedMonthEmployee.internalDuration,
    internalDurationChange: internalDurationChange,
    tags: selectedMonthEmployee.tags,
  );
}

class CustomToggl extends StatelessWidget {
  const CustomToggl({
    required this.buttons,
    required this.selected,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final List<String> buttons;
  final String selected;
  final void Function(String selected) onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: buttons
            .map(
              (e) => Expanded(
                child: RawMaterialButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: selected != e
                                ? kColorGrey
                                : Colors.transparent)),
                    fillColor: selected == e ? Colors.black : Colors.white,
                    textStyle: TextStyle(
                      color: selected == e ? Colors.white : Colors.black,
                    ),
                    child: Text(e),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    onPressed: () {
                      onPressed(e);
                    }),
              ),
            )
            .toList());
  }
}
