import 'package:agency_time/functions/statistics/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/statistics/models/company_month.dart';
import 'package:agency_time/functions/statistics/views/dashboard_view/user_stat_profile_view.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersData extends StatelessWidget {
  const UsersData({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Users:',
              style:
                  TextStyle(color: kColorGreyText, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Column(
              children: state.selectedMonth.employees.map((e) {
                return UserCard(
                  statState: state,
                  e: e,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    required this.statState,
    required this.e,
    this.web = false,
    Key? key,
  }) : super(key: key);

  final Employee e;
  final StatsState statState;
  final bool web;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => BlocProvider.value(
                      value: context.read<ClientsBloc>(),
                      child: UserStatProfile(
                        state: statState,
                        employee: e,
                      ),
                    )));
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
            Text(
              e.member.firstName,
              style: TextStyle(
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
          ],
        ),
      ),
    );
  }
}

class CustomTrackingDisplayWidget extends StatelessWidget {
  const CustomTrackingDisplayWidget({
    required this.value,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: kColorGreyText, fontSize: 12),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              height: 1,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
      ],
    );
  }
}
