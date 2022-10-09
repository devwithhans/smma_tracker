import 'package:agency_time/views/side_menu/view_internal_list/web/web_clients_view.dart';
import 'package:agency_time/views/view_settings/web/settings_view.dart';
import 'package:agency_time/views/side_menu/view_company_performance/view_company_performance.dart';
import 'package:agency_time/views/side_menu/view_user_dash/web/user_data_view.dart';
import 'package:agency_time/views/side_menu/view_client_list/web/web_clients_view.dart';
import 'package:agency_time/views/side_menu/view_employee_list/web/web_employees_view.dart';
import 'package:flutter/material.dart';

List<MenuObject> webScreens = [
  MenuObject(
    icon: Icons.person,
    page: const UserDataView(),
    title: 'My stats',
  ),
  MenuObject(
    icon: Icons.bar_chart_rounded,
    page: const ViewCompanyPerformance(),
    title: 'Company stats',
  ),
  MenuObject(
    icon: Icons.store,
    page: const WebClientsView(),
    title: 'Clients',
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
  MenuObject(
    icon: Icons.settings,
    page: const SettingsView(),
    title: 'Settings',
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
