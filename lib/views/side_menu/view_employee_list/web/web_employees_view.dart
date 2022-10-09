import 'package:agency_time/models/employee.dart';
import 'package:agency_time/views/view_data_visualisation/web/user_stat_profile_view.dart';
import 'package:agency_time/models/company_month.dart';
import 'package:agency_time/utils/constants/text_styles.dart';
import 'package:agency_time/views/view_data_visualisation/data_visualisation_dependencies.dart';

import 'package:intl/intl.dart';

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
        // body: BlocBuilder<StatsBloc, StatsState>(
        //   builder: (context, state) {
        //     searchResult = state.selectedMonth.employees
        //         .where((element) =>
        //             '${element.member.firstName} ${element.member.lastName} '
        //                 .toLowerCase()
        //                 .contains(searchParameter.toLowerCase()))
        //         .toList();
        //     return ListView(
        //       children: [
        //         WebListHeader(
        //           searchHint: 'Search employees',
        //           onSearch: (v) {
        //             searchParameter = v;
        //             setState(() {});
        //           },
        //           onPlusPressed: () {},
        //           currentMonth: DateTime.now(),
        //           title: 'Employees',
        //         ),
        //         const SizedBox(height: 10),
        //         ColumnRow(
        //           items: [
        //             Text(
        //               'Name',
        //               style: AppTextStyle.boldSmall,
        //             ),
        //             Text(
        //               'Duration',
        //               style: AppTextStyle.boldSmall,
        //             ),
        //             Text(
        //               'Last tracking',
        //               style: AppTextStyle.boldSmall,
        //             ),
        //           ],
        //         ),
        //         const SizedBox(height: 20),
        //         const Divider(height: 0),
        //         Column(
        //           children: searchResult.map((Employee employee) {
        //             return ColumnRowClickable(
        //               items: [
        //                 Text(
        //                   '${employee.member.firstName} ${employee.member.lastName}',
        //                   style: AppTextStyle.small,
        //                 ),
        //                 Text(
        //                   printDuration(employee.totalDuration),
        //                   style: AppTextStyle.small,
        //                 ),
        //                 Text(
        //                   DateFormat('EEE, dd MMM HH:MM ')
        //                       .format(employee.lastActivity!),
        //                   style: AppTextStyle.small,
        //                 ),
        //               ],
        //               onPressed: () {
        //                 // SideSheet.right(
        //                 //   width: 800,
        //                 //   context: context,
        //                 //   body: BlocProvider.value(
        //                 //     value: context.read<ClientsBloc>(),
        //                 //     child: UserStatProfile(
        //                 //       employee: employee,
        //                 //       state: state,
        //                 //     ),
        //                 //   ),
        //                 // );
        //               },
        //             );
        //           }).toList(),
        //         ),
        //       ],
        //     );
        //   },
        // ),
        );
  }
}
