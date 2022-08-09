import 'package:agency_time/functions/app/blocs/stats_bloc/stats_bloc.dart';
import 'package:agency_time/functions/app/models/stats.dart';
import 'package:agency_time/functions/app/views/dashboard_view/user_stat_profile.dart';
import 'package:agency_time/functions/clients/blocs/clients_bloc/clients_bloc.dart';
import 'package:agency_time/utils/constants/colors.dart';
import 'package:agency_time/utils/functions/print_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersData extends StatelessWidget {
  const UsersData({required this.statState, required this.employees, Key? key})
      : super(key: key);
  final List<Employee> employees;
  final StatsState statState;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Users:',
          style: TextStyle(color: kColorGreyText, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Column(
          children: employees.map((e) {
            return UserCard(
              statState: statState,
              e: e,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
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
                  duraton: e.clientsDuration,
                  title: 'Client hours',
                ),
                CustomTrackingDisplayWidget(
                  duraton: e.internalDuration,
                  title: 'Internal hours',
                ),
                CustomTrackingDisplayWidget(
                  duraton: e.totalDuration,
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
    required this.duraton,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  final Duration duraton;

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
          printDuration(duraton),
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
