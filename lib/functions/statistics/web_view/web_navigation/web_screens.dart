import 'package:agency_time/functions/authentication/models/company.dart';
import 'package:agency_time/functions/clients/web_view/web_clients_view/web_clients_listview.dart';
import 'package:agency_time/functions/clients/web_view/web_internals_view/web_internals_view.dart';
import 'package:agency_time/functions/statistics/views/settings_view/settings_view.dart';
import 'package:agency_time/views/data_visualisation_views/web/company_data_view.dart';
import 'package:agency_time/views/data_visualisation_views/web/user_data_view.dart';
import 'package:agency_time/views/lists_view/web/web_clients_view.dart';
import 'package:agency_time/views/lists_view/web/web_employees_view.dart';
import 'package:flutter/material.dart';

List<MenuObject> webScreens = [
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
