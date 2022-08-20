import 'package:agency_time/functions/app/views/settings_view/settings_view.dart';
import 'package:agency_time/functions/app/web_view/web_employees.dart';
import 'package:agency_time/functions/app/web_view/web_overview.dart';
import 'package:agency_time/functions/clients/views/client_list_view/clients_view.dart';
import 'package:agency_time/functions/clients/views/internal_client_list_view/internal_client_list_view.dart';
import 'package:flutter/material.dart';

List<MenuObject> webScreens = [
  MenuObject(
    icon: Icons.bar_chart_rounded,
    page: const WebOverview(),
    title: 'Overview',
  ),
  MenuObject(
    icon: Icons.group,
    page: const WebEmployees(),
    title: 'Employees',
  ),
  MenuObject(
    icon: Icons.store,
    page: const ClientsView(),
    title: 'Clients',
  ),
  MenuObject(
    icon: Icons.house_rounded,
    page: const InternalClientsView(),
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
