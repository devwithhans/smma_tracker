import 'package:agency_time/views/view_settings/web/settings_view.dart';
import 'package:agency_time/views/view_data_visualisation/web/company_data_view.dart';
import 'package:agency_time/views/view_data_visualisation/web/user_data_view.dart';
import 'package:agency_time/views/view_lists/web/web_clients_view.dart';
import 'package:agency_time/views/view_lists/web/web_employees_view.dart';
import 'package:flutter/material.dart';

List<MenuObject> webScreens = [
  MenuObject(
    icon: Icons.bar_chart_rounded,
    page: const CompanyDataView(),
    title: 'Company stats',
  ),
  MenuObject(
    icon: Icons.person,
    page: const UserDataView(),
    title: 'My stats',
  ),
  MenuObject(
    icon: Icons.store,
    page: const WebClientsView(),
    title: 'Clients',
  ),
  MenuObject(
    icon: Icons.group,
    page: const WebEmployeesView(),
    title: 'Employees',
  ),
  MenuObject(
    icon: Icons.house_rounded,
    page: const WebClientsView(),
    title: 'Internals',
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
