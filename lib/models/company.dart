import 'dart:html';

import 'package:agency_time/features/auth/models/services.dart';
import 'package:agency_time/features/auth/models/user.dart';
import 'package:agency_time/models/tag.dart';

class Company {
  String id;
  List<Tag> tags;
  List<Service> services;
  String companyName;
  List<UserData> members;
  Map roles;
  String countryCode;
  Subscription? subscription;

  Company({
    required this.tags,
    required this.services,
    required this.roles,
    required this.members,
    required this.companyName,
    required this.id,
    this.subscription,
    this.countryCode = 'USD',
  });

  Company copyWith({
    String? id,
    List<Tag>? tags,
    List<Service>? services,
    String? companyName,
    List<UserData>? members,
    Map? roles,
    String? countryCode,
    Subscription? subscription,
  }) {
    return Company(
      countryCode: countryCode ?? this.countryCode,
      subscription: subscription ?? this.subscription,
      tags: tags ?? this.tags,
      services: services ?? this.services,
      members: members ?? this.members,
      roles: roles ?? this.roles,
      companyName: companyName ?? this.companyName,
      id: id ?? this.id,
    );
  }

  static Company convert(Map value, String id) {
    List<Tag> tags = [];
    List<Service> services = [];
    Map<String, dynamic> tagsMap = value['tags'] != null
        ? Map<String, dynamic>.from(value['tags'])
        : const {};
    Map<String, dynamic> servicesMap = value['services'] != null
        ? Map<String, dynamic>.from(value['services'])
        : const {};

    tagsMap.forEach((key, value) {
      tags.add(Tag(
          id: int.parse(key),
          description: value['description'] ?? '',
          tag: value['tag'] ?? '',
          active: value['active'] ?? true));
      servicesMap.forEach((key, value) {
        services.add(Service(
            id: int.parse(key),
            description: value['description'] ?? '',
            title: value['title'] ?? '',
            active: value['active'] ?? true));
      });
    });

    return Company(
      id: id,
      tags: tags,
      services: services,
      roles: value['roles'] ?? {},
      subscription: value['subscription'] != null
          ? Subscription(
              active: value['subscription']['status'] == 'active',
              id: value['subscription']['subscriptionId'] ?? '',
              seats: value['subscription']['seats'])
          : null,
      members: [],
      countryCode: value['countryCode'],
      companyName: value['companyName'],
    );
  }
}

class Subscription {
  bool active;
  String id;
  int seats;

  Subscription({required this.active, required this.id, required this.seats});
}
