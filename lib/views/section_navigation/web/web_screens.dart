import 'package:agency_time/features/client/models/client.dart';
import 'package:agency_time/features/client/presentation/client_details/client_details.dart';
import 'package:agency_time/features/client/presentation/list_clients/clients_list.dart';
import 'package:agency_time/features/insights/presentation/insights.dart';
import 'package:agency_time/utils/widgets/buttons/main_button.dart';
import 'package:agency_time/views/side_menu/view_list_internal/web/web_internal_clients_view.dart';
import 'package:agency_time/views/view_settings/web/settings_view.dart';
import 'package:agency_time/views/side_menu/view_performance_company/view_company_performance.dart';
import 'package:agency_time/views/side_menu/view_performance_user/user_performance_view.dart';
import 'package:agency_time/views/view_list_client/web/web_clients_view.dart';
import 'package:agency_time/views/side_menu/view_list_employee/web/web_employees_view.dart';
import 'package:flutter/material.dart';

List<MenuObject> webScreens = [
  MenuObject(
    icon: Icons.store,
    page: ClientsView(),
    title: 'Clients',
  ),
  MenuObject(
    icon: Icons.person,
    page: Insights(),
    title: 'My stats',
  ),
  MenuObject(
    icon: Icons.settings,
    page: SettingsView(),
    title: 'Settings',
  ),
  MenuObject(
    icon: Icons.bar_chart_rounded,
    page: const ViewCompanyPerformance(),
    title: 'Company stats',
  ),
  MenuObject(
    icon: Icons.house_rounded,
    page: const WebInternalsView(),
    title: 'Internals',
  ),
  MenuObject(
    icon: Icons.group,
    page: const WebEmployeesView(),
    title: 'Employees',
  ),
];

class MenuObject {
  IconData icon;
  Widget page;
  String? dropDownTitle;
  String title;
  MenuObject({
    this.dropDownTitle,
    required this.icon,
    required this.page,
    required this.title,
  });
}
